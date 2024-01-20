import 'dart:math' show sqrt, sqrt2;

import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomNavigationBar extends HookWidget {
  final Widget child;

  const CustomNavigationBar({this.child});

  @override
  Widget build(BuildContext context) {
    final pod = useProvider(themePod);
    final colorScheme = Theme.of(context).colorScheme;
    final color = !pod.appTheme.darkenBottomBarColor
        ? colorScheme.brightness == Brightness.light
            ? colorScheme.surface
            : colorScheme.onSurface
        : colorScheme.surface;

    return CustomPaint(
      painter: _NavigationBarPainter(color, pod.appTheme.fabShape),
      size: Size.fromHeight(56),
      child: child,
    );
  }
}

class _NavigationBarPainter extends CustomPainter {
  final Color color;
  final FABShape shape;

  const _NavigationBarPainter(this.color, this.shape);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final halfWidth = size.width / 2;

    switch (shape) {
      case FABShape.RRect:
        {
          final halfSquare = (56 * sqrt2 / 2);

          path.lineTo(halfWidth - halfSquare - 16, 0);
          path.conicTo(
              halfWidth - halfSquare - 8, 0, halfWidth - halfSquare, 8, 2);

          path.lineTo(halfWidth - 8, halfSquare);
          path.conicTo(halfWidth, halfSquare + 8, halfWidth + 8, halfSquare, 4);

          path.lineTo(halfWidth + halfSquare, 8);
          path.conicTo(
              halfWidth + halfSquare + 8, 0, halfWidth + halfSquare + 16, 0, 2);

          path.lineTo(size.width, 0);
          path.lineTo(size.width, 56);
          path.lineTo(0, 56);
        }
        break;
      case FABShape.Hexagon:
        {
          final fabWidth = 112 / sqrt(3);

          path.lineTo(halfWidth - (fabWidth / 2) - 6, 0);
          path.lineTo(halfWidth - (fabWidth / 4) - 3, 34);
          path.lineTo(halfWidth + (fabWidth / 4) + 3, 34);
          path.lineTo(halfWidth + (fabWidth / 2) + 6, 0);
          path.lineTo(size.width, 0);
          path.lineTo(size.width, 56);
          path.lineTo(0, 56);
        }
        break;
      case FABShape.Circular:
        {
          final button = Rect.fromCenter(
            width: 56,
            height: 56,
            center: Offset(halfWidth, 0),
          );

          final host = Offset.zero & size;
          final guest = button.inflate(6.0);
          final double notchRadius = guest.width / 2.0;

          const double s1 = 15.0;
          const double s2 = 1.0;

          final double r = notchRadius;
          final double a = -1.0 * r - s2;
          final double b = host.top - guest.center.dy;

          final double n2 = sqrt(b * b * r * r * (a * a + b * b - r * r));
          final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
          final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
          final double p2yA = sqrt(r * r - p2xA * p2xA);
          final double p2yB = sqrt(r * r - p2xB * p2xB);

          final List<Offset> p = List<Offset>.filled(6, null);

          p[0] = Offset(a - s1, b);
          p[1] = Offset(a, b);
          final double cmp = b < 0 ? -1.0 : 1.0;
          p[2] =
              cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

          p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
          p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
          p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

          for (int i = 0; i < p.length; i += 1) p[i] = p[i] + guest.center;

          path
            ..moveTo(host.left, host.top)
            ..lineTo(p[0].dx, p[0].dy)
            ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
            ..arcToPoint(
              p[3],
              radius: Radius.circular(notchRadius),
              clockwise: false,
            )
            ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
            ..lineTo(host.right, host.top)
            ..lineTo(host.right, host.bottom)
            ..lineTo(host.left, host.bottom)
            ..close();
        }

        break;
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.black54
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_NavigationBarPainter oldDelegate) =>
      oldDelegate.color != color;
}
