import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/task.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/models/subtask.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/animation_pod.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/screens/task_details.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/services/subtask_service.dart';

enum CardType { Task, SubTask }

enum SubTaskUsedIn { InSearch, InDetails, InDetailsAdd, None }

class TaskCard extends StatefulHookWidget {
  final Task task;
  final Color color;
  final bool animatable;
  final SubTask subTask;
  final String listName;
  final double elevation;
  final bool dismissible;
  final bool useSizedBox;
  final int subtaskIndex;
  final CardType cardType;
  final bool ignoreGestures;
  final Function() onDeleted;
  final BorderRadius borderRadius;
  final SubTaskUsedIn subTaskUsedIn;
  final Function(SubTask subTask) onUndo;
  final Function(TextEditingController controller, SubTask subTask) onEdited;

  const TaskCard({
    Key key,
    this.task,
    this.color,
    this.onUndo,
    this.subTask,
    this.listName,
    this.onEdited,
    this.onDeleted,
    this.subtaskIndex,
    this.elevation = 1.5,
    this.animatable = false,
    this.dismissible = true,
    this.useSizedBox = false,
    this.ignoreGestures = false,
    this.cardType = CardType.Task,
    this.borderRadius = BorderRadius.zero,
    this.subTaskUsedIn = SubTaskUsedIn.None,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin, Utils {
  AnimationController controller;
  AnimationPod podAnim;
  UtilsPod podUtils;
  AppTheme appTheme;
  ThemeData theme;

  final serviceTask = TaskService();
  final serviceList = ListService();
  final serviceLabel = LabelService();
  final serviceSubTask = SubTaskService();

  @override
  void initState() {
    super.initState();
    podAnim = context.read(animationPod);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (podAnim.contains(widget.subTask?.id ?? widget.task.id)) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.forward();
        podAnim.remove(widget.subTask?.id ?? widget.task.id);
      });
    } else {
      controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    podUtils = useProvider(utilsPod);
    appTheme = useProvider(themePod).appTheme;

    if (widget.subTaskUsedIn != SubTaskUsedIn.InDetailsAdd) {
      if (podUtils.isAnimating &&
          podUtils.contains(widget.subTask ?? widget.task))
        controller.reverse();

      final child = GestureDetector(
        onTap: widget.ignoreGestures ? null : onTap,
        onLongPress: widget.ignoreGestures ? null : onLongPress,
        child: Material(
          elevation: widget.elevation,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
          child: !podUtils.isShowing && widget.dismissible
              ? Dismissible(
                  key: widget.key,
                  background: background(),
                  onDismissed: (_) => onDismissed(context),
                  secondaryBackground: background(right: true),
                  child: main(),
                )
              : main(),
        ),
      );

      return widget.useSizedBox
          ? animations(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [child, const SizedBox(height: 8)],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            )
          : child;
    }

    return Material(
      elevation: 1.5,
      child: getSubTask(),
      color: theme.colorScheme.surface,
    );
  }

  Widget main() {
    final child = widget.cardType == CardType.Task ? getTask() : getSubTask();

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
      child: widget.useSizedBox ? child : animations(child),
    );
  }

  Widget animations(Widget widget) {
    return SizeTransition(
      sizeFactor: sizeAnimation(),
      child: FadeTransition(
        opacity: fadeAnimation(),
        child: ScaleTransition(scale: scaleAnimation(), child: widget),
      ),
    );
  }

