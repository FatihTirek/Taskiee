import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/widgets/fab.dart';
import 'package:taskiee/models/task.dart';
import 'package:taskiee/models/label.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/screens/reorder.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/list_card.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:taskiee/services/note_service.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/pickers/language_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:taskiee/dialogs/feedback_dialog.dart';
import 'package:taskiee/services/subtask_service.dart';
import 'package:taskiee/screens/notification_help.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskiee/dialogs/data_dialog.dart' show DataType;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Settings extends StatefulHookWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with Utils {
  Color onAppColor;
  ThemeData theme;
  Color appColor;
  Label preview;
  ThemePod pod;

  StreamSubscription subscription;

  final serviceTask = TaskService();
  final serviceList = ListService();
  final serviceNote = NoteService();
  final serviceLabel = LabelService();
  final serviceSubTask = SubTaskService();
  final localizations = AppLocalizations.instance;

  @override
  void didChangeDependencies() {
    subscription = InAppPurchase.instance.purchaseStream.listen((event) {
      if (event.first.status == PurchaseStatus.purchased) {
        InAppPurchase.instance.completePurchase(event.first);
      }
    }, onDone: () => subscription.cancel());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    pod = useProvider(themePod);
    appColor = pod.appTheme.color;
    onAppColor = getOnColor(appColor);
    preview = Label(name: localizations.p5(1), color: appColor);

    return Theme(
      data: theme.copyWith(
        unselectedWidgetColor: theme.textTheme.bodyText1.color.withOpacity(.48),
        canvasColor: theme.colorScheme.brightness == Brightness.light
            ? theme.colorScheme.surface
            : theme.colorScheme.onSurface,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 56.0),
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              toolbarHeight: 0,
              backgroundColor: theme.colorScheme.background,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...general(),
                ...lists(),
                ...labels(),
                ...tasks(),
                ...notifications(),
                ...backupRestore(),
                ...aboutApp(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> general() {
    final fontName = getFontName(pod.appTheme.font);
    final language = AppTheme.getLanguage(pod.appTheme.language);

    return [
      section(localizations.w106),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: handlePurchased,
          title: title(localizations.w111),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(Font.values, fontWidget, isFont: true),
          title: title(localizations.w116),
          trailing: Text(fontName, style: theme.textTheme.subtitle1),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w112),
          trailing: Text(language, style: theme.textTheme.subtitle1),
          onTap: () => showModal(context: context, builder: (_) => LanguagePicker()),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w117),
          onTap: () => showModalSheet(ThemeType.values, themeWidget),
          trailing: themeWidget(pod.appTheme.themeType, scale: false),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => pod.setColor(context),
          title: title(localizations.w118),
          trailing: colorWidget(appColor),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(FABShape.values, buttonShapeWidget),
          title: title(localizations.w119),
          trailing: Transform.scale(
            scale: 0.92,
            child: FAB(previewShape: pod.appTheme.fabShape),
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          title: title(localizations.w188),
          onChanged: pod.setDarkenBottomBarColor,
          value: pod.appTheme.darkenBottomBarColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ),
    ];
  }

  List<Widget> lists() {
    return [
      section(localizations.w51),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(RectShape.values, listShapeWidget),
          title: title(localizations.w120),
          trailing: ListCard(),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w131),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              onChanged: pod.setListIconSize,
              value: pod.appTheme.listIconSize,
              style: theme.textTheme.subtitle1,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: appColor),
              items: [
                DropdownMenuItem(
                  value: ListIconSize.Normal,
                  child: Text(localizations.w78),
                ),
                DropdownMenuItem(
                  value: ListIconSize.Big,
                  child: Text(localizations.w82),
                ),
                DropdownMenuItem(
                  value: ListIconSize.Bigger,
                  child: Text(localizations.w84),
                ),
              ],
            ),
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w123),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              onChanged: pod.setSortBarType,
              value: pod.appTheme.sortBarType,
              style: theme.textTheme.subtitle1,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: appColor),
              items: [
                DropdownMenuItem(
                  value: SortBarType.Normal,
                  child: Text(localizations.w78),
                ),
                DropdownMenuItem(
                  value: SortBarType.ColoredBorder,
                  child: Text(localizations.w85),
                ),
              ],
            ),
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w157),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              style: theme.textTheme.subtitle1,
              onChanged: pod.setListSortType,
              value: pod.appTheme.listSortType,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: appColor),
              items: [
                DropdownMenuItem(
                  value: SortType.AlphabeticAZ,
                  child: Text(localizations.w158),
                ),
                DropdownMenuItem(
                  value: SortType.AlphabeticZA,
                  child: Text(localizations.w159),
                ),
                DropdownMenuItem(
                  value: SortType.CreationNewest,
                  child: Text(localizations.w160),
                ),
                DropdownMenuItem(
                  value: SortType.CreationOldest,
                  child: Text(localizations.w161),
                ),
                DropdownMenuItem(
                  value: SortType.Custom,
                  child: Text(localizations.w152),
                ),
              ],
            ),
          ),
        ),
      ),
      pod.appTheme.listSortType == SortType.Custom
          ? sortTile(DataType.List)
          : const SizedBox(),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          onChanged: pod.setMoveBottomNewTask,
          value: pod.appTheme.moveBottomNewTask,
          title: title(localizations.w180),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          onChanged: pod.setMoveBottomCompleted,
          value: pod.appTheme.moveBottomCompleted,
          title: title(localizations.w181),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          title: title(localizations.w183),
          value: pod.appTheme.includeSubtask,
          onChanged: pod.setIncludeSubTask,
          subtitle: subTitle(localizations.w182),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ];
  }

  List<Widget> labels() {
    return [
      section(localizations.p5(2)),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(LabelType.values, labelTypeWidget),
          title: title(localizations.w171),
          trailing: LabelCard(
            label: preview,
            previewType: PreviewType.Label,
            labelType: pod.appTheme.outerLabelType,
            // labelPreviewHeight: 36,
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(RectShape.values, labelShapeWidget),
          title: title(localizations.w120),
          trailing: LabelCard(previewType: PreviewType.Shape),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w157),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              style: theme.textTheme.subtitle1,
              onChanged: pod.setLabelSortType,
              value: pod.appTheme.labelSortType,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: appColor),
              items: [
                DropdownMenuItem(
                  value: SortType.AlphabeticAZ,
                  child: Text(localizations.w158),
                ),
                DropdownMenuItem(
                  value: SortType.AlphabeticZA,
                  child: Text(localizations.w159),
                ),
                DropdownMenuItem(
                  value: SortType.CreationNewest,
                  child: Text(localizations.w160),
                ),
                DropdownMenuItem(
                  value: SortType.CreationOldest,
                  child: Text(localizations.w161),
                ),
                DropdownMenuItem(
                  value: SortType.Custom,
                  child: Text(localizations.w152),
                ),
              ],
            ),
          ),
        ),
      ),
      pod.appTheme.labelSortType == SortType.Custom
          ? sortTile(DataType.Label)
          : const SizedBox(),
    ];
  }

  List<Widget> tasks() {
    final taskLabelTypes = LabelType.values.toList()..removeAt(0);

    return [
      section(localizations.w53),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(taskLabelTypes, taskLabelTypeWidget),
          title: title(localizations.w125),
          trailing: LabelCard(
            label: preview,
            isTaskLabel: true,
            previewType: PreviewType.Label,
            labelType: pod.appTheme.innerLabelType,
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => showModalSheet(RectShape.values, taskLabelShapeWidget),
          title: title(localizations.w121),
          trailing: LabelCard(
            previewType: PreviewType.Shape,
            isTaskLabel: true,
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w130),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              onChanged: pod.setTaskDisplay,
              value: pod.appTheme.taskDisplay,
              style: theme.textTheme.subtitle1,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: appColor),
              items: [
                DropdownMenuItem(
                  value: TaskDisplay.All,
                  child: Text(localizations.w81),
                ),
                DropdownMenuItem(
                  value: TaskDisplay.Short,
                  child: Text(localizations.v0(5)),
                ),
                DropdownMenuItem(
                  value: TaskDisplay.Medium,
                  child: Text(localizations.v0(10)),
                ),
                DropdownMenuItem(
                  value: TaskDisplay.Long,
                  child: Text(localizations.v0(15)),
                ),
              ],
            ),
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w124),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              onChanged: pod.setDismissibleType,
              value: pod.appTheme.dismissibleType,
              style: theme.textTheme.subtitle1,
              icon: Icon(Icons.keyboard_arrow_down_outlined, color: appColor),
              items: [
                DropdownMenuItem(
                  value: DismissibleType.Colored,
                  child: Text(localizations.w79),
                ),
                DropdownMenuItem(
                  value: DismissibleType.ColoredBorder,
                  child: Text(localizations.w85),
                ),
              ],
            ),
          ),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          onChanged: pod.setStrikeThrough,
          value: pod.appTheme.strikeThrough,
          title: title(localizations.w173),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          onChanged: pod.setShowInCalendar,
          value: pod.appTheme.showInCalendar,
          title: title(localizations.w174),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: CheckboxListTile(
          activeColor: appColor,
          checkColor: onAppColor,
          onChanged: pod.setAutoDelete,
          value: pod.appTheme.autoDelete,
          title: title(localizations.w175),
          subtitle: subTitle(localizations.w176),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    ];
  }

  List<Widget> notifications() {
    return [
      section(localizations.w107),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NotificationHelp(),
            ),
          ),
          title: title(localizations.w142),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => invoke('openNotificationSettings'),
          title: title(localizations.w115),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: handleSound,
          title: title(localizations.w127),
        ),
      ),
      tileWidget(
        localizations.w128,
        handleVibration,
        pod.appTheme.vibration,
      ),
      tileWidget(
        localizations.w129,
        handleLights,
        pod.appTheme.lights,
      ),
    ];
  }

  List<Widget> backupRestore() {
    final text = deviceInfo.version.sdkInt >= 30
        ? '${localizations.w137}\n\n${localizations.w187}'
        : localizations.w137;

    return [
      section(localizations.w109),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => handleStorage(true),
          minVerticalPadding: 12,
          title: title(localizations.w135),
          subtitle: subTitle(text),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: handleStorage,
          minVerticalPadding: 12,
          title: title(localizations.w134),
          subtitle: subTitle(localizations.w136),
        ),
      ),
    ];
  }

  List<Widget> aboutApp() {
    return [
      section(localizations.w110),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () =>
              showModal(context: context, builder: (_) => FeedBackDialog()),
          title: title(localizations.w133),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: () => StoreRedirect.redirect(),
          title: title(localizations.w132),
          subtitle: subTitle(localizations.w71),
        ),
      ),
      Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(localizations.w0),
          subtitle: subTitle('${localizations.w80} $versionName'),
        ),
      ),
    ];
  }

  Widget sortTile(DataType dataType) {
    return Material(
      color: theme.colorScheme.surface,
      child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Reorder(dataType: dataType),
          ),
        ),
        title: title(localizations.w163),
      ),
    );
  }

  Widget section(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 0, 12),
      child: Text(
        text,
        style: theme.textTheme.headline3.copyWith(color: appColor),
      ),
    );
  }

  Widget title(String text) => Text(text, style: theme.textTheme.bodyText1);

  Widget subTitle(String text) {
    return Text(
      text,
      style: theme.textTheme.subtitle1.copyWith(
        color: theme.textTheme.subtitle1.color.withOpacity(.54),
      ),
    );
  }

  void handlePurchased() async {
    final details =
        await InAppPurchase.instance.queryProductDetails({'donation'});

    InAppPurchase.instance.buyConsumable(
        purchaseParam:
            PurchaseParam(productDetails: details.productDetails.first));
  }

  void handleSound() async {
    if (deviceInfo.version.sdkInt >= 26) {
      invoke('openChannelSettings');
    } else {
      final source = pod.appTheme.soundUri;
      final soundUri =
          await invoke('openSoundPicker', args: {"soundUri": source});

      if (soundUri != null) pod.setSoundUri(soundUri);
    }
  }

  void handleVibration(bool vibration) async {
    if (deviceInfo.version.sdkInt >= 26)
      invoke('openChannelSettings');
    else
      pod.setVibration(vibration);
  }

  void handleLights(bool lights) async {
    if (deviceInfo.version.sdkInt >= 26)
      invoke('openChannelSettings');
    else
      pod.setLights(lights);
  }

  void runRestore() async {
    final file = File('/storage/emulated/0/Download/taskiee_backup.json');

    if (await file.exists()) {
      var data;

      if (deviceInfo.version.sdkInt >= 30)
        data = jsonDecode(await invoke('openFile'));
      else
        data = jsonDecode(await file.readAsString());

      final isTaskiee = [
        serviceTask.table,
        serviceList.table,
        serviceLabel.table,
        serviceSubTask.table,
      ].every((e) => data.containsKey(e));

      if (isTaskiee) {
        final newBackup = !(data['newBackup'] ?? false);
        final include = data['includeSubtask'];

        if (include != null && include != pod.appTheme.includeSubtask) {
          final addIf = include == false;
          data[serviceList.table].forEach((e) {
            final values = data[serviceSubTask.table]
                .where((e1) => e1['listID'] == e['id']);
            final done = values
                .where((e1) => e1['completed'] == 1 || e1['completed'])
                .length;

            e['total'] = e['total'] + (addIf ? values.length : -values.length);
            e['done'] = e['done'] + (addIf ? done : -done);

            serviceList.write(e);
          });
        } else {
          data[serviceList.table].forEach((e) => serviceList.write(e));
        }

        data[serviceNote.table]?.forEach((e) => serviceNote.write(e));
        data[serviceLabel.table].forEach((e) => serviceLabel.write(e));

        if (newBackup) {
          data[serviceTask.table].forEach((e) {
            final subtasks = (data[serviceSubTask.table] as List)
                .where((e1) => e1['taskID'] == e['id'])
                .toList();

            subtasks.forEach((e1) {
              e1['listID'] = e['listID'];
              serviceSubTask.write(e1);
            });

            e['total'] = subtasks.length;
            e['done'] = subtasks
                .where((e1) => e1['completed'] == 1 || e1['completed'])
                .length;

            scheduleNotification(
                context, Task.fromMap(e).copyWith(getNID: true));
            serviceTask.write(e);
          });
        } else {
          data[serviceSubTask.table].forEach((e) => serviceSubTask.write(e));
          data[serviceTask.table].forEach((e) {
            scheduleNotification(
                context, Task.fromMap(e).copyWith(getNID: true));
            serviceTask.write(e);
          });
        }

        showToast(localizations.w96);
      } else {
        showToast(localizations.w98);
      }
    } else {
      showToast(localizations.w99);
    }
  }

  void runBackup() async {
    final map = Map();

    map['newBackup'] = true;
    map['includeSubtask'] = pod.appTheme.includeSubtask;
    map[serviceTask.table] = serviceTask.values();
    map[serviceList.table] = serviceList.values();
    map[serviceNote.table] = serviceNote.values();
    map[serviceLabel.table] = serviceLabel.values();
    map[serviceSubTask.table] = serviceSubTask.values();

    if (deviceInfo.version.sdkInt >= 30) {
      await invoke('createFile', args: {
        'json': jsonEncode(map),
        'error': localizations.w97,
        'success': localizations.w95,
      });
    } else {
      const path = '/storage/emulated/0/Download/taskiee_backup.json';
      await File(path).create(recursive: true)
        ..writeAsString(jsonEncode(map)).then(
          (_) => showToast(localizations.w95),
          onError: (_) => showToast(localizations.w97),
        );
    }
  }

  void handleStorage([bool backup = false]) async {
    final run = () {
      if (backup)
        runBackup();
      else
        runRestore();
    };

    if (deviceInfo.version.sdkInt < 33) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();

        if (await Permission.storage.isGranted) {
          run();
        }
      } else {
        run();
      }
    } else {
      run();
    }
  }

  void showModalSheet(List enums, Widget Function(dynamic value) widget,
      {bool isFont = false}) {
    showMaterialModalBottomSheet(
        context: context,
        barrierColor: Colors.black54,
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
        ),
        builder: (_) {
          if (!isFont) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: enums.map((e) => widget(e)).toList(),
              ),
            );
          }

          final painter = TextPainter(
            text: TextSpan(
              text: 'PlaceHolder',
              style: theme.textTheme.headline4,
            ),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr,
          )..layout();

          return ScrollConfiguration(
            behavior: NonGlowBehavior(),
            child: SizedBox(
              height: 2 * (painter.size.height + 32) + 40,
              child: MasonryGridView(
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                scrollDirection: Axis.horizontal,
                children: enums.map((e) => Center(child: widget(e))).toList(),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
              ),
            ),
          );
        });
  }

  Widget tileWidget(String text, Function(bool value) onTap, bool value) {
    if (deviceInfo.version.sdkInt >= 26) {
      return Material(
        color: theme.colorScheme.surface,
        child: ListTile(
          title: title(text),
          onTap: () => onTap(false),
        ),
      );
    }

    return Material(
      color: theme.colorScheme.surface,
      child: Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: SwitchListTile(
          value: value,
          onChanged: onTap,
          title: title(text),
          activeColor: appColor,
          inactiveThumbColor: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget colorWidget(Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget themeWidget(dynamic theme, {bool scale = true}) {
    final themeData = AppTheme.getThemeData(context, themeType: theme);
    final isActive = theme == pod.appTheme.themeType && scale;

    return GestureDetector(
      onTap: scale ? () => pod.setTheme(context, theme) : null,
      child: Container(
        width: scale ? 64 : 42,
        height: scale ? 64 : 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: themeData.colorScheme.background,
          borderRadius: BorderRadius.circular(2),
          border: isActive
              ? Border.all(color: appColor, width: 1.5)
              : Border.all(width: 1.5),
        ),
        child: Container(
          width: scale ? 44.5 : 29,
          height: scale ? 44.5 : 29,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: themeData.colorScheme.surface,
          ),
          child: Container(
            width: scale ? 28 : 18,
            height: scale ? 28 : 18,
            decoration: BoxDecoration(
              color: themeData.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget fontWidget(dynamic appFont) {
    final fontName = getFontName(appFont);
    final isActive = appFont == pod.appTheme.font;

    return GestureDetector(
      onTap: () => pod.setFont(context, appFont),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(fontName, style: theme.textTheme.headline4),
        ),
      ),
    );
  }

  String getFontName(Font font) => font.toString().substring(5);

  Widget buttonShapeWidget(dynamic buttonShape) {
    final isActive = buttonShape == pod.appTheme.fabShape;

    return GestureDetector(
      onTap: () => pod.setButtonShape(context, buttonShape),
      child: Material(
        elevation: 2,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Center(child: FAB(previewShape: buttonShape)),
        ),
      ),
    );
  }

  // ignore: missing_return
  EdgeInsets getButtonShapePadding(FABShape fabShape, bool isActive) {
    switch (fabShape) {
      case FABShape.RRect:
        return EdgeInsets.all(isActive ? 16 : 17);
      case FABShape.Hexagon:
        return EdgeInsets.symmetric(
            horizontal: isActive ? 12.2 : 13.2, vertical: isActive ? 15 : 16);
      case FABShape.Circular:
        return isActive ? const EdgeInsets.all(15) : const EdgeInsets.all(16);
    }
  }

  Widget listShapeWidget(dynamic listShape) {
    final isActive = listShape == pod.appTheme.listShape;

    return GestureDetector(
      onTap: () => pod.setListShape(context, listShape),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListCard(listShape: listShape),
        ),
      ),
    );
  }

  Widget labelShapeWidget(dynamic labelShape) {
    final isActive = labelShape == pod.appTheme.outerLabelShape;

    return GestureDetector(
      onTap: () => pod.setLabelShape(context, labelShape),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LabelCard(
            previewType: PreviewType.Shape,
            labelShape: labelShape,
          ),
        ),
      ),
    );
  }

  Widget taskLabelShapeWidget(dynamic labelShape) {
    final isActive = labelShape == pod.appTheme.innerLabelShape;

    return GestureDetector(
      onTap: () => pod.setLabelShape(context, labelShape, task: true),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LabelCard(
            isTaskLabel: true,
            labelShape: labelShape,
            previewType: PreviewType.Shape,
          ),
        ),
      ),
    );
  }

  Widget labelTypeWidget(dynamic labelType) {
    final isActive = labelType == pod.appTheme.outerLabelType;

    return GestureDetector(
      onTap: () => pod.setLabelType(context, labelType),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LabelCard(
            label: preview,
            labelType: labelType,
            previewType: PreviewType.Label,
            // labelPreviewHeight: 36,
          ),
        ),
      ),
    );
  }

  Widget taskLabelTypeWidget(dynamic labelType) {
    final isActive = labelType == pod.appTheme.innerLabelType;

    return GestureDetector(
      onTap: () => pod.setLabelType(context, labelType, task: true),
      child: Material(
        elevation: 1,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: getSide(isActive),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LabelCard(
            label: preview,
            isTaskLabel: true,
            labelType: labelType,
            previewType: PreviewType.Label,
          ),
        ),
      ),
    );
  }

  BorderSide getSide(bool isActive) {
    return isActive ? BorderSide(color: appColor, width: 1.5) : BorderSide.none;
  }
}
