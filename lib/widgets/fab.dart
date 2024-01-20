import 'dart:math' show pi, sqrt;

import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ignore: must_be_immutable
class FAB extends HookWidget with Utils {
  final FABShape previewShape;

  FAB({this.previewShape});

  ThemeData theme;
  FABShape shape;
  Color appColor;

  @override
  Widget build(BuildContext context) {
    shape = previewShape ?? useProvider(themePod).appTheme.fabShape;
    appColor = useProvider(themePod).appTheme.color;
    theme = Theme.of(context);

    final color = getOnColor(appColor).withOpacity(.2);

    return Theme(
      data: theme.copyWith(splashColor: color, highlightColor: color),
      child: child(context),
    );
  }

  // ignore: missing_return
  Widget child(BuildContext context) {
    switch (shape) {
      case FABShape.RRect:
        return Transform.rotate(
            angle: pi / 4, child: floatingActionButton(context));
      case FABShape.Hexagon:
        final widget = ClipPath(
          clipper: _FABClipper(),
          child: Container(
            width: previewShape != null ? 80 / sqrt(3) : 112 / sqrt(3),
            height: previewShape != null ? 40 : 56,
            child: floatingActionButton(context),
          ),
        );

        if (previewShape != null)
          return CustomPaint(painter: _FABPainter(), child: widget);

        return widget;

      case FABShape.Circular:
        return floatingActionButton(context);
    }
  }

  Widget floatingActionButton(BuildContext context) {
    if (previewShape != null) {
      return SizedBox(
        width: shape == FABShape.RRect ? 36 : 44,
        height: shape == FABShape.RRect? 36 : 44,
        child: FloatingActionButton(
          elevation: 0,
          heroTag: null,
          onPressed: null,
          shape: shapeBorder(),
          backgroundColor: theme.colorScheme.onSurface,
        ),
      );
    }

    final child = Icon(
      Icons.add_outlined,
      color: getOnColor(appColor),
      size: 30,
    );

    return FloatingActionButton(
      heroTag: null,
      elevation: 0,
      child: shape == FABShape.RRect
          ? Transform.rotate(angle: pi / 4, child: child)
          : child,
      shape: shapeBorder(),
      backgroundColor: appColor,
      onPressed: () => showMyModalSheet(context),
    );
  }

  // ignore: missing_return
  ShapeBorder shapeBorder() {
    switch (previewShape ?? shape) {
      case FABShape.RRect:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: previewShape != null ? BorderSide(width: 1.5) : BorderSide.none,
        );
      case FABShape.Hexagon:
        return RoundedRectangleBorder();
      case FABShape.Circular:
        return RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(64),
          side: previewShape != null ? BorderSide(width: 1.5) : BorderSide.none,
        );
    }
  }
}

class _FABClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    final x = size.height / 2;
    final y = x / sqrt(3);

    path.moveTo(y, 0);
    path.lineTo(3 * y, 0);
    path.lineTo(4 * y, x);
    path.lineTo(3 * y, size.height);
    path.lineTo(y, size.height);
    path.lineTo(0, x);

    return path;
  }

  @override
  bool shouldReclip(_FABClipper oldClipper) => false;
}

class _FABPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..strokeWidth = 3.0
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final x = size.height / 2;
    final y = x / sqrt(3);

    path.moveTo(y, 0);
    path.lineTo(3 * y, 0);
    path.lineTo(4 * y, x);
    path.lineTo(3 * y, size.height);
    path.lineTo(y, size.height);
    path.lineTo(0, x);

    canvas.drawLine(Offset(y, 0), Offset(3 * y, 0), paint);
    canvas.drawLine(Offset(3 * y, 0), Offset(4 * y, x), paint);
    canvas.drawLine(Offset(4 * y, x), Offset(3 * y, size.height), paint);
    canvas.drawLine(Offset(3 * y, size.height), Offset(y, size.height), paint);
    canvas.drawLine(Offset(y, size.height), Offset(0, x), paint);
    canvas.drawLine(Offset(0, x), Offset(y, 0), paint);
  }

  @override
  bool shouldRepaint(_FABPainter oldDelegate) => false;
}
