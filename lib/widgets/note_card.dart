import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/note.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoteCard extends HookWidget with Utils {
  final Note note;

  const NoteCard({this.note});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isShowing = useProvider(utilsPod).isShowing;
    final appColor = useProvider(themePod).appTheme.color;
    final isAfter = note.reminder?.isAfter(DateTime.now()) ?? false;

    return GestureDetector(
      onTap: !isShowing
          ? () => showModal(
                context: context,
                builder: (_) => DataDialog(
                  data: note,
                  dataType: DataType.Note,
                ),
              )
          : null,
      child: Material(
        elevation: 1.5,
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.content.toString(),
                maxLines: 12,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: textTheme.subtitle1,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      toLocalizedDate(context, note.creationDate, shrink: true),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: textTheme.subtitle2.copyWith(
                        fontSize: textTheme.subtitle2.fontSize - 1.5,
                        color: textTheme.subtitle2.color.withOpacity(.54),
                      ),
                    ),
                  ),
                  note.pinned || isAfter
                      ? Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.fromLTRB(4, 2, 4, 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: textTheme.bodyText1.color.withOpacity(.45),
                          ),
                        )
                      : const SizedBox(),
                  note.pinned
                      ? Padding(
                          padding: const EdgeInsets.only(right: 2),
                          child: Icon(
                            Icons.push_pin_outlined,
                            color: appColor,
                            size: 12,
                          ),
                        )
                      : const SizedBox(),
                  isAfter
                      ? Icon(
                          Icons.notifications_active_outlined,
                          color: appColor,
                          size: 12,
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
