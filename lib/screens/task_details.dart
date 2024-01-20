import 'dart:ui';

import 'package:uuid/uuid.dart';
import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskiee/models/task.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/models/repeat.dart';
import 'package:taskiee/models/subtask.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/link_text.dart';
import 'package:taskiee/widgets/task_card.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/animation_pod.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:taskiee/dialogs/save_dialog.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/pickers/data_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:taskiee/pickers/repeat_picker.dart';
import 'package:taskiee/dialogs/delete_dialog.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/services/subtask_service.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class TaskDetails extends StatefulHookWidget {
  final Task task;
  final String id;

  const TaskDetails({this.task, this.id});

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> with Utils {
  ThemeData theme;
  TextEditingController controller;
  TextEditingController controller2;
  TextEditingController controller3;

  ValueNotifier<Repeat> repeat;
  ValueNotifier<bool> dueEmpty;
  ValueNotifier<List> labelIDS;
  ValueNotifier<List> subTasks;
  ValueNotifier<bool> completed;
  ValueNotifier<bool> important;
  ValueNotifier<String> dueText;
  ValueNotifier<bool> generated;
  ValueNotifier<AppList> appList;
  ValueNotifier<DateTime> dueDate;
  ValueNotifier<bool> repeatEmpty;
  ValueNotifier<String> repeatText;
  ValueNotifier<DateTime> reminder;
  ValueNotifier<bool> reminderEmpty;
  ValueNotifier<String> reminderText;
  ValueNotifier<String> repeatSubText;
  ValueNotifier<bool> showLinkTextField;

  Task task;
  AppList oldList;
  AppTheme appTheme;
  List initialSubtask;
  bool isEdited = false;

  final focusNode = FocusNode();
  final serviceTask = TaskService();
  final serviceList = ListService();
  final serviceLabel = LabelService();
  final serviceSubTask = SubTaskService();
  final localizations = AppLocalizations.instance;

  @override
  void initState() {
    super.initState();
    // TODO Cloud Notification
    task = widget.task ?? serviceTask.getFromID(widget.id);
    initialSubtask = serviceSubTask.getFromTaskID(task.id)
      ..sort((a, b) => a.index.compareTo(b.index));
    oldList = serviceList.getFromID(task.listID);

    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible && mounted) FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    appTheme = useProvider(themePod).appTheme;
    controller = useTextEditingController(text: task.body);
    controller2 = useTextEditingController(text: task.link);
    controller3 = useTextEditingController(text: task.note);

    dueText = useState(task.dueDate != null
        ? toLocalizedDate(context, task.dueDate)
        : localizations.w30);
    reminderText = useState(task.reminder != null
        ? toLocalizedDate(context, task.reminder,
            time: TimeOfDay.fromDateTime(task.reminder))
        : localizations.w32);
    repeatText = useState(task.repeat != null
        ? toReadableText(context, task.repeat.amount, task.repeat.repeatType)
        : localizations.w31);
    repeatSubText = useState(toReadableSubText(context, task.repeat?.weekDays));

    subTasks = useState([...initialSubtask]);
    showLinkTextField = useState(task.link.isEmpty);
    dueEmpty = useState(task.dueDate != null ? false : true);
    repeatEmpty = useState(task.repeat != null ? false : true);
    reminderEmpty = useState(task.reminder != null ? false : true);

    appList = useState(oldList);
    repeat = useState(task.repeat);
    dueDate = useState(task.dueDate);
    reminder = useState(task.reminder);
    labelIDS = useState(task.labelIDS);
    generated = useState(task.generated);
    completed = useState(task.completed);
    important = useState(task.important);

    return WillPopScope(
      onWillPop: () => onSave(viaButton: false, pop: false),
      child: ScaffoldMessenger(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            isExtended: true,
            onPressed: onSave,
            backgroundColor: appList.value.color,
            child: Icon(
              Icons.save_as_outlined,
              color: getOnColor(appList.value.color),
            ),
          ),
          body: Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                secondary: appList.value.color,
              ),
              unselectedWidgetColor: appList.value.color,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: appList.value.color,
                selectionHandleColor: appList.value.color,
                selectionColor: appList.value.color.withOpacity(.24),
              ),
            ),
            child: CustomScrollView(
              slivers: [
                appBar(),
                bodyWidget(),
                ...subTaskWidgets(),
                listWidget(),
                dateUtilsWidget(),
                linkWidget(),
                labelWidgets(),
                noteWidget(),
                creationWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appBar() {
    return SliverAppBar(
      pinned: true,
      title: Text(
        appList.value.name,
        style: theme.textTheme.headline2.copyWith(
          color: appList.value.color,
        ),
      ),
      leading: IconButton(
        onPressed: () => onSave(viaButton: false),
        icon: Icon(
          Icons.arrow_back_outlined,
          color: theme.textTheme.bodyText1.color,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => showModal(
            context: context,
            builder: (_) => DeleteDialog(
              title: localizations.p0(1),
              content: localizations.w92,
              color: appList.value.color,
              onPressed: () {
                serviceTask.delete(task.id,
                    includeSubtask: appTheme.includeSubtask);
                Navigator.pop(context);
              },
            ),
          ),
          icon: Icon(
            Icons.delete_outline_outlined,
            color: theme.textTheme.bodyText1.color,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget bodyWidget() {
    return SliverToBoxAdapter(
      child: Material(
        borderRadius: BorderRadius.zero,
        color: theme.colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.15,
                child: Checkbox(
                  value: completed.value,
                  activeColor: appList.value.color,
                  checkColor: getOnColor(appList.value.color),
                  onChanged: (value) => completed.value = value,
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: NonGlowBehavior(),
                  child: TextField(
                    maxLines: 5,
                    minLines: 1,
                    controller: controller,
                    cursorColor: appList.value.color,
                    style: theme.textTheme.headline1,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration.collapsed(
                      hintText: localizations.w41,
                      hintStyle: theme.textTheme.headline1.copyWith(
                        color: theme.textTheme.headline1.color.withOpacity(.54),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => important.value = !important.value,
                child: SizedBox(
                  height: 48,
                  child: Icon(
                    important.value
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: appList.value.color,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> subTaskWidgets() {
    final pod = useProvider(animationPod);

    return [
      SliverReorderableList(
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) newIndex -= 1;

          final list = subTasks.value;
          final item = list.removeAt(oldIndex);
          list.insert(newIndex, item.copyWith(index: newIndex));

          subTasks.value = list;
        },
        itemCount: subTasks.value.length,
        proxyDecorator: (child, _, animation) => AnimatedBuilder(
          child: child,
          animation: animation,
          builder: (_, child) {
            final animValue = Curves.easeInOut.transform(animation.value);
            final elevation = lerpDouble(0, 8, animValue);

            return Material(child: child, elevation: elevation);
          },
        ),
        itemBuilder: (_, index) {
          final subtask = subTasks.value[index];

          return TaskCard(
            elevation: 0,
            subTask: subtask,
            subtaskIndex: index,
            ignoreGestures: true,
            key: ValueKey(subtask.id),
            cardType: CardType.SubTask,
            color: appList.value.color,
            onUndo: (subtask) {
              pod.add(subtask.id);
              subTasks.value = [...subTasks.value]..insert(index, subtask);
            },
            onDeleted: () {
              subTasks.value = [...subTasks.value]
                ..removeWhere((e) => e.id == subtask.id);
            },
            subTaskUsedIn: SubTaskUsedIn.InDetails,
            onEdited: (controller, editedSubTask) {
              final list = [...subTasks.value];
              final value = list.indexWhere((e) => e.id == editedSubTask.id);

              if (controller.text.trim().isEmpty)
                list.removeAt(value);
              else
                list[value] = editedSubTask;

              subTasks.value = list;
            },
          );
        },
      ),
      SliverToBoxAdapter(
        child: TaskCard(
          task: task,
          ignoreGestures: true,
          color: appList.value.color,
          cardType: CardType.SubTask,
          subTaskUsedIn: SubTaskUsedIn.InDetailsAdd,
          onEdited: (controller, _) {
            final body = controller.text.trim();

            if (body.isNotEmpty) {
              final subTask = SubTask(
                body: body,
                id: Uuid().v4(),
                taskID: task.id,
                listID: task.listID,
                creationDate: DateTime.now(),
                index: subTasks.value.length,
              );

              pod.add(subTask.id);
              subTasks.value = [...subTasks.value]..add(subTask);
            }

            controller.clear();
          },
        ),
      ),
    ];
  }

  Widget listWidget() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          elevation: 1.5,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: ListTile(
            onTap: handleList,
            horizontalTitleGap: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            title: Text(
              appList.value.name,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyText1,
            ),
            leading: Icon(
              appList.value.iconData,
              color: appList.value.color,
              size: 29,
            ),
          ),
        ),
      ),
    );
  }

  Widget linkWidget() {
    final painter = TextPainter(
      maxLines: 1,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: 'PlaceHolder',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    )..layout();

    final child = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: painter.size.height * 5),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          overscroll: false,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(right: 4),
          child: LinkText(
            controller2.text,
            shouldTrimParams: true,
            textStyle: theme.textTheme.bodyText1,
            linkStyle:
                theme.textTheme.bodyText1.copyWith(color: appList.value.color),
          ),
        ),
      ),
    );

    final textField = FocusScope(
      onFocusChange: (value) {
        if (!value) {
          if (controller2.text.trim().isNotEmpty)
            showLinkTextField.value = false;
          else
            controller2.clear();
        }
      },
      child: TextField(
        minLines: 1,
        maxLines: 5,
        focusNode: focusNode,
        controller: controller2,
        cursorColor: appList.value.color,
        style: theme.textTheme.bodyText1,
        decoration: InputDecoration.collapsed(
          hintText: 'Link/URL',
          hintStyle: theme.textTheme.bodyText1.copyWith(
            color: theme.textTheme.bodyText1.color.withOpacity(.54),
          ),
        ),
      ),
    );

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          elevation: 1.5,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: GestureDetector(
            onTap: () {
              showLinkTextField.value = true;
              focusNode.requestFocus();
            },
            child: ListTile(
              horizontalTitleGap: 0,
              minVerticalPadding: 8,
              contentPadding: EdgeInsets.fromLTRB(16, 0, 56, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              leading: Icon(Icons.link_outlined, color: appList.value.color),
              title: showLinkTextField.value ? textField : child,
            ),
          ),
        ),
      ),
    );
  }

  Widget dateUtilsWidget() {
    final now = DateTime.now();
    final nowWithoutTime = DateUtils.dateOnly(now);
    final isBefore = dueDate.value?.isBefore(nowWithoutTime) ?? false;
    final isSameMoment =
        dueDate.value?.isAtSameMomentAs(nowWithoutTime) ?? false;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          elevation: 1.5,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: Column(
            children: [
              dateUtilChild(
                index: 0,
                text: dueText.value,
                onTap: handleDueDate,
                empty: dueEmpty.value,
                onRemove: handleDueDate,
                icon: Icons.today_outlined,
                color: isBefore && !isSameMoment ? Colors.red : null,
              ),
              dateUtilChild(
                index: 1,
                onTap: handleRepeat,
                onRemove: handleRepeat,
                text: repeatText.value,
                empty: repeatEmpty.value,
                icon: Icons.repeat_outlined,
              ),
              dateUtilChild(
                index: 2,
                onTap: handleReminder,
                onRemove: handleReminder,
                text: reminderText.value,
                empty: reminderEmpty.value,
                icon: Icons.notifications_none_outlined,
                color:
                    (reminder.value?.isAfter(now) ?? false) && !completed.value
                        ? null
                        : theme.textTheme.bodyText1.color.withOpacity(.54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelWidgets() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          elevation: 1.5,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: child(),
        ),
      ),
    );
  }

  Widget child() {
    final labels = serviceLabel.getLabels(labelIDS.value);
    final child = Text(
      localizations.w25.capitalize(),
      style: theme.textTheme.bodyText1.copyWith(
        color: theme.textTheme.bodyText1.color.withOpacity(.54),
      ),
    );
    final labelWidget = Wrap(
        spacing: 6,
        runSpacing: -10,
        children: labels
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LabelCard(label: e, isTaskLabel: true, enlarge: true),
                ))
            .toList());

    return ListTile(
      onTap: handleLabels,
      horizontalTitleGap: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      leading: Icon(Icons.label_outline, color: appList.value.color),
      title: labels.isNotEmpty ? labelWidget : child,
    );
  }

  Widget noteWidget() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Material(
          elevation: 1.5,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: ListTile(
            horizontalTitleGap: 0,
            minVerticalPadding: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            leading: Icon(
              Icons.sticky_note_2_outlined,
              color: appList.value.color,
            ),
            title: TextField(
              minLines: 1,
              maxLines: 8,
              controller: controller3,
              cursorColor: appList.value.color,
              style: theme.textTheme.bodyText1,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration.collapsed(
                hintText: localizations.w27,
                hintStyle: theme.textTheme.bodyText1.copyWith(
                  color: theme.textTheme.bodyText1.color.withOpacity(.54),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget creationWidget() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Material(
          elevation: 1.5,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          child: ListTile(
            horizontalTitleGap: 0,
            minVerticalPadding: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            leading: Icon(Icons.update_outlined, color: appList.value.color),
            title: Text(
              getCreatedTime(context, task.creationDate),
              style: theme.textTheme.bodyText1,
            ),
          ),
        ),
      ),
    );
  }

  Widget dateUtilChild({
    int index,
    bool empty,
    String text,
    Color color,
    IconData icon,
    Function onTap,
    Function(bool) onRemove,
  }) {
    final borderRadius = index == 0
        ? BorderRadius.vertical(top: Radius.circular(4))
        : index == 2
            ? BorderRadius.vertical(bottom: Radius.circular(4))
            : BorderRadius.zero;

    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      title: Text(
        text,
        style: theme.textTheme.bodyText1.copyWith(
            color: empty
                ? theme.textTheme.bodyText1.color.withOpacity(.54)
                : color),
      ),
      leading: Icon(icon, color: appList.value.color),
      trailing: !empty
          ? IconButton(
              onPressed: () => onRemove(true),
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.clear_outlined,
                color: theme.textTheme.bodyText1.color,
              ),
            )
          : null,
      subtitle: index == 1 && repeatSubText.value != null
          ? Text(repeatSubText.value, style: theme.textTheme.subtitle1)
          : null,
    );
  }

  void handleLabels() async {
    final result = await showModal(
      context: context,
      builder: (_) => LabelPicker(
        initialIDS: labelIDS.value,
        color: appList.value.color,
        skipLoop: true,
      ),
    );

    if (result != null) labelIDS.value = result;
  }

  void handleList() async {
    final newList = await showModal(
      context: context,
      builder: (_) => ListPicker(
        initialID: appList.value.id,
        color: appList.value.color,
      ),
    );

    if (newList != null && newList.id != appList.value.id)
      appList.value = newList;
  }

  void handleDueDate([bool onRemove = false]) async {
    if (onRemove) {
      if (!repeatEmpty.value) {
        repeatText.value = localizations.w31;
        repeatSubText.value = null;
        repeatEmpty.value = true;
        repeat.value = null;
      }

      dueText.value = localizations.w30;
      dueEmpty.value = true;
      dueDate.value = null;
    } else {
      final date = await openDatePicker(
        context: context,
        color: appList.value.color,
        initialDate: dueDate.value,
      );

      if (date != null) {
        final recentTask = serviceTask.getFromID(task.id);

        if (recentTask.generated && date != dueDate.value)
          generated.value = false;

        dueText.value = toLocalizedDate(context, date);
        dueEmpty.value = false;
        dueDate.value = date;
      }
    }
  }

  void handleRepeat([bool onRemove = false]) async {
    if (onRemove) {
      repeatText.value = localizations.w31;
      repeatSubText.value = null;
      repeatEmpty.value = true;
      repeat.value = null;
    } else {
      final value = await showModal(
        context: context,
        builder: (_) => RepeatPicker(
          color: appList.value.color,
          repeat: repeat.value,
        ),
      );

      if (value != null) {
        final recentTask = serviceTask.getFromID(task.id);

        if (recentTask.generated) generated.value = false;

        if (dueEmpty.value) {
          final date = generateDate(null, value);

          dueText.value = toLocalizedDate(context, date);
          dueEmpty.value = false;
          dueDate.value = date;
        }

        repeatText.value =
            toReadableText(context, value.amount, value.repeatType);
        repeatSubText.value = toReadableSubText(context, value.weekDays);
        repeatEmpty.value = false;
        repeat.value = value;
      }
    }
  }

  void handleReminder([bool onRemove = false]) async {
    if (onRemove) {
      reminderText.value = localizations.w32;
      reminderEmpty.value = true;
      reminder.value = null;
    } else {
      final date = await openDatePicker(
        context: context,
        color: appList.value.color,
        initialDate: reminder.value,
      );

      if (date != null) {
        final time = await openTimePicker(
          context: context,
          datetime: reminder.value,
          color: appList.value.color,
        );

        if (time != null) {
          final datetime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);

          if (datetime.isAfter(DateTime.now())) {
            if (!completed.value) {
              reminderText.value = toLocalizedDate(context, date,
                  time: TimeOfDay.fromDateTime(datetime));
              reminderEmpty.value = false;
              reminder.value = datetime;
            } else {
              showToast(localizations.w149);
            }
          } else {
            showToast(localizations.w100);
          }
        }
      }
    }
  }

  // ignore: missing_return
  Future<bool> onSave({bool viaButton = true, bool pop = true}) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future.delayed(const Duration(milliseconds: 50));
    }

    var value = true;

    final oldSet = initialSubtask.toSet();
    final newSet = subTasks.value.toSet();

    final created = newSet.difference(oldSet);
    final deleted = oldSet.difference(newSet);

    newSet.removeAll(created);
    oldSet.removeAll(deleted);

    var edited = [];

    for (var a in newSet) {
      for (var b in oldSet) {
        if (a.id == b.id) {
          final completed = a.completed == b.completed;
          final index = subTasks.value.indexOf(a) == initialSubtask.indexOf(b);

          if (!(completed && a.body == b.body && index)) {
            final map = {
              'subtask': a,
              'increase': completed ? null : a.completed && !b.completed,
            };

            edited.add(map);
          }

          oldSet.remove(b);
          break;
        }
      }
    }

    var task = Task(
      id: this.task.id,
      uid: this.task.uid,
      repeat: repeat.value,
      dueDate: dueDate.value,
      index: this.task.index,
      reminder: reminder.value,
      listID: appList.value.id,
      labelIDS: labelIDS.value,
      completed: completed.value,
      important: important.value,
      generated: generated.value,
      total: subTasks.value.length,
      body: controller.text.trim(),
      note: controller3.text.trim(),
      link: controller2.text.trim(),
      creationDate: this.task.creationDate,
      notificationID: this.task.notificationID,
      done: subTasks.value.where((e) => e.completed).length,
    );

    final isSame = (this.task == task) &&
        (created.isEmpty && deleted.isEmpty && edited.isEmpty);

    if (!viaButton && !isSame) {
      value = await showModal(
        context: context,
        builder: (_) => SaveDialog(color: appList.value.color),
      );
    }

    if (value != null) {
      if (value) {
        if (this.task.completed != task.completed) {
          serviceTask.onChecked(context, task.id, task.completed,
              ignoreWrite: true);

          if (this.task.repeat != null &&
              !this.task.generated &&
              task.completed) task = task.copyWith(generated: true);
        }

        if (oldList.id != appList.value.id) {
          if (appTheme.includeSubtask) {
            serviceList.updateTotal(
              appList.value.id,
              number: subTasks.value.length,
            );
            serviceList.updateTotal(
              oldList.id,
              decrease: true,
              number: initialSubtask.length,
            );

            serviceList.updateDone(
              oldList.id,
              number: initialSubtask.where((e) => e.completed).length,
            );
            serviceList.updateDone(
              appList.value.id,
              increase: true,
              number: subTasks.value.where((e) => e.completed).length,
            );
          }

          serviceList.updateTotal(appList.value.id);
          serviceList.updateTotal(oldList.id, decrease: true);

          if (completed.value) {
            serviceList.updateDone(oldList.id);
            serviceList.updateDone(appList.value.id, increase: true);
          }
        }

        if (!(appTheme.autoDelete && task.completed)) {
          created.forEach((subtask) {
            serviceSubTask.write(
                subtask.copyWith(index: subTasks.value.indexOf(subtask)));

            if (appTheme.includeSubtask) {
              serviceList.updateTotal(task.listID);

              if (subtask.completed)
                serviceList.updateDone(task.listID, increase: true);
            }
          });

          deleted.forEach((subtask) => serviceSubTask.delete(subtask.id,
              direct: true, includeSubtask: appTheme.includeSubtask));

          edited.forEach((map) {
            final subtask = map['subtask'];

            serviceSubTask.write(
                subtask.copyWith(index: subTasks.value.indexOf(subtask)));

            if (appTheme.includeSubtask && map['increase'] != null)
              serviceList.updateDone(task.listID, increase: map['increase']);
          });

          serviceTask.write(task);

          scheduleNotification(context, task);

          if (task.reminder != null && task.reminder != this.task.reminder)
            showToast(localizations.w156);
          else if ((this.task.reminder?.isAfter(DateTime.now()) ?? false) && task.reminder == null) 
            showToast(localizations.w155);
        } else {
          serviceTask.delete(task.id, includeSubtask: appTheme.includeSubtask);
        }
      }

      if (pop) {
        if (launchDetails.didNotificationLaunchApp)
          SystemNavigator.pop();
        else
          Navigator.pop(context);
      } else {
        if (launchDetails.didNotificationLaunchApp)
          return Future.value(true);
        else
          return onWillPop(context);
      }
    }
  }
}
