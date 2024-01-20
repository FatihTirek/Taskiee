import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Options { PickDate, DeleteMultiple, Move, MarkImportant, NoDueDate }

class ContextualAppBar extends HookWidget with Utils {
  final List items;
  final Color color;

  const ContextualAppBar({this.items, this.color});

  @override
  Widget build(BuildContext context) {
    final pod = useProvider(utilsPod);
    final theme = Theme.of(context);
    final color = theme.textTheme.bodyText1.color;

    return SliverAppBar(
      pinned: true,
      elevation: 2,
      forceElevated: true,
      leading: IconButton(
        onPressed: () => pod.isShowing = false,
        icon: Icon(Icons.clear_outlined, color: color),
      ),
      actions: trailing(context, pod, color, theme.textTheme.bodyText1),
      title: Text(pod.length.toString(), style: theme.textTheme.headline2),
    );
  }

  List<Widget> trailing(
      BuildContext context, UtilsPod pod, Color color, TextStyle textStyle) {
    if (pod.isTaskOnly) {
      return [
        IconButton(
          onPressed: () => pod.onSelectAll(items),
          icon: Icon(Icons.select_all_outlined, color: color),
        ),
        PopupMenuButton(
          tooltip: '',
          onSelected: (value) => onSelected(context, pod, value),
          icon: Icon(Icons.today_outlined, color: color),
          itemBuilder: (_) => [
            PopupMenuItem(
              textStyle: textStyle,
              value: Options.NoDueDate,
              child: Text(AppLocalizations.instance.w37),
            ),
            PopupMenuItem(
              textStyle: textStyle,
              value: Options.PickDate,
              child: Text(AppLocalizations.instance.w38),
            ),
          ],
        ),
        PopupMenuButton(
          tooltip: '',
          icon: Icon(Icons.more_vert_outlined, color: color),
          onSelected: (value) => onSelected(context, pod, value),
          itemBuilder: (_) => [
            PopupMenuItem(
              textStyle: textStyle,
              value: Options.MarkImportant,
              child: Text(AppLocalizations.instance.w39),
            ),
            PopupMenuItem(
              textStyle: textStyle,
              value: Options.Move,
              child: Text(AppLocalizations.instance.w40),
            ),
            PopupMenuItem(
              textStyle: textStyle,
              value: Options.DeleteMultiple,
              child:
                  Text(AppLocalizations.instance.p0(pod.length).capitalize()),
            ),
          ],
        ),
      ];
    }

    return [
      IconButton(
        onPressed: () => pod.onSelectAll(items),
        icon: Icon(Icons.select_all_outlined, color: color),
      ),
      IconButton(
        onPressed: () => pod.onDelete(context, this.color),
        icon: Icon(Icons.delete_outline_outlined, color: color),
      ),
    ];
  }

  void onSelected(BuildContext context, UtilsPod pod, Options options) {
    switch (options) {
      case Options.PickDate:
        pod.onSchedule(context, color: color);
        break;
      case Options.DeleteMultiple:
        pod.onDelete(context, color);
        break;
      case Options.Move:
        pod.onMove(context, color);
        break;
      case Options.MarkImportant:
        pod.onMark();
        break;
      case Options.NoDueDate:
        pod.onSchedule(context, noDue: true);
        break;
    }
  }
}
