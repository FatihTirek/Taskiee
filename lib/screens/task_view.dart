import 'dart:ui';

import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskiee/models/label.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/task_card.dart';
import 'package:taskiee/pods/animation_pod.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/dialogs/sort_dialog.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:taskiee/dialogs/delete_dialog.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/widgets/contextual_app_bar.dart';

enum Options { Sort, Reorder, Clear, Uncheck, ShowHide, Delete, Edit }

// ignore: must_be_immutable
class TaskView extends HookWidget with Utils {
  final dynamic data;

  TaskView({this.data});

  UtilsPod pod;
  Service service;
  ThemeData theme;
  AppTheme appTheme;
  ValueNotifier<SortBy> sortBy;
  ValueNotifier<bool> ascending;
  ValueNotifier<bool> reorderMode;
  AnimationController controller1;
  AnimationController controller2;
  ValueNotifier<List> orderedTasks;
  ValueNotifier<bool> showCompleted;
  ValueNotifier<dynamic> changeableData;

  bool isLabel;
  List allTasks;
  List currentTasks;

  final serviceTask = TaskService();
  final serviceList = ListService();
  final localizations = AppLocalizations.instance;
  final scaffoldMessenger = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    pod = useProvider(utilsPod);
    reorderMode = useState(false);
    sortBy = useState(data.sortBy);
    changeableData = useState(data);
    ascending = useState(data.ascending);
    showCompleted = useState(data.showCompleted);
    controller1 = useAnimationController(
      duration: const Duration(milliseconds: 400),
      initialValue: data.sortBy != SortBy.None ? 1 : 0,
    );
    controller2 = useAnimationController(
      duration: const Duration(milliseconds: 300),
      initialValue: data.ascending ? 0.0 : 0.5,
    );

    isLabel = data is Label;
    appTheme = useProvider(themePod).appTheme;
    service = isLabel ? LabelService() : serviceList;

