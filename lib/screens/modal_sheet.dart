import 'package:uuid/uuid.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/task.dart';
import 'package:taskiee/models/label.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/models/repeat.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:taskiee/widgets/custom_tile.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/pickers/data_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:taskiee/services/util_service.dart';
import 'package:taskiee/pickers/repeat_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class ModalSheet extends StatefulHookWidget {
  final Color color;
  final dynamic data;

  const ModalSheet({this.color, this.data});

  @override
  _ModalSheetState createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet>
    with Utils, SingleTickerProviderStateMixin {
  TextEditingController controller;
  Color currentColor;
  ThemeData theme;

  ValueNotifier<String> repeatSubtitle;
  ValueNotifier<bool> reminderInitial;
  ValueNotifier<AppList> selectedList;
  ValueNotifier<List> selectedLabels;
  ValueNotifier<String> reminderHint;
  ValueNotifier<bool> dueDateInitial;
  ValueNotifier<bool> repeatInitial;
  ValueNotifier<String> dueDateHint;
  ValueNotifier<String> repeatHint;
  ValueNotifier<bool> listInitial;
  ValueNotifier<bool> isImportant;
  ValueNotifier<String> listHint;

  Color borderColor;
  DateTime reminder;
  DateTime dueDate;
  Repeat repeat;

  final localizations = AppLocalizations.instance;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityController().onChange.listen((visible) {
      if (mounted) {
        if (!visible) FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLabel = widget.data is AppList;

    theme = Theme.of(context);
    controller = useTextEditingController();
    currentColor = widget.color ?? useProvider(themePod).appTheme.color;
    borderColor = theme.colorScheme.brightness == Brightness.light
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withOpacity(.56);

    repeatSubtitle = useState(null);
    dueDateHint = useState(localizations.w30);
    reminderHint = useState(localizations.w32);
    repeatHint = useState(localizations.w31);
    listHint =
        useState(isLabel ? widget.data.name : localizations.w3.capitalize());

    isImportant = useState(false);
    repeatInitial = useState(true);
    dueDateInitial = useState(true);
    reminderInitial = useState(true);
    listInitial = useState(isLabel ? false : true);

    selectedList = useState(isLabel ? widget.data : null);
    selectedLabels = useState(widget.data is Label ? [widget.data] : []);

    return ScrollConfiguration(
      behavior: NonGlowBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            top(),
            const SizedBox(height: 12),
            middle(),
            const SizedBox(height: 12),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button() {
    final color = getOnColor(currentColor);

    return TextButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 0)),
        backgroundColor: MaterialStateProperty.all(currentColor),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 14),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        overlayColor: MaterialStateProperty.all(color.withOpacity(.2)),
      ),
      onPressed: onTap,
      child: Text(
        localizations.w26,
        style: theme.textTheme.bodyText1.copyWith(color: color),
      ),
    );
  }

  Widget top() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NotificationListener(
              onNotification: (_) => true,
              child: TextField(
                minLines: 2,
                maxLines: 2,
                controller: controller,
                cursorColor: currentColor,
                style: theme.textTheme.bodyText1,
                decoration: InputDecoration(
                  labelText: localizations.w1,
                  labelStyle: theme.textTheme.bodyText1.copyWith(
                    color: theme.textTheme.bodyText1.color.withOpacity(.54),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(width: 1.5, color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: currentColor, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => isImportant.value = !isImportant.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 1.5, color: borderColor),
              ),
              child: Icon(
                isImportant.value
                    ? Icons.star_rounded
                    : Icons.star_outline_rounded,
                color: currentColor,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget middle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTile(
          color: currentColor,
          onTap: handleDueDate,
          title: dueDateHint.value,
          icon: Icons.today_outlined,
          initial: dueDateInitial.value,
          trailingSwitch: true,
        ),
        const SizedBox(height: 12),
        CustomTile(
          onTap: handleList,
          color: currentColor,
          title: listHint.value,
          initial: listInitial.value,
          icon: Icons.category_outlined,
          disabled: widget.data is AppList,
        ),
        const SizedBox(height: 12),
        CustomTile(
          color: currentColor,
          onTap: handleRepeat,
          trailingSwitch: true,
          title: repeatHint.value,
          icon: Icons.repeat_outlined,
          initial: repeatInitial.value,
          subTitle: repeatSubtitle.value,
        ),
        const SizedBox(height: 12),
        CustomTile(
          color: currentColor,
          trailingSwitch: true,
          onTap: handleReminder,
          title: reminderHint.value,
          initial: reminderInitial.value,
          icon: Icons.notifications_none_outlined,
        ),
        const SizedBox(height: 12),
        labels(),
      ],
    );
  }

  Widget labels() {
    final color = theme.textTheme.bodyText1.color;

    return Theme(
      data: theme.copyWith(
        splashColor: color.withOpacity(.12),
        highlightColor: color.withOpacity(.12),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(width: 1.5, color: borderColor),
        ),
        child: ListTile(
          onTap: handleLabels,
          visualDensity: VisualDensity.comfortable,
          contentPadding: EdgeInsets.zero,
          title: SizedBox(
            child: child(),
            height: 40,
          ),
        ),
      ),
    );
  }

  Widget child() {
    if (selectedLabels.value.isNotEmpty) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: selectedLabels.value.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) => Center(
          child: LabelCard(
            enlarge: true,
            isTaskLabel: true,
            adjustColor: true,
            label: selectedLabels.value[index],
          ),
        ),
      );
    }

    return Center(
      child: Text(
        localizations.w25.capitalize(),
        style: theme.textTheme.bodyText1.copyWith(
          color: theme.textTheme.bodyText1.color.withOpacity(.54),
        ),
      ),
    );
  }

  void handleDueDate() async {
    if (dueDateInitial.value) {
      final date = await openDatePicker(context: context, color: currentColor);

      if (date != null) {
        dueDate = date;
        dueDateHint.value = toLocalizedDate(context, date);
        dueDateInitial.value = false;
      }
    } else {
      if (!repeatInitial.value) {
        repeat = null;
        repeatHint.value = localizations.w31;
        repeatInitial.value = true;
        repeatSubtitle.value = null;
      }
      dueDate = null;
      dueDateHint.value = localizations.w30;
      dueDateInitial.value = true;
    }
  }

  void handleList() async {
    final list = await showModal(
      context: context,
      builder: (_) => ListPicker(
        initialID: selectedList.value?.id,
        color: currentColor,
      ),
    );

    if (list != null) {
      selectedList.value = list;
      listInitial.value = false;
      listHint.value = list.name;
    }
  }

  void handleRepeat() async {
    if (repeatInitial.value) {
      final value = await showModal(
        context: context,
        builder: (_) => RepeatPicker(color: currentColor),
      );

      if (value != null) {
        if (dueDateInitial.value) {
          final date = generateDate(null, value);

          dueDate = date;
          dueDateHint.value = toLocalizedDate(context, date);
          dueDateInitial.value = false;
        }
        repeat = value;
        repeatHint.value =
            toReadableText(context, value.amount, value.repeatType);
        repeatSubtitle.value = toReadableSubText(context, value.weekDays);
        repeatInitial.value = false;
      }
    } else {
      repeat = null;
      repeatHint.value = localizations.w31;
      repeatInitial.value = true;
      repeatSubtitle.value = null;
    }
  }

  void handleReminder() async {
    if (reminderInitial.value) {
      final date = await openDatePicker(context: context, color: currentColor);

      if (date != null) {
        final time =
            await openTimePicker(context: context, color: currentColor);

        if (time != null) {
          reminder =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          reminderHint.value = toLocalizedDate(context, date, time: time);
          reminderInitial.value = false;
        }
      }
    } else {
      reminder = null;
      reminderHint.value = localizations.w32;
      reminderInitial.value = true;
    }
  }

  void handleLabels() async {
    final ids = selectedLabels.value.map((e) => e.id).toList();
    final labels = await showModal(
      context: context,
      builder: (_) => LabelPicker(
        initialIDS: ids,
        color: currentColor,
        ignore: widget.data is Label ? widget.data.id : null,
      ),
    );

    if (labels != null) {
      final values = [...selectedLabels.value];

      values.clear();
      values.addAll(labels);

      selectedLabels.value = values;
    }
  }

  void onTap() async {
    final text = controller.text.trim();
    final now = DateTime.now();

    if (text.isEmpty) {
      showToast(localizations.w94);
    } else if (reminder?.isBefore(now) ?? false) {
      showToast(localizations.w100);
    } else if (selectedList.value == null) {
      showToast(localizations.w93);
    } else {
      final task = Task(
        body: text,
        repeat: repeat,
        id: Uuid().v4(),
        dueDate: dueDate,
        creationDate: now,
        reminder: reminder,
        important: isImportant.value,
        listID: selectedList.value.id,
        notificationID: UtilService.getValidNotificationID(),
        labelIDS: selectedLabels.value.map((e) => e.id).toList(),
      );

      TaskService().createTask(context, task);

      if (task.reminder?.isAfter(now) ?? false)
        showToast(localizations.w156);

      Navigator.pop(context);
    }
  }
}
