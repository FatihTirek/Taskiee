import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationHelp extends StatelessWidget {
  final localizations = AppLocalizations.instance;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: textTheme.bodyText1.color,
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(localizations.w143, style: textTheme.headline2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...issue(Theme.of(context)),
            const SizedBox(height: 16),
            ...solution(Theme.of(context)),
          ],
        ),
      ),
    );
  }

  List<Widget> issue(ThemeData theme) {
    return [
      Text(localizations.w144, style: theme.textTheme.headline4),
      const SizedBox(height: 4),
      Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(localizations.w145, style: theme.textTheme.bodyText1),
      ),
    ];
  }

  List<Widget> solution(ThemeData theme) {
    return [
      Text(localizations.w146, style: theme.textTheme.headline4),
      const SizedBox(height: 4),
      Material(
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.surface,
        child: ListTile(
          onTap: onTap,
          minVerticalPadding: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(localizations.w147, style: theme.textTheme.bodyText1),
        ),
      ),
      const SizedBox(height: 8),
      Material(
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.surface,
        child: ListTile(
          minVerticalPadding: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(localizations.w177, style: theme.textTheme.bodyText1),
        ),
      ),
      const SizedBox(height: 8),
      Material(
        borderRadius: BorderRadius.circular(4),
        color: theme.colorScheme.surface,
        child: ListTile(
          minVerticalPadding: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          title: Text(localizations.w178, style: theme.textTheme.bodyText1),
        ),
      ),
    ];
  }

  void onTap() async {
    if (!await Permission.ignoreBatteryOptimizations.isGranted)
      Permission.ignoreBatteryOptimizations.request();
  }
}
