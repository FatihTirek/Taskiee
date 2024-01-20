import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/label.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/screens/task_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum PreviewType { Shape, Label, None }

// ignore: must_be_immutable
class LabelCard extends HookWidget with Utils {
  final Label label;
  final bool enlarge;
  final bool draggable;
  final bool isSelected;
  final bool isTaskLabel;
  final bool adjustColor;
  final LabelType labelType;
  final RectShape labelShape;
  final PreviewType previewType;

  const LabelCard({
    Key key,
    this.label,
    this.labelType,
    this.labelShape,
    this.enlarge = false,
    this.draggable = false,
    this.isSelected = false,
    this.isTaskLabel = false,
    this.adjustColor = false,
    this.previewType = PreviewType.None,
  }) : super(key: key);

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final appTheme = useProvider(themePod).appTheme;

    switch (previewType) {
      case PreviewType.Shape:
        return Container(
          width: 56,
          height: isTaskLabel ? 26 : 36,
          decoration: ShapeDecoration(
            shape: getShape(),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          child: Text(''),
        );
      case PreviewType.Label:
        final padding = isTaskLabel
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.all(9);

        return Material(
          color: getColor(context, labelType),
          shape: getShape(labelType: labelType),
          elevation: labelType == LabelType.Normal ? 1.5 : 0,
          child: Padding(
            padding: padding,
            child: Text(
              label.name,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: getTextColor(labelType)),
            ),
          ),
        );
      case PreviewType.None:
        return widget(context,
            isTaskLabel ? appTheme.innerLabelType : appTheme.outerLabelType);
    }
  }

  Widget widget(BuildContext context, LabelType labelType) {
    if (!isTaskLabel && !draggable) {
      final controller = useAnimationController(duration: kThemeChangeDuration);

      return ScaleTransition(
        scale: scaleAnim(controller),
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerUp: (event) => controller.reverse(),
          onPointerDown: (event) => controller.forward(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskView(data: label)),
            ),
            onLongPress: () {
              showOptionDialog(context, this);
              controller.reset();
            },
            child: child(context, labelType),
          ),
        ),
      );
    }

    return child(context, labelType);
  }

  Widget child(BuildContext context, LabelType labelType) {
    final innerLabelShape = useProvider(themePod).appTheme.innerLabelShape;
    final outerLabelShape = useProvider(themePod).appTheme.outerLabelShape;

    if (innerLabelShape == RectShape.BeveledRect && isTaskLabel) {
      return Material(
        color: getColor(context, labelType),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: getBorderSide(), width: .75),
        ),
        child: Container(
          padding: getPadding(),
          child: selectedWidget(context, labelType),
          alignment: isTaskLabel ? null : Alignment.center,
        ),
      );
    } else if (outerLabelShape == RectShape.BeveledRect && !isTaskLabel) {
      return Material(
        color: getColor(context, labelType),
        elevation: labelType == LabelType.Normal ? 1.5 : 0,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: getBorderSide(), width: .75),
        ),
        child: Container(
          padding: getPadding(),
          child: selectedWidget(context, labelType),
          alignment: isTaskLabel ? null : Alignment.center,
        ),
      );
    }

    final decoration = getDecoration(context, labelType);

    return Material(
      color: decoration.color,
      elevation: labelType == LabelType.Normal ? 1.5 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: decoration.borderRadius,
        side: decoration.border?.top ?? BorderSide.none,
      ),
      child: Padding(
        padding: getPadding(),
        child: isTaskLabel
            ? selectedWidget(context, labelType)
            : Center(child: selectedWidget(context, labelType)),
      ),
    );
  }

  Widget selectedWidget(BuildContext context, LabelType labelType) {
    if (isSelected) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Container(child: text(context, labelType))),
          const SizedBox(width: 4),
          Icon(
            Icons.done_outline_rounded,
            color: getTextColor(labelType),
            size: enlarge ? 16 : 15,
          ),
        ],
      );
    }

    return text(context, labelType);
  }

  Widget text(BuildContext context, LabelType labelType) {
    return Text(
      label.name,
      softWrap: false,
      maxLines: isTaskLabel ? 1 : 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: getStyle(context, labelType),
    );
  }

  // ignore: missing_return
  BorderRadius getRadius() {
    final innerLabelShape = useProvider(themePod).appTheme.innerLabelShape;
    final outerLabelShape = useProvider(themePod).appTheme.outerLabelShape;

    if (isTaskLabel) {
      switch (innerLabelShape) {
        case RectShape.RRectS:
          return BorderRadius.circular(2);
        case RectShape.RRectM:
          return BorderRadius.circular(7);
        case RectShape.RRectL:
          return BorderRadius.circular(32);
        case RectShape.BeveledRect:
          break;
      }
    }

    switch (outerLabelShape) {
      case RectShape.RRectS:
        return BorderRadius.circular(4);
      case RectShape.RRectM:
        return BorderRadius.circular(10);
      case RectShape.RRectL:
        return BorderRadius.circular(16);
      case RectShape.BeveledRect:
        break;
    }
  }

  // ignore: missing_return
  ShapeBorder getShape({LabelType labelType}) {
    final isFCMixin = labelType == LabelType.FCMixin;
    final isShape = previewType == PreviewType.Shape;
    final colorize = labelType == LabelType.ColoredBorder || isFCMixin;
    final color = isFCMixin ? label?.color?.withOpacity(.64) : label?.color;
    final shape = isTaskLabel
        ? useProvider(themePod).appTheme.innerLabelShape
        : useProvider(themePod).appTheme.outerLabelShape;

    switch (labelShape ?? shape) {
      case RectShape.RRectS:
        return RoundedRectangleBorder(
          side: colorize
              ? BorderSide(color: color, width: 1.5)
              : isShape
                  ? BorderSide(width: 1.5)
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(isTaskLabel ? 2 : 2),
        );
      case RectShape.RRectM:
        return RoundedRectangleBorder(
          side: colorize
              ? BorderSide(color: color, width: 1.5)
              : isShape
                  ? BorderSide(width: 1.5)
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(isTaskLabel ? 7 : 5),
        );
      case RectShape.RRectL:
        return RoundedRectangleBorder(
          side: colorize
              ? BorderSide(color: color, width: 1.5)
              : isShape
                  ? BorderSide(width: 1.5)
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(isTaskLabel ? 32 : 8),
        );
      case RectShape.BeveledRect:
        return BeveledRectangleBorder(
          side: colorize
              ? BorderSide(color: color, width: .75)
              : isShape
                  ? BorderSide(width: .75)
                  : BorderSide.none,
          borderRadius: BorderRadius.circular(isTaskLabel ? 6 : 7),
        );
    }
  }

  // ignore: missing_return
  static ShapeBorder getShapeFromOutside() {
    switch (useProvider(themePod).appTheme.outerLabelShape) {
      case RectShape.RRectS:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(2));
      case RectShape.RRectM:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
      case RectShape.RRectL:
        return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
      case RectShape.BeveledRect:
        return BeveledRectangleBorder(borderRadius: BorderRadius.circular(7));
    }
  }

  // ignore: missing_return
  Color getBorderSide() {
    final appTheme = useProvider(themePod).appTheme;
    final type =
        isTaskLabel ? appTheme.innerLabelType : appTheme.outerLabelType;

    switch (labelType ?? type) {
      case LabelType.Normal:
        return Colors.transparent;
      case LabelType.ColoredBorder:
        return label.color;
      case LabelType.Colored:
        return Colors.transparent;
      case LabelType.Faded:
        return Colors.transparent;
      case LabelType.FCMixin:
        return label.color.withOpacity(.64);
    }
  }

  // ignore: missing_return
  BoxDecoration getDecoration(BuildContext context, LabelType labelType) {
    final radius = getRadius();

    switch (labelType) {
      case LabelType.Normal:
        return BoxDecoration(
          borderRadius: radius,
          color: Theme.of(context).colorScheme.surface,
        );
      case LabelType.ColoredBorder:
        return BoxDecoration(
          borderRadius: radius,
          color: isTaskLabel
              ? adjustColor
                  ? Theme.of(context).colorScheme.background
                  : Theme.of(context).colorScheme.surface
              : Theme.of(context).colorScheme.background,
          border: Border.all(color: label.color, width: 1.5),
        );
      case LabelType.Colored:
        return BoxDecoration(
          borderRadius: radius,
          color: label.color,
        );
      case LabelType.Faded:
        return BoxDecoration(
          borderRadius: radius,
          color: label.color.withOpacity(.2),
        );
      case LabelType.FCMixin:
        return BoxDecoration(
          borderRadius: radius,
          color: label.color.withOpacity(.16),
          border: Border.all(color: label.color.withOpacity(.64), width: 1.5),
        );
    }
  }

  // ignore: missing_return
  Color getColor(BuildContext context, LabelType labelType) {
    switch (labelType) {
      case LabelType.Normal:
        return previewType == PreviewType.Label
            ? Theme.of(context).colorScheme.onSurface
            : Theme.of(context).colorScheme.surface;
      case LabelType.Colored:
        return label.color;
      case LabelType.Faded:
        return label.color.withOpacity(.2);
      case LabelType.FCMixin:
        return label.color.withOpacity(.16);
      case LabelType.ColoredBorder:
        return previewType == PreviewType.None && !isTaskLabel
            ? Theme.of(context).colorScheme.background
            : adjustColor
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).colorScheme.surface;
    }
  }

  Color getTextColor(LabelType labelType) {
    return labelType == LabelType.Colored
        ? getOnColor(label.color)
        : label.color;
  }

  EdgeInsets getPadding() {
    return isTaskLabel
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 16);
  }

  TextStyle getStyle(BuildContext context, LabelType labelType) {
    final textTheme = Theme.of(context).textTheme;

    return isTaskLabel
        ? enlarge
            ? textTheme.subtitle1.copyWith(color: getTextColor(labelType))
            : textTheme.subtitle2.copyWith(color: getTextColor(labelType))
        : textTheme.headline4.copyWith(color: getTextColor(labelType));
  }
}
