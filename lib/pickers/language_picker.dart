import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/dialogs/contribute_dialog.dart';

class LanguagePicker extends HookWidget with Utils {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appColor = useProvider(themePod).appTheme.color;
    final language = useState(useProvider(themePod).appTheme.language);

    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 24.0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.instance.w9,
            style: textTheme.headline2.copyWith(color: appColor),
          ),
          GestureDetector(
            onTap: () => showModal(
              context: context,
              builder: (_) => ContributeDialog(),
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: textTheme.bodyText1.color,
            ),
          ),
        ],
      ),
      content: Theme(
        data: Theme.of(context).copyWith(
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.all(appColor),
          ),
        ),
        child: Container(
          width: 296,
          constraints: BoxConstraints(maxHeight: 376),
          child: ScrollConfiguration(
            behavior: NonGlowBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Language.values.map((e) {
                  return RadioListTile(
                    value: e,
                    groupValue: language.value,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) => language.value = value,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title:
                        Text(AppTheme.getLanguage(e), style: textTheme.bodyText1),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      actions: actions(
        context,
        onPressed: () => onTap(context, language.value),
      ),
    );
  }

  void onTap(BuildContext context, Language language) {
    context.read(themePod).setLanguage(language);
    Navigator.pop(context);
  }
}
