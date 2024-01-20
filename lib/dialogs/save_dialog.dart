import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';

class SaveDialog extends StatelessWidget with Utils {
  final Color color;

  const SaveDialog({this.color});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.instance;
    final textTheme = Theme.of(context).textTheme;
    final overlay = color.withOpacity(.12);
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

    return AlertDialog(
      title: Text(
        localizations.w186,
        style: textTheme.headline2.copyWith(color: color),
      ),
      content: ConstrainedBox(
        child: Text(localizations.w179, style: textTheme.bodyText1),
        constraints: BoxConstraints(maxWidth: 296),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(shape),
              overlayColor: MaterialStateProperty.all(overlay),
            ),
            child: Text(
              localizations.w64,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Theme.of(context).textTheme.bodyText1.color),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(shape),
                overlayColor: MaterialStateProperty.all(overlay),
              ),
              child: Text(
                localizations.w185,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(shape),
                overlayColor: MaterialStateProperty.all(overlay),
              ),
              child: Text(
                localizations.w184,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: color),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
