import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InfoBox extends HookWidget {
  final String error;
  final IconData icon;

  const InfoBox({this.error, this.icon});

  @override
  Widget build(BuildContext context) {
    final bodyText1 = Theme.of(context).textTheme.bodyText1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon ?? Icons.report_gmailerrorred_outlined,
          color: useProvider(themePod).appTheme.color,
          size: 128,
        ),
        Text(
          error,
          textAlign: TextAlign.center,
          style: bodyText1.copyWith(color: bodyText1.color.withOpacity(.54)),
        ),
      ],
    );
  }
}
