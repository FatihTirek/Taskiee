import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Color color;
  final String title;
  final bool initial;
  final IconData icon;
  final bool disabled;
  final Function onTap;
  final String subTitle;
  final bool trailingSwitch;

  const CustomTile({
    this.icon,
    this.color,
    this.title,
    this.onTap,
    this.subTitle,
    this.initial = true,
    this.disabled = false,
    this.trailingSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyText1 = theme.textTheme.bodyText1;
    final isLight = theme.colorScheme.brightness == Brightness.light;
    final textStyle = bodyText1.copyWith(
        color: initial ? bodyText1.color.withOpacity(.54) : bodyText1.color);

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          width: 1.5,
          color: isLight
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withOpacity(.56),
        ),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        trailing: trailing(context),
        leading: Icon(icon, color: color),
        title: Text(title, style: textStyle),
        visualDensity: VisualDensity.comfortable,
        subtitle: subTitle != null
            ? Text(subTitle, style: theme.textTheme.subtitle1)
            : null,
      ),
    );
  }

  Widget trailing(BuildContext context) {
    final theme = Theme.of(context);

    if (trailingSwitch) {
      return Theme(
        data: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            brightness: Brightness.light,
          ),
        ),
        child: Switch(
          onChanged: (_) => onTap(),
          value: !initial,
          activeColor: color,
          inactiveThumbColor: theme.colorScheme.surface,
        ),
      );
    }

    final iconColor =
        disabled ? theme.textTheme.bodyText1.color.withOpacity(.38) : color;

    return IconButton(
      onPressed: disabled ? null : () => onTap(),
      icon: Icon(Icons.add_outlined, color: iconColor),
    );
  }
}
