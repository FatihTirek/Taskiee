import 'package:taskiee/main.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FeedBackDialog extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.instance;
    final style = Theme.of(context).textTheme.bodyText1;
    final appColor = useProvider(themePod).appTheme.color;

    return AlertDialog(
      buttonPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(top: 12),
      insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        localizations.w21,
        style: Theme.of(context).textTheme.headline2.copyWith(color: appColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: reportBug,
            title: Text(localizations.w138, style: style),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          ListTile(
            onTap: suggestFeature,
            title: Text(localizations.w139, style: style),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          ListTile(
            onTap: reportTranslationBug,
            title: Text(localizations.w140, style: style),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          ListTile(
            onTap: contribute,
            title: Text(localizations.w141, style: style),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(appColor.withOpacity(.2)),
          ),
          child: Text(
            localizations.w64,
            style: style.copyWith(color: appColor),
          ),
        ),
      ],
    );
  }

  void reportBug() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final info = 'App Version: $versionName\nAndroid Version: '
        '${androidInfo.version.release}\nDevice: ${androidInfo.brand} '
        '${androidInfo.model} (${androidInfo.product})';

    final emailUri = Uri(
      scheme: 'mailto',
      path: 'taskieehelp@gmail.com',
      query: 'subject=Bug/Issue Report\n\n$info',
    );

    launchUrl(emailUri);
  }

  void suggestFeature() {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'taskieehelp@gmail.com',
      query: 'subject=Feature Suggestion',
    );

    launchUrl(emailUri);
  }

  void reportTranslationBug() {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'taskieehelp@gmail.com',
      query: 'subject=Translation Error',
    );

    launchUrl(emailUri);
  }

  void contribute() {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'taskieehelp@gmail.com',
      query: 'subject=Translation Contribution',
    );

    launchUrl(emailUri);
  }
}
