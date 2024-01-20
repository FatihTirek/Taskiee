import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:taskiee/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskiee/models/note.dart';
import 'package:taskiee/models/task.dart';
import 'package:taskiee/models/repeat.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/screens/modal_sheet.dart';
import 'package:taskiee/dialogs/focus_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:timezone/timezone.dart' as timezone;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

extension StringExtension on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
}

mixin Utils {
  Future invoke(String method, {Map args}) async =>
      await MethodChannel('com.dev.taskiee').invokeMethod(method, args);

  void showToast(String message) =>
      invoke('showToast', args: {'message': message});

  Future<bool> onWillPop(BuildContext context) async {
    final pod = context.read(utilsPod);

    if (pod.isShowing) {
      pod.isShowing = false;
      return false;
    }

    return true;
  }

  void onPop(BuildContext context) async {
    ScaffoldMessenger.maybeOf(context).removeCurrentSnackBar();
    Navigator.pop(context);
  }

  Color getOnColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  int sortTasksByImportance(a, b) {
    if (a.important == b.important)
      return 0;
    else if (a.important)
      return -1;
    else
      return 1;
  }

  int sortNotesByImportance(a, b) {
    if (a.pinned == b.pinned)
      return a.creationDate.compareTo(b.creationDate);
    else if (a.pinned) return -1;

    return 1;
  }

  static bool serializer(dynamic value) {
    if (value is bool) return value;
    return value == 1;
  }

  SystemUiOverlayStyle getUIStyle(BuildContext context, {ThemeType themeType}) {
    final theme = AppTheme.getThemeData(context, themeType: themeType);
    final divider = theme.colorScheme.brightness == Brightness.light
        ? Colors.black.withOpacity(.24)
        : Colors.black.withOpacity(.59);

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: divider,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarColor: theme.colorScheme.surface,
      systemNavigationBarIconBrightness:
          theme.colorScheme.brightness == Brightness.light
              ? Brightness.dark
              : Brightness.light,
    );
  }

  // ignore: missing_return
  String toReadableSubText(BuildContext context, List weekDays) {
    if (weekDays != null) {
      final locale = Localizations.localeOf(context).languageCode;
      final days = DateFormat.EEEE(locale).dateSymbols.STANDALONESHORTWEEKDAYS;

      weekDays = [...weekDays];
      weekDays.sort();

      switch (MaterialLocalizations.of(context).firstDayOfWeekIndex) {
        case 1:
          break;
        case 6:
          if (weekDays.last == 7) {
            weekDays.removeLast();
            weekDays.insert(0, 7);

            if (weekDays.last == 6) {
              weekDays.removeLast();
              weekDays.insert(0, 6);
            }
          }
          break;
        default:
          if (weekDays.last == 7) {
            weekDays.removeLast();
            weekDays.insert(0, 7);
          }
          break;
      }

      final value =
          weekDays.map((e) => days.elementAt(e == 7 ? 0 : e)).toString();
      return value.substring(1, value.length - 1);
    }
  }

  // ignore: missing_return
  String toReadableText(BuildContext context, int amount, RepeatType type) {
    switch (type) {
      case RepeatType.Days:
        return AppLocalizations.instance.p1(amount);
      case RepeatType.Weeks:
        return AppLocalizations.instance.p2(amount);
      case RepeatType.Months:
        return AppLocalizations.instance.p3(amount);
      case RepeatType.Years:
        return AppLocalizations.instance.p4(amount);
    }
  }

  String toLocalizedDate(
    BuildContext context,
    DateTime date, {
    TimeOfDay time,
    bool shrink = false,
  }) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final datePart = DateUtils.dateOnly(date);
    final localizations = Localizations.localeOf(context);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    var dateFormatWithYear =
        DateFormat('E MMM d, y', localizations.languageCode);
    var dateFormatWithoutYear =
        DateFormat('EEEE, MMM d', localizations.languageCode);
    var dateFormatWithoutYearShrunken =
        DateFormat('E, MMM d', localizations.languageCode);

    var result;

    if (datePart == yesterday) {
      result = AppLocalizations.instance.w58;
    } else if (datePart == today) {
      result = AppLocalizations.instance.w56;
    } else if (datePart == tomorrow) {
      result = AppLocalizations.instance.w57;
    } else if (datePart.year == now.year) {
      result = shrink
          ? dateFormatWithoutYearShrunken.format(datePart)
          : dateFormatWithoutYear.format(datePart);
    } else {
      result = dateFormatWithYear.format(datePart);
    }

    if (time != null) {
      return result + ', ' + time.format(context);
    }

    return result;
  }

  String getCreatedTime(BuildContext context, DateTime dateTime) {
    final now = DateTime.now();
    final date = DateUtils.dateOnly(dateTime);

    if (date == DateUtils.dateOnly(now)) {
      if (now.difference(dateTime).inMinutes == 0) {
        return AppLocalizations.instance.w105;
      } else if (now.difference(dateTime).inHours == 0) {
        final minute = now.difference(dateTime).inMinutes;
        return AppLocalizations.instance.v1(minute);
      } else {
        final hour = now.difference(dateTime).inHours;
        return AppLocalizations.instance.v2(hour);
      }
    } else {
      return AppLocalizations.instance.v3(toLocalizedDate(context, date));
    }
  }

  // ignore: missing_return
  DateTime generateDate(DateTime dateTime, Repeat repeat) {
    final today = DateUtils.dateOnly(DateTime.now());

    if (dateTime == null) {
      if (repeat.repeatType == RepeatType.Weeks)
        return today.add(Duration(days: _valueToAdd(null, repeat)));

      return today;
    }

    dateTime = repeat.dueFrom == DueFrom.OldDue
        ? dateTime
        : DateTime(
            today.year,
            today.month,
            today.day,
            dateTime.hour,
            dateTime.minute,
          );
    final datePart = DateUtils.dateOnly(dateTime);
    final isPast = dateTime.isBefore(today);

    print(isPast);
    print(repeat.amount);

    final modulus = repeat.repeatType == RepeatType.Days
        ? today.difference(datePart).inDays % repeat.amount
        : repeat.repeatType == RepeatType.Months
            ? (today.month - datePart.month).abs() % repeat.amount
            : (today.year - datePart.year).abs() % repeat.amount;
    final step = repeat.repeatType == RepeatType.Weeks
        ? _valueToAdd(isPast ? today : dateTime, repeat)
        : isPast
            ? repeat.amount - modulus
            : repeat.amount;
    final date = isPast ? today : datePart;

    switch (repeat.repeatType) {
      case RepeatType.Days:
        return modulus == 0 && isPast
            ? DateTime(today.year, today.month, today.day, dateTime.hour,
                dateTime.minute)
            : DateTime(date.year, date.month, date.day + step, dateTime.hour,
                dateTime.minute);

      case RepeatType.Weeks:
        return repeat.weekDays.contains(today.weekday) && isPast
            ? DateTime(today.year, today.month, today.day, dateTime.hour,
                dateTime.minute)
            : DateTime(date.year, date.month, date.day + step, dateTime.hour,
                dateTime.minute);

      case RepeatType.Months:
        return modulus == 0 && isPast
            ? DateTime(today.year, today.month + step, dateTime.day,
                dateTime.hour, dateTime.minute)
            : DateTime(date.year, date.month + step, dateTime.day,
                dateTime.hour, dateTime.minute);

      case RepeatType.Years:
        return modulus == 0 && isPast
            ? DateTime(today.year + step, dateTime.month, dateTime.day,
                dateTime.hour, dateTime.minute)
            : DateTime(date.year + step, dateTime.month, dateTime.day,
                dateTime.hour, dateTime.minute);
    }
  }

  int _valueToAdd(DateTime dateTime, Repeat repeat) {
    final weekDays = repeat.weekDays;

    if (dateTime == null && weekDays.contains(DateTime.now().weekday)) return 0;

    weekDays.sort();

    final checkedDay = dateTime?.weekday ?? DateTime.now().weekday;
    final nextDay = weekDays.firstWhere((e) => e > checkedDay,
        orElse: () => weekDays.first);

    if (nextDay > checkedDay)
      return nextDay - checkedDay;
    else
      return (7 - checkedDay) + nextDay + ((repeat.amount - 1) * 7);
  }

  void scheduleNotification(BuildContext context, Task task, {appTheme}) async {
    if (task.reminder != null && !task.completed && task.reminder.isAfter(DateTime.now())) {
      flutterLocalNotificationsPlugin.cancel(task.notificationID);

      final list = ListService().getFromID(task.listID);
      final theme = appTheme ?? context?.read(themePod)?.appTheme;
      final soundUri = theme.soundUri ?? await invoke('getSoundUri');
      final scheduledDate =
          timezone.TZDateTime.from(task.reminder, timezone.local);
      final Int64List vibrationPattern = Int64List(5);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 250;
      vibrationPattern[2] = 250;
      vibrationPattern[3] = 250;
      vibrationPattern[4] = 250;

      final details = AndroidNotificationDetails(
        'Task_Notification_ID',
        AppLocalizations.instance.w53,
        ledOnMs: 1000,
        ledOffMs: 1000,
        showWhen: true,
        playSound: true,
        autoCancel: true,
        color: list.color,
        ledColor: Colors.white,
        priority: Priority.high,
        enableLights: theme.lights,
        importance: Importance.high,
        enableVibration: theme.vibration,
        vibrationPattern: vibrationPattern,
        visibility: NotificationVisibility.public,
        sound: UriAndroidNotificationSound(soundUri),
        category: AndroidNotificationCategory.reminder,
        styleInformation: BigTextStyleInformation(
          task.body,
          contentTitle: list.name,
          summaryText: task.important ? AppLocalizations.instance.w72 : null,
        ),
      );

      flutterLocalNotificationsPlugin.zonedSchedule(
        task.notificationID,
        list.name,
        task.body,
        scheduledDate,
        NotificationDetails(android: details),
        androidAllowWhileIdle: true,
        payload: jsonEncode({'task_id': task.id}),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void scheduleNoteNotification(Note note, AppTheme appTheme) async {
    final localizations = AppLocalizations.instance;

    if (note.reminder.isAfter(DateTime.now())) {
      final soundUri = appTheme.soundUri ?? await invoke('getSoundUri');
      final scheduledDate =
          timezone.TZDateTime.from(note.reminder, timezone.local);

      final Int64List vibrationPattern = Int64List(5);
      vibrationPattern[0] = 0;
      vibrationPattern[1] = 250;
      vibrationPattern[2] = 250;
      vibrationPattern[3] = 250;
      vibrationPattern[4] = 250;

      final details = AndroidNotificationDetails(
        'Note_Notification_ID',
        localizations.w54,
        ledOnMs: 1000,
        ledOffMs: 1000,
        showWhen: true,
        playSound: true,
        autoCancel: true,
        color: appTheme.color,
        ledColor: Colors.white,
        priority: Priority.high,
        importance: Importance.high,
        enableLights: appTheme.lights,
        enableVibration: appTheme.vibration,
        vibrationPattern: vibrationPattern,
        visibility: NotificationVisibility.public,
        sound: UriAndroidNotificationSound(soundUri),
        category: AndroidNotificationCategory.reminder,
        styleInformation: BigTextStyleInformation(
          note.content,
          contentTitle: note.content,
        ),
      );

      flutterLocalNotificationsPlugin.zonedSchedule(
        note.notificationID,
        note.content,
        note.content,
        scheduledDate,
        NotificationDetails(android: details),
        androidAllowWhileIdle: true,
        payload: jsonEncode(Note.toMap(note)),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void showMyModalSheet(BuildContext context, {Color color, dynamic data}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = colorScheme.brightness == Brightness.light;

    showMaterialModalBottomSheet(
      context: context,
      barrierColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      backgroundColor: isLight ? Colors.white : colorScheme.background,
      builder: (_) => ModalSheet(color: color, data: data),
    );
  }

  void showOptionDialog(BuildContext context, Widget widget) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        fullscreenDialog: true,
        barrierColor: Colors.black.withOpacity(.575),
        transitionDuration: kThemeAnimationDuration,
        pageBuilder: (_, animation, __) => FadeTransition(
          opacity: Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: FocusDialog(child: widget, size: box.size, offset: offset),
        ),
      ),
    );
  }

  Future<DateTime> openDatePicker(
      {Color color, DateTime initialDate, BuildContext context}) {
    final now = DateTime.now();
    final textTheme = Theme.of(context).textTheme;

    return showDatePicker(
      firstDate: now,
      context: context,
      lastDate: DateTime(now.year + 50, 0, 0),
      cancelText: AppLocalizations.instance.w64,
      confirmText: AppLocalizations.instance.w63,
      initialDate: initialDate?.isAfter(now) ?? false ? initialDate : now,
      builder: (_, child) => Theme(
        data: Theme.of(context).copyWith(
          splashColor: color.withOpacity(.2),
          highlightColor: color.withOpacity(.2),
          colorScheme: ColorScheme.light(
            primary: color,
            secondary: color,
            onPrimary: getOnColor(color),
            onSurface: textTheme.bodyText1.color,
          ),
          textTheme: TextTheme(
            button: textTheme.bodyText1,
            caption: textTheme.bodyText1,
            overline: textTheme.subtitle2,
            subtitle1: textTheme.bodyText1,
            subtitle2: textTheme.subtitle1,
            bodyText1: textTheme.bodyText1,
            headline4: textTheme.headline1.copyWith(fontSize: 32),
          ),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: textTheme.subtitle2,
            labelStyle: textTheme.bodyText1.copyWith(color: color),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color),
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  Future<TimeOfDay> openTimePicker(
      {Color color, BuildContext context, DateTime datetime}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = colorScheme.brightness == Brightness.light;

    return showTimePicker(
      context: context,
      cancelText: AppLocalizations.instance.w64,
      confirmText: AppLocalizations.instance.w63,
      initialTime: datetime?.isAfter(DateTime.now()) ?? false
          ? TimeOfDay.fromDateTime(datetime)
          : TimeOfDay.now(),
      builder: (_, child) => Theme(
        data: ThemeData(
          splashColor: color.withOpacity(.2),
          highlightColor: color.withOpacity(.2),
          timePickerTheme: TimePickerThemeData(
            dayPeriodTextColor: MaterialStateColor.resolveWith(
              (states) => _dayPeriodTextColor(states, context, color),
            ),
            dayPeriodTextStyle: textTheme.bodyText1,
            dayPeriodBorderSide: BorderSide(color: colorScheme.onSurface),
            backgroundColor: isLight ? Colors.white : colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            hourMinuteShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            hourMinuteColor: MaterialStateColor.resolveWith(
              (states) => _hourMinuteColor(states, context, color, isLight),
            ),
            hourMinuteTextColor: MaterialStateColor.resolveWith(
              (states) => _hourMinuteTextColor(states, context, color),
            ),
            dialHandColor: color,
            hourMinuteTextStyle: textTheme.headline1.copyWith(fontSize: 32),
            dialBackgroundColor:
                isLight ? colorScheme.onSurface : colorScheme.surface,
            dialTextColor: MaterialStateColor.resolveWith(
              (states) => _dialTextColor(states, context, color),
            ),
            entryModeIconColor: textTheme.bodyText1.color,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              contentPadding: const EdgeInsets.only(top: 16),
              fillColor: isLight ? colorScheme.onSurface : colorScheme.surface,
              hintStyle: textTheme.headline1.copyWith(
                fontSize: 32,
                color: isLight ? Colors.grey : colorScheme.background,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: color),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.red),
              ),
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
            helpTextStyle: textTheme.subtitle2,
          ),
          colorScheme: ColorScheme.light(
            primary: color,
            secondary: color,
          ),
          textTheme: TextTheme(
            button: textTheme.bodyText1,
            caption: textTheme.subtitle2,
          ),
        ),
        child: child,
      ),
    );
  }

  Color _hourMinuteColor(Set<MaterialState> states, BuildContext context,
      Color color, bool isLight) {
    if (states.contains(MaterialState.selected)) return color.withOpacity(.2);

    return isLight
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.surface;
  }

  Color _hourMinuteTextColor(
      Set<MaterialState> states, BuildContext context, Color color) {
    if (states.contains(MaterialState.selected)) return color;

    return Theme.of(context).textTheme.bodyText1.color;
  }

  Color _dialTextColor(
      Set<MaterialState> states, BuildContext context, Color color) {
    if (states.contains(MaterialState.selected)) return getOnColor(color);

    return Theme.of(context).textTheme.bodyText1.color;
  }

  Color _dayPeriodTextColor(
      Set<MaterialState> states, BuildContext context, Color color) {
    if (states.contains(MaterialState.selected)) return color;

    return Theme.of(context).textTheme.bodyText1.color;
  }

  List<Widget> actions(
    BuildContext context, {
    Color color,
    String leftAction,
    String rightAction,
    Function onPressed,
  }) {
    final appColor = context.read(themePod).appTheme.color;
    final overlay = (color ?? appColor).withOpacity(.12);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(shape),
          overlayColor: MaterialStateProperty.all(overlay),
        ),
        child: Text(
          leftAction ?? AppLocalizations.instance.w64,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(shape),
          overlayColor: MaterialStateProperty.all(overlay),
        ),
        child: Text(
          rightAction ?? AppLocalizations.instance.w63,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: color ?? appColor),
        ),
      ),
    ];
  }

  Animation scaleAnim(AnimationController controller) {
    return Tween(begin: 1.0, end: 0.94).animate(controller);
  }

  Animation<double> fadeInAnim(AnimationController controller) {
    return Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  Animation<double> fadeOutAnim(AnimationController controller) {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
  }
}

class NonGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(_, Widget child, __) => child;
}
