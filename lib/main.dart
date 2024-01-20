import 'dart:convert';

import 'package:taskiee/body.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskiee/models/note.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:taskiee/screens/task_details.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/util_service.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:taskiee/services/note_service.dart';
import 'package:taskiee/services/theme_service.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:taskiee/services/subtask_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final navigator = GlobalKey<NavigatorState>();

NotificationAppLaunchDetails launchDetails;
AndroidDeviceInfo deviceInfo;
String versionName;
String userID;

void selectNotification(NotificationResponse response) async {
  final data = jsonDecode(response.payload) as Map<String, dynamic>;

  if (data.containsKey('task_id') || data.containsKey('dueDate')) {
    navigator.currentState.push(
      MaterialPageRoute(
        builder: (_) => TaskDetails(id: data['task_id'] ?? data['id']),
      ),
    );
  } else {
    showModal(
      context: navigator.currentState.context,
      builder: (_) => DataDialog(
        dataType: DataType.Note,
        data: Note.fromMap(data),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  timezone.initializeTimeZones();

  final channel = MethodChannel('com.dev.taskiee');
  const initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_icon');
  final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: null, macOS: null);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: selectNotification);

  await Hive.initFlutter();
  await UtilService.initialize();
  await ListService().initialize();
  await TaskService().initialize();
  await NoteService().initialize();
  await ThemeService().initialize();
  await LabelService().initialize();
  await SubTaskService().initialize();

  UtilService.markAsOldUser();
  UtilService.migrateOldData();

  launchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  versionName = await channel.invokeMethod('getVersionName');
  deviceInfo = await DeviceInfoPlugin().androidInfo;

  runApp(ProviderScope(child: TodoApp()));
}

class TodoApp extends StatefulHookWidget {
  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> with Utils {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>().requestPermission();

    WidgetsBinding.instance.window.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();

      setState(() {});
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getUIStyle(context),
      child: MaterialApp(
        home: getHome(),
        locale: getAppLocale(),
        navigatorKey: navigator,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getThemeData(context),
        onGenerateTitle: (context) => AppLocalizations.instance.w0,
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales:
            AppLocalizationsDelegate.locales.map((e) => Locale(e)),
      ),
    );
  }

  Widget getHome() {
    if (launchDetails.didNotificationLaunchApp) {
      final data = jsonDecode(launchDetails.notificationResponse.payload)
          as Map<String, dynamic>;

      if (data.containsKey('task_id') || data.containsKey('dueDate'))
        return TaskDetails(id: data['task_id'] ?? data['id']);
      else
        return Body(data: Note.fromMap(data));
    }

    return Body();
  }

  // ignore: missing_return
  static Locale getAppLocale() {
    final locales = AppLocalizationsDelegate.locales;

    switch (useProvider(themePod).appTheme.language) {
      case Language.Turkish:
        return Locale(locales[1]);
      case Language.English:
        return Locale(locales[0]);
    }
  }
}