  Widget background({bool right = false}) {
    final dismissibleType = appTheme.dismissibleType;
    final colorized = dismissibleType == DismissibleType.Colored;

    return Material(
      color: colorized ? widget.color : theme.colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius,
        side: colorized
            ? BorderSide.none
            : BorderSide(color: widget.color, width: 1.5),
      ),
      child: Align(
        alignment: right ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Icon(
            Icons.delete_outline_outlined,
            color: colorized ? getOnColor(widget.color) : widget.color,
            size: 26,
          ),
        ),
      ),
    );
  }

  Widget getTask() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Row(
        children: [
          leading(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Text(
                  text: widget.task.body,
                  cardType: CardType.Task,
                  decorate: widget.task.completed,
                ),
                Row(
                  children: [
                    handleList(),
                    divider(0),
                    handleDueDate(context),
                    divider(1),
                    widget.task.total != 0
                        ? _SubText(
                            text: '${widget.task.done}/${widget.task.total}',
                            fade: true,
                          )
                        : const SizedBox(),
                    divider(2),
                    handleIcons(context),
                  ],
                ),
                labelsWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget handleList() {
    if (widget.listName != null)
      return Flexible(child: _SubText(text: widget.listName, fade: true));

    return const SizedBox();
  }

  Widget handleDueDate(BuildContext context) {
    if (widget.task.dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final text = toLocalizedDate(context, widget.task.dueDate);
      final color = widget.task.dueDate.isBefore(today)
          ? Colors.red
          : widget.task.dueDate.isAtSameMomentAs(today)
              ? widget.color
              : null;

      return _SubText(text: text, color: color);
    }

    return const SizedBox();
  }

  Widget handleIcons(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: serviceTask.listen(widget.task.id),
          child: icon(Icons.notifications_active_outlined),
          builder: (_, __, child) {
            if ((widget.task.reminder?.isAfter(DateTime.now()) ?? false) &&
                !widget.task.completed) return child;

            return const SizedBox();
          },
        ),
        widget.task.repeat != null
            ? icon(Icons.repeat_outlined)
            : const SizedBox(),
        widget.task.note.isNotEmpty
            ? icon(Icons.sticky_note_2_outlined)
            : const SizedBox(),
        widget.task.link.isNotEmpty
            ? icon(Icons.link_outlined)
            : const SizedBox(),
        widget.task.important
            ? icon(Icons.star_rounded, color: widget.color)
            : const SizedBox(),
      ],
    );
  }

  Widget icon(IconData iconData, {Color color}) {
    return Padding(
      padding: const EdgeInsets.only(right: 2, top: 2),
      child: Icon(
        iconData,
        color: color == null
            ? getOnColor(theme.colorScheme.surface).withOpacity(.54)
            : color,
        size: 15,
      ),
    );
  }

  Widget divider(int index) {
    return ValueListenableBuilder(
      valueListenable: serviceSubTask.listenable,
      child: Container(
        width: 4,
        height: 4,
        margin: const EdgeInsets.fromLTRB(4, 2, 4, 0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.textTheme.subtitle1.color.withOpacity(.54),
        ),
      ),
      builder: (_, __, child) {
        final isNotEmpty = widget.task.total != 0;
        final query = index == 0
            ? separator1(isNotEmpty)
            : index == 1
                ? separator2(isNotEmpty)
                : separator3(isNotEmpty);

        return query ? child : const SizedBox();
      },
    );
  }

  bool separator1(bool isNotEmpty) {
    return widget.listName != null &&
        (widget.task.dueDate != null || isNotEmpty || query());
  }

  bool separator2(bool isNotEmpty) =>
      widget.task.dueDate != null && (isNotEmpty || query());

  bool separator3(bool isNotEmpty) => isNotEmpty && query();

  bool query() {
    return (widget.task.reminder?.isAfter(DateTime.now()) ?? false) ||
        widget.task.repeat != null ||
        widget.task.note.isNotEmpty ||
        widget.task.link.isNotEmpty ||
        widget.task.important;
  }

  Widget labelsWidget() {
    final labels = serviceLabel.getLabels(widget.task.labelIDS);

    if (labels.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Wrap(
          spacing: 6,
          runSpacing: 6,
          children: labels
              .map((e) => LabelCard(label: e, isTaskLabel: true))
              .toList(),
        ),
      );
    }

    return const SizedBox();
  }

  Widget getSubTask() {
    if (widget.subTaskUsedIn == SubTaskUsedIn.InSearch) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
        child: Row(
          children: [
            leading(),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Text(
                    cardType: CardType.Task,
                    text: widget.subTask.body,
                    decorate: widget.subTask.completed,
                  ),
                  _SubText(text: widget.task.body)
                ],
              ),
            ),
          ],
        ),
      );
    }

    final bodyText1 = theme.textTheme.bodyText1;
    final completed = useState(widget.subTask?.completed);
    final controller = useTextEditingController(text: widget.subTask?.body);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          leading(completed, controller),
          Expanded(
            child: Focus(
              onFocusChange: (value) {
                if (!value) {
                  var subtask;

                  if (widget.subTask != null) {
                    subtask = widget.subTask.copyWith(
                        body: controller.text.trim(),
                        completed: completed.value);
                  }

                  widget.onEdited(controller, subtask);
                }
              },
              child: TextField(
                maxLines: null,
                style: bodyText1.copyWith(
                  decoration: appTheme.strikeThrough &&
                          (completed.value ??
                              widget.subTask?.completed ??
                              false)
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: (completed.value ?? widget.subTask?.completed ?? false)
                      ? bodyText1.color.withOpacity(.64)
                      : bodyText1.color,
                  decorationStyle: TextDecorationStyle.solid,
                  decorationColor: bodyText1.color,
                  decorationThickness: 2,
                ),
                controller: controller,
                cursorColor: widget.color,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration.collapsed(
                  hintText: widget.subTaskUsedIn == SubTaskUsedIn.InDetails
                      ? AppLocalizations.instance.w42
                      : AppLocalizations.instance.w12,
                  hintStyle: bodyText1.copyWith(
                    color: bodyText1.color.withOpacity(.54),
                  ),
                ),
              ),
            ),
          ),
          widget.subtaskIndex != null
              ? ReorderableDragStartListener(
                  key: widget.key,
                  index: widget.subtaskIndex,
                  child: Icon(
                    Icons.drag_indicator_outlined,
                    color: theme.textTheme.bodyText1.color,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget leading([ValueNotifier notifier, TextEditingController controller]) {
    if (!podUtils.isShowing) {
      final addDetails = widget.subTaskUsedIn == SubTaskUsedIn.InDetailsAdd;

      return Theme(
        data: theme.copyWith(
          disabledColor: widget.color.withOpacity(.54),
          unselectedWidgetColor: widget.color,
        ),
        child: Checkbox(
          onChanged: notifier?.value != null
              ? (value) {
                  notifier.value = value;

                  final subtask = widget.subTask
                      .copyWith(body: controller.text.trim(), completed: value);

                  widget.onEdited(controller, subtask);
                }
              : !addDetails
                  ? onChanged
                  : null,
          checkColor: getOnColor(widget.color),
          activeColor: widget.color,
          value: !addDetails
              ? notifier?.value ??
                  widget.subTask?.completed ??
                  widget.task.completed
              : false,
        ),
      );
    }

    return Theme(
      data: theme.copyWith(
        unselectedWidgetColor: theme.textTheme.bodyText1.color.withOpacity(.54),
      ),
      child: Radio(
        groupValue: true,
        onChanged: (value) => null,
        activeColor: widget.color,
        value: podUtils.contains(widget.subTask ?? widget.task),
      ),
    );
  }

  void onTap() {
    if (!controller.isAnimating) {
      if (!podUtils.isShowing) {
        switch (widget.cardType) {
          case CardType.Task:
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetails(task: widget.task),
                ),
              );
            }
            break;
          case CardType.SubTask:
            {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskDetails(
                    task: serviceTask.getFromID(widget.subTask.taskID),
                  ),
                ),
              );
            }
            break;
        }
      } else {
        podUtils.onTap(widget.subTask ?? widget.task);
      }
    }
  }

  Future<void> onChanged(bool value) async {
    if (!controller.isAnimating) {
      if (widget.cardType == CardType.Task) {
        if (appTheme.autoDelete) {
          await controller.reverse();
          serviceTask.onChecked(context, widget.task.id, value);
          onDismissed(context, autoDeleted: true);
        } else {
          if (widget.animatable) await controller.reverse();
          serviceTask.onChecked(context, widget.task.id, value);
        }
      } else {
        serviceSubTask.onCheck(widget.subTask.id, value);
        if (appTheme.includeSubtask)
          serviceList.updateDone(widget.subTask.id, increase: value);
      }
    }
  }

  void onLongPress() {
    if (!podUtils.isShowing) {
      podUtils.isShowing = true;
      podUtils.onTap(widget.subTask ?? widget.task);
    }
  }

  void onDismissed(BuildContext context, {bool autoDeleted = false}) {
    if (!controller.isAnimating) {
      var subTasks;

      if (widget.cardType == CardType.Task)
        subTasks = serviceSubTask.getFromTaskID(widget.task.id);

      if (autoDeleted) {
        delete(subTasks: subTasks);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        delete(subTasks: subTasks);

        final snackBar = SnackBar(
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(24, 5, 24, 16),
          content: Text(
            widget.cardType == CardType.Task
                ? AppLocalizations.instance.w43
                : AppLocalizations.instance.w44,
            style: theme.textTheme.bodyText1,
          ),
          action: SnackBarAction(
            textColor: widget.color,
            label: AppLocalizations.instance.w66,
            overlayColor: widget.color.withOpacity(.2),
            onPressed: () => delete(subTasks: subTasks, undo: true),
            textStyle: theme.textTheme.bodyText2.copyWith(color: widget.color),
          ),
          duration: const Duration(seconds: 5),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void delete({List subTasks, bool undo = false}) {
    if (widget.cardType == CardType.Task) {
      if (undo) {
        serviceTask.write(widget.task);
        scheduleNotification(null, widget.task, appTheme: appTheme);
        subTasks.forEach((subTask) => serviceSubTask.write(subTask));
        podAnim.add(widget.task.id);

        if (appTheme.includeSubtask) {
          serviceList.updateTotal(widget.task.listID, number: subTasks.length);
          serviceList.updateDone(widget.task.listID,
              number: subTasks.where((e) => e.completed).length);
        }
      } else {
        serviceTask.delete(widget.task.id,
            skip: true, includeSubtask: appTheme.includeSubtask);
      }

      serviceList.updateTotal(widget.task.listID, decrease: !undo);

      if (widget.task.completed && !appTheme.autoDelete) {
        serviceList.updateDone(widget.task.listID, increase: undo);
      }
    } else {
      if (undo) {
        if (widget.onUndo != null) {
          widget.onUndo(widget.subTask);
        } else {
          final task = serviceTask.getFromID(widget.subTask.taskID);
          final done = widget.subTask.completed ? task.done + 1 : task.done;

          if (appTheme.includeSubtask)
            serviceList.updateTotal(widget.subTask.id);

          serviceTask.write(task.copyWith(total: task.total + 1, done: done));
          serviceSubTask.write(widget.subTask);
          podAnim.add(widget.subTask.id);
        }
      } else {
        if (widget.onDeleted != null) {
          widget.onDeleted();
        } else {
          final task = serviceTask.getFromID(widget.subTask.taskID);
          final done = widget.subTask.completed ? task.done - 1 : task.done;

          serviceTask.write(task.copyWith(total: task.total - 1, done: done));
          serviceSubTask.delete(widget.subTask.id,
              direct: true, includeSubtask: appTheme.includeSubtask);
        }
      }
    }
  }

  Animation<double> fadeAnimation() {
    return CurveTween(curve: const Interval(0.5, 0.8)).animate(controller);
  }

  Animation<double> scaleAnimation() {
    return Tween<double>(begin: 0.80, end: 1.00)
        .chain(CurveTween(curve: Curves.ease))
        .animate(controller);
  }

  Animation<double> sizeAnimation() {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5, curve: Curves.ease),
      ),
    );
  }
}

