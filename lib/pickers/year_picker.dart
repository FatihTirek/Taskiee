import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/task_service.dart';

class YearPicker extends HookWidget with Utils {
  final List tasks;
  final int selectedYear;

  const YearPicker({this.tasks, this.selectedYear});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final service = TaskService();
    final textTheme = Theme.of(context).textTheme;
    final appTheme = useProvider(themePod).appTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Text(
        AppLocalizations.instance.w2,
        style: textTheme.headline2.copyWith(color: appTheme.color),
      ),
      content: SizedBox(
        width: 264,
        height: 296,
        child: ScrollConfiguration(
          behavior: NonGlowBehavior(),
          child: GridView.builder(
            itemCount: 50,
            padding: const EdgeInsets.only(bottom: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (_, index) {
              final year = (now.year + index);
              final isCurrentYear = year == selectedYear;
              final anyTask = service.isAnyTask(tasks, appTheme.showInCalendar,
                  (e) => e.dueDate?.year == year);

              return GestureDetector(
                onTap: () =>
                    Navigator.pop(context, DateTime(year, now.month, now.day)),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCurrentYear ? appTheme.color : null,
                    border: anyTask
                        ? Border.all(color: appTheme.color, width: 1.5)
                        : null,
                    borderRadius: isCurrentYear || anyTask
                        ? BorderRadius.circular(32)
                        : null,
                  ),
                  child: Text(
                    year.toString(),
                    style: textTheme.bodyText1.copyWith(
                      color: isCurrentYear
                          ? getOnColor(appTheme.color)
                          : textTheme.bodyText1.color,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
