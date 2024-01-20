import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';

class DeleteDialog extends StatelessWidget with Utils {
  final Color color;
  final String title;
  final String content;
  final Function onPressed;

  const DeleteDialog({this.title, this.content, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: Text(
        title,
        style: textTheme.headline2.copyWith(color: color),
      ),
      content: ConstrainedBox(
        child: Text(content, style: textTheme.bodyText1),
        constraints: BoxConstraints(maxWidth: 296),
      ),
      actions: actions(
        context,
        color: color,
        onPressed: () => onTap(context),
        rightAction: AppLocalizations.instance.w65,
      ),
    );
  }

  void onTap(BuildContext context) {
    onPressed();
    Navigator.pop(context);
  }
}