    return WillPopScope(
      onWillPop: () async {
        if (reorderMode.value) {
          reorderMode.value = false;

          return false;
        }

        return onWillPop(context);
      },
      child: ScaffoldMessenger(
        key: scaffoldMessenger,
        child: Scaffold(
          floatingActionButton: Visibility(
            visible: !reorderMode.value && !pod.isShowing,
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: changeableData.value.color,
              onPressed: () => showMyModalSheet(
                context,
                data: changeableData.value,
                color: changeableData.value.color,
              ),
              child: Icon(
                Icons.add_outlined,
                color: getOnColor(changeableData.value.color),
                size: 30,
              ),
            ),
          ),
          bottomNavigationBar:
              sortBy.value != SortBy.None ? sortBar(context) : const SizedBox(),
          body: Theme(
            data: theme.copyWith(
              colorScheme: theme.colorScheme.copyWith(
                secondary: changeableData.value.color,
              ),
            ),
            child: CustomScrollView(slivers: [appBar(context), body()]),
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    if (reorderMode.value) {
      return SliverAppBar(
        pinned: true,
        elevation: 2,
        forceElevated: true,
        leading: IconButton(
          onPressed: () => reorderMode.value = false,
          icon: Icon(
            Icons.close_outlined,
            color: theme.textTheme.bodyText1.color,
          ),
        ),
        title: Text(localizations.w166, style: theme.textTheme.headline2),
        actions: [
          IconButton(
            onPressed: onSave,
            icon: Icon(
              Icons.done_outline_rounded,
              color: theme.textTheme.bodyText1.color,
            ),
          ),
        ],
      );
    } else if (!pod.isShowing) {
      final enabled = sortBy.value == SortBy.None && !isLabel;
      final color = isLabel
          ? theme.textTheme.bodyText1.color
          : getOnColor(changeableData.value.color);
      final background =
          isLabel ? theme.colorScheme.surface : changeableData.value.color;
      final brightness = ThemeData.estimateBrightnessForColor(background);

      return SliverAppBar(
        pinned: true,
        elevation: 2,
        centerTitle: true,
        forceElevated: true,
        backgroundColor: background,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        leading: IconButton(
          onPressed: () => onPop(context),
          splashColor: color.withOpacity(.12),
          highlightColor: color.withOpacity(.12),
          icon: Icon(Icons.arrow_back_outlined, color: color),
        ),
        title: Text(
          changeableData.value.name,
          style: theme.textTheme.headline2.copyWith(
            color: isLabel
                ? changeableData.value.color
                : getOnColor(changeableData.value.color),
          ),
        ),
        actions: [
          Theme(
            data: theme.copyWith(
              dividerColor: theme.textTheme.bodyText1.color.withOpacity(.64),
              unselectedWidgetColor:
                  theme.textTheme.bodyText1.color.withOpacity(.54),
            ),
            child: PopupMenuButton<Options>(
              tooltip: '',
              onSelected: (value) => onSelected(value, context),
              icon: Icon(Icons.more_vert_outlined, color: color),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: Options.Sort,
                  child: Text(
                    localizations.w36,
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                PopupMenuItem(
                  enabled: enabled,
                  value: Options.Reorder,
                  child: Text(
                    localizations.w172,
                    style: theme.textTheme.bodyText1.copyWith(
                      color: !enabled
                          ? theme.textTheme.bodyText1.color.withOpacity(.38)
                          : null,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: Options.Uncheck,
                  child: Text(
                    localizations.p7(1),
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                PopupMenuItem(
                  value: Options.Clear,
                  child: Text(
                    localizations.w17,
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                PopupMenuItem(
                  value: Options.ShowHide,
                  child: Text(
                    showCompleted.value ? localizations.w34 : localizations.w33,
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                PopupMenuDivider(height: 8),
                PopupMenuItem(
                  value: Options.Edit,
                  child: Text(
                    (isLabel ? localizations.w14 : localizations.w13)
                        .capitalize(),
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                PopupMenuItem(
                  value: Options.Delete,
                  child: Text(
                    (isLabel ? localizations.w16 : localizations.w15)
                        .capitalize(),
                    style: theme.textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return ContextualAppBar(
          items: currentTasks, color: changeableData.value.color);
    }
  }

  Widget sortBar(BuildContext context) {
    var decoration;

    switch (appTheme.sortBarType) {
      case SortBarType.Normal:
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: theme.colorScheme.onSurface,
        );
        break;
      case SortBarType.ColoredBorder:
        decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: changeableData.value.color),
        );
        break;
    }

    final borderColor = appTheme.sortBarType != SortBarType.ColoredBorder
        ? theme.textTheme.bodyText1.color.withOpacity(.24)
        : changeableData.value.color;

    return AnimatedBuilder(
      animation: controller1,
      builder: (_, child) => Container(
        width: MediaQuery.of(context).size.width,
        height: Tween(begin: 0.0, end: 56.0)
            .animate(
              CurvedAnimation(
                parent: controller1,
                curve: standardEasing,
              ),
            )
            .value,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: borderColor)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [sortText(decoration), child],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: GestureDetector(
          onTap: onClose,
          child: Container(
            width: 32,
            height: 32,
            decoration: decoration,
            child: Icon(
              Icons.clear_outlined,
              color: theme.textTheme.bodyText1.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget sortText(Decoration decoration) {
    var text;

    switch (sortBy.value) {
      case SortBy.Importance:
        text = localizations.w101;
        break;
      case SortBy.Alphabetically:
        text = localizations.w102;
        break;
      case SortBy.DueDate:
        text = localizations.w103;
        break;
      case SortBy.CreationDate:
        text = localizations.w104;
        break;
      case SortBy.None:
        break;
    }

    return Flexible(
      child: GestureDetector(
        onTap: animate,
        child: Container(
          height: 32,
          decoration: decoration,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText2,
                ),
              ),
              const SizedBox(width: 8),
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(controller2),
                child: Icon(
                  Icons.keyboard_arrow_up_outlined,
                  color: theme.textTheme.bodyText2.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget body() {
    if (reorderMode.value) {
      orderedTasks = useState(
        appTheme.moveBottomCompleted
            ? currentTasks.where((e) => !e.completed).toList()
            : currentTasks,
      );

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        sliver: SliverReorderableList(
          onReorder: onReorder,
          itemCount: orderedTasks.value.length,
          proxyDecorator: (child, _, animation) => AnimatedBuilder(
            child: child,
            animation: animation,
            builder: (_, child) {
              final animValue = Curves.easeInOut.transform(animation.value);
              final elevation = lerpDouble(0, 8, animValue);

              return Material(
                elevation: elevation,
                child: (child as Padding).child,
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),
          itemBuilder: (_, index) {
            final task = orderedTasks.value[index];
            final key = ValueKey(task.id);

            return Padding(
              key: key,
              padding: const EdgeInsets.only(bottom: 8),
              child: ReorderableDelayedDragStartListener(
                index: index,
                key: key,
                child: TaskCard(
                  key: key,
                  task: task,
                  dismissible: false,
                  ignoreGestures: true,
                  color: changeableData.value.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      );
    }

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          secondary: changeableData.value.color,
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: serviceTask.listenable,
        builder: (_, __, ___) {
          allTasks = isLabel
              ? serviceTask.getFromLabelID(data.id)
              : serviceTask.getFromListID(data.id, omit: false);

          currentTasks = !showCompleted.value
              ? allTasks.where((e) => !e.completed).toList()
              : allTasks;

          sort(currentTasks);

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  final task = currentTasks[index];

                  return TaskCard(
                    task: task,
                    useSizedBox: true,
                    key: ValueKey(task.id),
                    animatable: !showCompleted.value,
                    color: changeableData.value.color,
                    borderRadius: BorderRadius.circular(4),
                    listName: isLabel
                        ? serviceList.getFromID(task.listID).name
                        : null,
                  );
                },
                childCount: currentTasks.length,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget child(String text, {bool disabled = false}) {
    return Row(
      children: [
        Text(
          text,
          style: theme.textTheme.bodyText1.copyWith(
            color: disabled
                ? theme.textTheme.bodyText1.color.withOpacity(.38)
                : null,
          ),
        ),
      ],
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    final values = [...orderedTasks.value];

    if (oldIndex < newIndex) newIndex -= 1;

    final item = values.removeAt(oldIndex);
    values.insert(newIndex, item);

    orderedTasks.value = values;
  }

  void onSave() {
    orderedTasks.value.forEach((value) {
      final index = orderedTasks.value.indexOf(value);

      if (index != value.index) serviceTask.write(value.copyWith(index: index));
    });

    reorderMode.value = false;
  }

  void sort(List items) {
    final int Function(dynamic, dynamic) function = (a, b) {
      final x = !ascending.value ? b : a;
      final y = !ascending.value ? a : b;

      switch (sortBy.value) {
        case SortBy.Importance:
          return sortTasksByImportance(x, y);
        case SortBy.Alphabetically:
          return x.body.toLowerCase().compareTo(y.body.toLowerCase());
        case SortBy.DueDate:
          {
            if (a.dueDate == null && b.dueDate == null)
              return 0;
            else if (a.dueDate == null)
              return 1;
            else if (b.dueDate == null) return -1;

            return x.dueDate.compareTo(y.dueDate);
          }
        case SortBy.CreationDate:
          return x.creationDate.compareTo(y.creationDate);
        default:
          {
            if (!isLabel)
              return a.index.compareTo(b.index);
            else
              return 0;
          }
      }
    };

    if (appTheme.moveBottomCompleted) {
      items.sort((a, b) {
        if (a.completed == b.completed)
          return function(a, b);
        else if (a.completed)
          return 1;
        else
          return -1;
      });
    } else {
      items.sort(function);
    }
  }

  void animate() async {
    if (!controller2.isAnimating) {
      if (controller2.value == 0.5) {
        await controller2.animateTo(1.0);
        controller2.reset();
      } else {
        await controller2.animateTo(0.5);
      }

      service.write(
          service.getFromID(data.id).copyWith(ascending: !ascending.value));
      ascending.value = !ascending.value;
    }
  }

  void onClose() async {
    service.write(service
        .getFromID(data.id)
        .copyWith(sortBy: SortBy.None, ascending: true));
    await controller1.reverse();
    sortBy.value = SortBy.None;
    ascending.value = true;
  }

  void onSelected(Options option, BuildContext context) async {
    switch (option) {
      case Options.Sort:
        {
          final result = await showModal(
            context: context,
            builder: (_) => SortDialog(
              color: changeableData.value.color,
              sortBy: sortBy.value,
            ),
          );

          if (result != null && result != sortBy.value) {
            service.write(service
                .getFromID(data.id)
                .copyWith(sortBy: result, ascending: true));
            sortBy.value = result;
            ascending.value = true;
            controller2.value = 0.0;
            await controller1.forward();
          }
          break;
        }
      case Options.Clear:
        {
          final tasks = allTasks.where((e) => e.completed).toList();

          if (tasks.isNotEmpty) {
            showModal(
              context: context,
              builder: (_) => DeleteDialog(
                color: changeableData.value.color,
                title: localizations.p0(2),
                content: localizations.w91,
                onPressed: () => serviceTask.deleteCompleted(
                  pod,
                  tasks,
                  appTheme.includeSubtask,
                  skip: !showCompleted.value,
                ),
              ),
            );
          }

          break;
        }
      case Options.Reorder:
        reorderMode.value = true;
        break;
      case Options.Uncheck:
        {
          final tasks = currentTasks.where((e) => e.completed).toList();

          if (tasks.isNotEmpty) {
            tasks.forEach((e) {
              if (!showCompleted.value) context.read(animationPod).add(e.id);

              serviceTask.onChecked(context, e.id, false, task: e);
            });

            final snackBar = SnackBar(
              dismissDirection: DismissDirection.horizontal,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(24, 5, 24, 16),
              content: Text(
                localizations.p7(2),
                style: theme.textTheme.bodyText1,
              ),
              action: SnackBarAction(
                textColor: changeableData.value.color,
                label: AppLocalizations.instance.w66,
                overlayColor: changeableData.value.color.withOpacity(.2),
                onPressed: () async {
                  if (!showCompleted.value)
                    await pod.animate([tasks], justAnimate: true);

                  tasks.forEach((e) {
                    serviceTask.onChecked(context, e.id, true, task: e);
                  });
                },
                textStyle: theme.textTheme.bodyText2
                    .copyWith(color: changeableData.value.color),
              ),
              duration: const Duration(seconds: 5),
            );

            scaffoldMessenger.currentState.showSnackBar(snackBar);
          }

          break;
        }
      case Options.ShowHide:
        {
          final tasks = allTasks.where((e) => e.completed).toList();
          service.updateShowCompleted(data.id, !showCompleted.value);

          if (!showCompleted.value)
            context.read(animationPod).addAll(tasks.map((e) => e.id));
          else
            await pod.animate([tasks], justAnimate: true);

          showCompleted.value = !showCompleted.value;

          break;
        }
      case Options.Delete:
        showModal(
          context: context,
          builder: (_) => DeleteDialog(
            color: changeableData.value.color,
            title: isLabel ? localizations.w16 : localizations.w15,
            content: isLabel ? localizations.w90 : localizations.w87,
            onPressed: () {
              if (isLabel)
                (service as LabelService).delete(data.id);
              else
                (service as ListService)
                    .delete(data.id, includeSubtask: appTheme.includeSubtask);

              Navigator.pop(context);
            },
          ),
        );

        break;
      case Options.Edit:
        {
          final value = await showModal(
            context: context,
            builder: (_) => DataDialog(
              data: changeableData.value,
              color: changeableData.value.color,
              dataType: isLabel ? DataType.Label : DataType.List,
            ),
          );

          if (value != null) changeableData.value = value;

          break;
        }
    }
  }
}
