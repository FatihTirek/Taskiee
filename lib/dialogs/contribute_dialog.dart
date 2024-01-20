import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContributeDialog extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final appColor = useProvider(themePod).appTheme.color;
    final localizations = AppLocalizations.instance;

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Text(
        localizations.w19,
        style: Theme.of(context).textTheme.headline2.copyWith(color: appColor),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 296),
        child: Text(
          localizations.w89,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(appColor.withOpacity(.2)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text(
            localizations.w83,
            style:
                Theme.of(context).textTheme.bodyText1.copyWith(color: appColor),
          ),
        ),
      ],
    );
  }
}
