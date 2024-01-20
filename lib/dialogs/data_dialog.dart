import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/note.dart';
import 'package:taskiee/models/label.dart';
import 'package:line_icons/line_icons.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pickers/icon_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/pickers/color_picker.dart';
import 'package:taskiee/services/note_service.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/dialogs/delete_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/util_service.dart';
import 'package:taskiee/services/label_service.dart';

enum DataType { List, Label, Note }

// ignore: must_be_immutable
class DataDialog extends HookWidget with Utils {
  final Color color;
  final dynamic data;
  final DataType dataType;

  DataDialog({this.color, this.data, this.dataType});

  ValueNotifier<IconData> selectedIcon;
  ValueNotifier<Color> selectedColor;
  TextEditingController controller;
  ValueNotifier<DateTime> reminder;
  ValueNotifier<bool> pinned;
  Color currentColor;
  ThemeData theme;
  ThemePod pod;
  bool isLight;

  final localizations = AppLocalizations.instance;

  @override
  Widget build(BuildContext context) {
    pod = useProvider(themePod);
    currentColor = dataType == DataType.Note
        ? pod.appTheme.color
        : data?.color ?? color ?? pod.appTheme.color;

    theme = Theme.of(context);
    isLight = theme.colorScheme.brightness == Brightness.light;

    switch (dataType) {
      case DataType.List:
        selectedColor = useState(currentColor);
        controller = useTextEditingController(text: data?.name);
        selectedIcon = useState(data?.iconData ?? LineIcons.bars);
        break;
      case DataType.Label:
        selectedColor = useState(currentColor);
        controller = useTextEditingController(text: data?.name);
        break;
      case DataType.Note:
        reminder = useState(data?.reminder);
        pinned = useState(data?.pinned ?? false);
        controller = useTextEditingController(text: data?.content);
        break;
    }

    var title;
    var content;

    switch (dataType) {
      case DataType.List:
        title = data != null ? localizations.w13 : localizations.w10;
        content = Column(
          children: [
            Row(
              children: [
                button(
                  () => onTapIcon(context, currentColor),
                  Icon(
                    selectedIcon.value,
                    color: theme.textTheme.bodyText1.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                button(() => onTapColor(context), widget()),
              ],
            ),
            const SizedBox(height: 12),
            textField(currentColor),
          ],
        );
        break;
      case DataType.Label:
        title = data != null ? localizations.w14 : localizations.w11;
        content = IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              button(() => onTapColor(context), widget()),
              const SizedBox(width: 8),
              textField(currentColor),
            ],
          ),
        );
        break;
      case DataType.Note:
        title = data != null ? localizations.w169 : localizations.w170;
        content = Column(
          children: [
            Row(
              children: [
                button(
                  () => onTapReminder(context, currentColor),
                  Icon(
                    reminder.value?.isAfter(DateTime.now()) ?? false
                        ? Icons.notifications_active_sharp
                        : Icons.notifications_outlined,
                    color: theme.textTheme.bodyText1.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                button(
                  () => pinned.value = !pinned.value,
                  Icon(
                    pinned.value ? Icons.push_pin : Icons.push_pin_outlined,
                    color: theme.textTheme.bodyText1.color,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            textField(currentColor),
          ],
        );
        break;
    }

    return ScrollConfiguration(
      behavior: NonGlowBehavior(),
      child: AlertDialog(
        scrollable: true,
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.headline2.copyWith(color: currentColor),
            ),
            dataType == DataType.Note && data != null
                ? GestureDetector(
                    onTap: () => onTapDelete(context, currentColor),
                    child: Container(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.delete_outline,
                        color: getOnColor(currentColor),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        content: SizedBox(child: content, width: 296),
        actions: actions(
          context,
          color: currentColor,
          onPressed: () => onTapDone(context),
        ),
      ),
    );
  }

  Widget textField(Color currentColor) {
    var text;

    switch (dataType) {
      case DataType.List:
        text = localizations.w28;
        break;
      case DataType.Label:
        text = localizations.w29;
        break;
      case DataType.Note:
        text = localizations.w167;
        break;
    }

    final child = Theme(
      data: theme.copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: currentColor.withOpacity(.4),
            selectionHandleColor: currentColor,
            cursorColor: currentColor,
          ),
          colorScheme: theme.colorScheme.copyWith(secondary: currentColor)),
      child: TextField(
        minLines: 1,
        controller: controller,
        cursorColor: currentColor,
        style: theme.textTheme.bodyText1,
        maxLines: dataType == DataType.Note ? 6 : 1,
        maxLength: dataType == DataType.Note ? null : 36,
        decoration: InputDecoration(
          labelText: text,
          enabledBorder: inputBorder(),
          focusedBorder: inputBorder(focus: true),
          errorBorder: inputBorder(error: true),
          counterStyle: theme.textTheme.subtitle2,
          focusedErrorBorder: inputBorder(error: true),
          labelStyle: theme.textTheme.bodyText1.copyWith(
              color: theme.textTheme.bodyText1.color.withOpacity(.54)),
        ),
      ),
    );

    if (dataType == DataType.Label) return Expanded(child: child);

    return child;
  }

  OutlineInputBorder inputBorder({bool error = false, bool focus = false}) {
    final color = error
        ? Colors.red
        : isLight
            ? theme.colorScheme.onSurface
            : theme.colorScheme.surface;

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        width: 1.5,
        color: focus ? currentColor : color,
      ),
    );
  }

  Widget button(Function onTap, Widget child) {
    final padding = dataType == DataType.Label
        ? const EdgeInsets.symmetric(horizontal: 8)
        : const EdgeInsets.symmetric(vertical: 12);

    final widget = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1.5,
            color: isLight
                ? theme.colorScheme.onSurface
                : theme.colorScheme.surface,
          ),
        ),
        child: child,
      ),
    );

    if (dataType == DataType.Label) return widget;

    return Expanded(child: widget);
  }

  Widget widget() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selectedColor.value,
      ),
    );
  }

  void onTapColor(BuildContext context) async {
    final color = await showModal(
      context: context,
      builder: (_) => ColorPicker(color: selectedColor.value),
    );

    if (color != null && selectedColor.value.value != color.value)
      selectedColor.value = color;
  }

  void onTapIcon(BuildContext context, Color currentColor) async {
    final icon = await showModal(
      context: context,
      builder: (_) => IconPicker(color: currentColor),
    );

    if (icon != null && selectedIcon.value != icon) selectedIcon.value = icon;
  }

  void onTapReminder(BuildContext context, Color currentColor) async {
    if (reminder.value?.isAfter(DateTime.now()) ?? false) {
      reminder.value = null;
    } else {
      final date = await openDatePicker(
          context: context, color: currentColor, initialDate: reminder.value);

      if (date != null) {
        final time = await openTimePicker(
          context: context,
          color: currentColor,
          datetime: reminder.value,
        );

        if (time != null) {
          final datetime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);

          if (datetime.isAfter(DateTime.now()))
            reminder.value = datetime;
          else
            showToast(localizations.w100);
        }
      }
    }
  }

  void onTapDelete(BuildContext context, Color currentColor) {
    showModal(
      context: context,
      builder: (_) => DeleteDialog(
        color: currentColor,
        title: localizations.w153,
        content: localizations.w154,
        onPressed: () {
          NoteService().delete(data.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  void onTapDone(BuildContext context) {
    var latestData;

    final text = controller.text.trim();

    if (text.isNotEmpty && (text.length <= 36 || dataType == DataType.Note)) {
      if (data != null) {
        switch (dataType) {
          case DataType.List:
            {
              latestData = data.copyWith(
                name: text,
                color: selectedColor.value,
                iconData: selectedIcon.value,
              );

              ListService().write(latestData);
              break;
            }
          case DataType.Label:
            {
              latestData = data.copyWith(
                name: text,
                color: selectedColor.value,
              );

              LabelService().write(latestData);
              break;
            }
          case DataType.Note:
            {
              final note = data.copyWith(
                content: text,
                acceptNull: true,
                pinned: pinned.value,
                reminder: reminder.value,
              );

              if (note.reminder == null && (data.reminder?.isAfter(DateTime.now()) ?? false)) {
                flutterLocalNotificationsPlugin.cancel(note.notificationID);
                showToast(localizations.w155);
              } else if (note.reminder != null && note.reminder != data.reminder) {
                scheduleNoteNotification(note, pod.appTheme);
                showToast(localizations.w156);
              }

              NoteService().write(note);
              break;
            }
        }
      } else {
        switch (dataType) {
          case DataType.List:
            {
              final service = ListService();

              service.write(
                AppList(
                  name: text,
                  color: selectedColor.value,
                  iconData: selectedIcon.value,
                  index: service.values().length,
                ),
              );
              break;
            }
          case DataType.Label:
            {
              final service = LabelService();

              service.write(
                Label(
                  name: text,
                  color: selectedColor.value,
                  index: service.values().length,
                ),
              );
              break;
            }
          case DataType.Note:
            {
              final note = Note(
                content: text,
                pinned: pinned.value,
                reminder: reminder.value,
                notificationID: UtilService.getValidNotificationID(),
              );

              if (note.reminder != null) {
                scheduleNoteNotification(note, pod.appTheme);
                showToast(localizations.w156);
              }

              NoteService().write(note);
              break;
            }
        }
      }

      Navigator.pop(context, latestData);
    }
  }
}