class _Text extends HookWidget with Utils {
  final String text;
  final bool decorate;
  final CardType cardType;

  const _Text({
    this.text,
    this.decorate,
    this.cardType,
  });

  @override
  Widget build(BuildContext context) {
    var maxLines;

    final appTheme = useProvider(themePod).appTheme;

    switch (cardType) {
      case CardType.Task:
        switch (appTheme.taskDisplay) {
          case TaskDisplay.All:
            break;
          case TaskDisplay.Short:
            maxLines = 5;
            break;
          case TaskDisplay.Medium:
            maxLines = 10;
            break;
          case TaskDisplay.Long:
            maxLines = 15;
            break;
        }
        break;
      default:
        maxLines = 10;
        break;
    }

    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return Text(
      text,
      maxLines: maxLines,
      style: textStyle(bodyText1, appTheme),
      softWrap: maxLines != null ? false : null,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  TextStyle textStyle(TextStyle bodyText1, AppTheme appTheme) {
    return bodyText1.copyWith(
      decoration: appTheme.strikeThrough
          ? decorate
              ? TextDecoration.lineThrough
              : TextDecoration.none
          : TextDecoration.none,
      color: decorate ? bodyText1.color.withOpacity(.64) : bodyText1.color,
      decorationStyle: TextDecorationStyle.solid,
      decorationColor: bodyText1.color,
      decorationThickness: 2,
    );
  }
}

class _SubText extends StatelessWidget {
  final String text;
  final Color color;
  final bool fade;

  const _SubText({this.text, this.color, this.fade = false});

  @override
  Widget build(BuildContext context) {
    final subtitle2 = Theme.of(context).textTheme.subtitle2;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: fade ? TextOverflow.fade : TextOverflow.ellipsis,
        style: subtitle2.copyWith(
          color: color ?? subtitle2.color.withOpacity(.54),
        ),
      ),
    );
  }
}
