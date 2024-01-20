import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/screens/task_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListCard extends HookWidget with Utils {
  final AppList list;
  final bool draggable;
  final RectShape listShape;

  const ListCard({
    Key key,
    this.list,
    this.listShape,
    this.draggable = false,
  }) : super(key: key);

  static const kDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    if (list != null) {
      if (draggable) return child(context);

      final controller = useAnimationController(duration: kDuration);

      return ScaleTransition(
        scale: scaleAnim(controller),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerUp: (event) => controller.reverse(),
          onPointerDown: (event) => controller.forward(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => TaskView(data: list))),
            onLongPress: () {
              showOptionDialog(context, this);
              controller.reset();
            },
            child: child(context),
          ),
        ),
      );
    }

    return Container(
      width: 36,
      height: 36,
      decoration: getDecoration(context),
    );
  }

  Widget child(BuildContext context) {
    var size;

    switch (useProvider(themePod).appTheme.listIconSize) {
      case ListIconSize.Normal:
        size = 40.0;
        break;
      case ListIconSize.Big:
        size = 44.0;
        break;
      case ListIconSize.Bigger:
        size = 48.0;
        break;
    }

    return Material(
      elevation: 1.5,
      shape: getShape(),
      color: list == null
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(list.iconData, size: size, color: list.color),
            Flexible(
              child: Text(
                list.name,
                maxLines: 2,
                softWrap: false,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            bottom(context),
          ],
        ),
      ),
    );
  }

  Decoration getDecoration(BuildContext context) {
    return ShapeDecoration(
      shape: getShape(),
      color: list == null
          ? Theme.of(context).colorScheme.onSurface
          : Theme.of(context).colorScheme.surface,
    );
  }

  // ignore: missing_return
  ShapeBorder getShape() {
    final isPreview = list == null;

    switch (listShape ?? useProvider(themePod).appTheme.listShape) {
      case RectShape.RRectS:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isPreview ? 2 : 4),
          side: isPreview ? BorderSide(width: 1.5) : BorderSide.none,
        );
      case RectShape.RRectM:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isPreview ? 5 : 10),
          side: isPreview ? BorderSide(width: 1.5) : BorderSide.none,
        );
      case RectShape.RRectL:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isPreview ? 8 : 16),
          side: isPreview ? BorderSide(width: 1.5) : BorderSide.none,
        );
      case RectShape.BeveledRect:
        return BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(isPreview ? 8 : 16),
          side: isPreview ? BorderSide(width: .75) : BorderSide.none,
        );
    }
  }

  // ignore: missing_return
  static ShapeBorder getShapeFromOutside() {
    switch (useProvider(themePod).appTheme.listShape) {
      case RectShape.RRectS:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));
      case RectShape.RRectM:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
      case RectShape.RRectL:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
      case RectShape.BeveledRect:
        return BeveledRectangleBorder(borderRadius: BorderRadius.circular(16));
    }
  }

  Widget bottom(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: list.done,
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: list.color,
                  borderRadius: list.done == list.total
                      ? BorderRadius.circular(2)
                      : BorderRadius.horizontal(left: Radius.circular(2)),
                ),
              ),
            ),
            Expanded(
              flex: list.total == 0 ? 1 : list.total - list.done,
              child: Container(
                height: 14,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: list.done == 0
                      ? BorderRadius.circular(2)
                      : BorderRadius.horizontal(right: Radius.circular(2)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${list.done * 100 ~/ (list.total <= 0 ? 1 : list.total)}%',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ],
    );
  }
}
