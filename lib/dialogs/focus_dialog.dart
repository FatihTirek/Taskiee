import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/dialogs/delete_dialog.dart';
import 'package:taskiee/services/label_service.dart';

class FocusDialog extends StatelessWidget with Utils {
  final Size size;
  final dynamic child;
  final Offset offset;

  const FocusDialog({this.child, this.size, this.offset});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final value = child is LabelCard ||
        (offset.dy + size.height + 12 > height || offset.dy < 28);
    final optionOffset = value ? vertical(context) : horizontal(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: Colors.black54,
            ),
          ),
          Positioned(
            top: offset.dy,
            left: offset.dx,
            width: size.width,
            height: size.height,
            child: IgnorePointer(
              ignoring: true,
              child: child,
            ),
          ),
          Positioned(
            top: optionOffset.dy,
            left: optionOffset.dx,
            width: value ? size.width : null,
            height: value ? null : size.height,
            child: layout(context, value),
          ),
        ],
      ),
    );
  }

  Widget layout(BuildContext context, bool value) {
    if (value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget(context, Icons.edit, 0),
          widget(context, Icons.delete, 1),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        widget(context, Icons.edit, 0),
        widget(context, Icons.delete, 1),
      ],
    );
  }

  Widget widget(BuildContext context, IconData icon, int index) {
    final color = child is LabelCard ? child.label.color : child.list.color;

    return GestureDetector(
      onTap: () => index == 0 ? edit(context) : delete(context, color),
      child: Material(
        elevation: 3,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(48),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: color),
        ),
      ),
    );
  }

  Offset horizontal(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (offset.dx > width / 2) return Offset(offset.dx - 60, offset.dy);

    return Offset(offset.dx + size.width + 12, offset.dy);
  }

  Offset vertical(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    if (offset.dy > height / 2) return Offset(offset.dx, offset.dy - 60);

    return Offset(offset.dx, offset.dy + size.height + 12);
  }

  List getValues(BuildContext context) {
    final localizations = AppLocalizations.instance;

    if (child is LabelCard) {
      final title = localizations.w16;
      final content = localizations.w90;
      final function = () => LabelService().delete(child.label.id);

      return [title, content, function];
    }

    final title = localizations.w15;
    final content = localizations.w87;
    final includeSubtask = context.read(themePod).appTheme.includeSubtask;
    final function = () => ListService().delete(child.list.id, includeSubtask: includeSubtask);

    return [title, content, function];
  }

  void edit(BuildContext context) {
    Navigator.pop(context);

    final data = child is LabelCard ? child.label : child.list;
    final dataType = child is LabelCard ? DataType.Label : DataType.List;

    showModal(
      context: context,
      builder: (_) => DataDialog(data: data, dataType: dataType),
    );
  }

  void delete(BuildContext context, Color color) {
    Navigator.pop(context);

    final values = getValues(context);

    showModal(
      context: context,
      builder: (_) => DeleteDialog(
        color: color,
        title: values[0],
        content: values[1],
        onPressed: values[2],
      ),
    );
  }
}
