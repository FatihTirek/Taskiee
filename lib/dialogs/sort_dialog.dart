import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';

enum SortBy { Importance, Alphabetically, DueDate, CreationDate, None }

// ignore: must_be_immutable
class SortDialog extends StatelessWidget with Utils {
  final Color color;
  final SortBy sortBy;

  SortDialog({this.color, this.sortBy});

  final data = [
    {'icon': Icons.star_rounded, 'text': AppLocalizations.instance.w73},
    {
      'icon': Icons.sort_by_alpha_outlined,
      'text': AppLocalizations.instance.w74
    },
    {'icon': Icons.today_outlined, 'text': AppLocalizations.instance.w75},
    {'icon': Icons.update_outlined, 'text': AppLocalizations.instance.w86},
  ];

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      title: Text(
        AppLocalizations.instance.w23,
        style: Theme.of(context).textTheme.headline2.copyWith(color: color),
      ),
      content: SizedBox(
        width: 296,
        child: ScrollConfiguration(
          behavior: NonGlowBehavior(),
          child: GridView.builder(
            itemCount: 4,
            shrinkWrap: true,
            itemBuilder: (_, index) =>
                widget(data[index], SortBy.values[index], context),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: isPortrait ? 1.25 : 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget widget(Map map, SortBy sortBy, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final subTitle1 = Theme.of(context).textTheme.subtitle1;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () => Navigator.pop(context, sortBy),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1.5,
            color: sortBy == this.sortBy
                ? color
                : isLight
                    ? colorScheme.onSurface
                    : colorScheme.surface,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(map['icon'], color: subTitle1.color),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                map['text'],
                maxLines: 2,
                softWrap: false,
                style: subTitle1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
