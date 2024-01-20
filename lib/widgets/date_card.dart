import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DateCard extends HookWidget with Utils {
  final Map map;
  final List tasks;
  final DateTime selectedDate;
  final AnimationController controller;
  final Function(DateTime dateTime) onPressed;

  const DateCard({
    this.map,
    this.tasks,
    this.onPressed,
    this.controller,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = useProvider(themePod).appTheme;
    final isNotEmpty = TaskService().isAnyTask(
        tasks, appTheme.showInCalendar, (e) => e.dueDate == map['date']);

    return GestureDetector(
      onTap: () => onPressed(map['date']),
      child: AnimatedContainer(
        width: 56,
        curve: Curves.ease,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: isNotEmpty ? Border.all(color: appTheme.color, width: 1.5) : null,
          color: selectedDate != map['date']
              ? Theme.of(context).colorScheme.onSurface
              : appTheme.color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            text(context, map['day'].toString()),
            AnimatedBuilder(
              animation: controller,
              child: text(context, map['name'], small: true),
              builder: (_, child) {
                return Opacity(
                  opacity: controller.value <= 0.5
                      ? fadeInAnim(controller).value
                      : fadeOutAnim(controller).value,
                  child: Transform.scale(
                    scale: controller.value <= 0.5
                        ? scaleIn().value
                        : scaleOut().value,
                    child: child,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget text(BuildContext context, String text, {bool small = false}) {
    final textTheme = Theme.of(context).textTheme;
    final color = getColor(textTheme);

    return AnimatedDefaultTextStyle(
      duration: kThemeAnimationDuration,
      style: small
          ? textTheme.bodyText1.copyWith(color: color)
          : textTheme.headline1.copyWith(color: color),
      child: Text(text),
    );
  }

  Color getColor(TextTheme textTheme) {
    final today = DateUtils.dateOnly(DateTime.now());
    final appColor = useProvider(themePod).appTheme.color;

    return selectedDate == map['date']
        ? getOnColor(appColor)
        : today != map['date']
            ? textTheme.bodyText1.color
            : appColor;
  }

  Animation<double> scaleIn() {
    return Tween(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );
  }

  Animation<double> scaleOut() {
    return Tween(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );
  }
}
