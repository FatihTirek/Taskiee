import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/widgets/task_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class GroupedTaskCard extends HookWidget with Utils {
  final List tasks;
  final AppList list;

  const GroupedTaskCard({this.list, this.tasks});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [taskWidgets(), header(context)],
      ),
    );
  }

  Widget taskWidgets() {
    tasks.sort(sortTasksByImportance);

    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: tasks
            .map(
              (task) => TaskCard(
                task: task,
                elevation: 0,
                borderRadius: tasks[tasks.length - 1].id == task.id
                    ? BorderRadius.vertical(bottom: Radius.circular(4))
                    : BorderRadius.zero,
                color: list.color,
                key: ValueKey(task.id),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget header(BuildContext context) {
    final painter = TextPainter(
      maxLines: 1,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: list.name,
        style: Theme.of(context).textTheme.headline4,
      ),
    )..layout();

    return Positioned(
      left: 8,
      right: 8,
      top: -14,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: (28 - painter.size.height) / 2,
              ),
              decoration: BoxDecoration(
                color: list.color,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                list.name,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: getOnColor(list.color)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
