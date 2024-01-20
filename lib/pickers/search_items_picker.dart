import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchItemsPicker extends HookWidget with Utils {
  final List data;

  const SearchItemsPicker({this.data});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appColor = useProvider(themePod).appTheme.color;
    final localizations = AppLocalizations.instance;
    final showValues = [
      useState(data[0]),
      useState(data[1]),
      useState(data[2]),
      useState(data[3]),
      useState(data[4]),
    ];
    final textValues = [
      localizations.w53,
      localizations.w51,
      localizations.w54,
      localizations.p5(2),
      localizations.w55,
    ];

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Text(
        localizations.w20,
        style: textTheme.headline2.copyWith(color: appColor),
      ),
      content: Theme(
        data: Theme.of(context).copyWith(unselectedWidgetColor: appColor),
        child: SizedBox(
          width: 296,
          child: ScrollConfiguration(
            behavior: NonGlowBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: showValues.map((e) {
                  return CheckboxListTile(
                    value: e.value,
                    activeColor: appColor,
                    checkColor: getOnColor(appColor),
                    onChanged: (value) => e.value = value,
                    title: Text(textValues[showValues.indexOf(e)],
                        style: textTheme.headline4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      actions:
          actions(context, onPressed: () => onPressed(context, showValues)),
    );
  }

  void onPressed(BuildContext context, List showValues) {
    Navigator.pop(
        context, showValues.map((showValue) => showValue.value).toList());
  }
}
