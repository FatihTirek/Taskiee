import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IconPicker extends HookWidget with Utils {
  final Color color;

  const IconPicker({this.color});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final icons = LineIcons.values.values.toList();
    final currentColor = color ?? useProvider(themePod).appTheme.color;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Text(
        AppLocalizations.instance.w6,
        style: textTheme.headline2.copyWith(color: currentColor),
      ),
      content: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(maxHeight: 372, maxWidth: 360),
        child: ScrollConfiguration(
          behavior: NonGlowBehavior(),
          child: RawScrollbar(
            interactive: true,
            minThumbLength: 32,
            thumbVisibility: true,
            radius: Radius.circular(8),
            thumbColor: textTheme.bodyText1.color.withOpacity(.12),
            child: GridView.builder(
              itemCount: icons.length,
              padding: const EdgeInsets.only(bottom: 12, right: 8),
              itemBuilder: (_, index) {
                final icon = icons[index];

                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(icon),
                  child: Icon(
                    icon,
                    size: 28,
                    color: textTheme.bodyText1.color,
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                maxCrossAxisExtent: 44,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
