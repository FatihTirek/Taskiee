import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/label.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/label_service.dart';

// ignore: must_be_immutable
class ListPicker extends HookWidget with Utils {
  final Color color;
  final String initialID;

  ListPicker({this.color, this.initialID});

  ValueNotifier<String> selectedID;

  final service = ListService();

  @override
  Widget build(BuildContext context) {
    selectedID = useState(initialID);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 24.0),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: _Title(dataType: DataType.List, color: color),
      content: ValueListenableBuilder(
        valueListenable: service.listenable,
        builder: (_, __, ___) {
          final data = service.read()
            ..sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 376, maxWidth: 360),
            child: ScrollConfiguration(
              behavior: NonGlowBehavior(),
              child: SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (_, index) => child(data[index], context),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                ),
              ),
            ),
          );
        },
      ),
      actions: actions(
        context,
        color: color,
        onPressed: () => onTapDone(context),
      ),
    );
  }

  Widget child(AppList list, BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      splashColor: list.color.withOpacity(.2),
      highlightColor: list.color.withOpacity(.2),
      onTap: () => onTap(list.id),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: list.id == selectedID.value
              ? list.color.withOpacity(.2)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Icon(list.iconData, color: list.color, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                child: Text(
                  list.name,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onTap(String id) {
    if (selectedID.value != id) selectedID.value = id;
  }

  void onTapDone(BuildContext context) {
    if (selectedID.value != null) {
      final selectedList = service.getFromID(selectedID.value);

      Navigator.pop(context, selectedList);
    }
  }
}

class LabelPicker extends StatefulHookWidget {
  final Color color;
  final bool skipLoop;
  final String ignore;
  final List initialIDS;

  const LabelPicker({
    this.color,
    this.ignore,
    this.initialIDS,
    this.skipLoop = false,
  });

  @override
  _LabelPickerState createState() => _LabelPickerState();
}

class _LabelPickerState extends State<LabelPicker> with Utils {
  ValueNotifier<List> allLabels;
  ValueNotifier<List> selectedLabels;

  final service = LabelService();

  @override
  void initState() {
    super.initState();
    service.listenable.addListener(() {
      if (mounted) allLabels.value = service.read();
    });
  }

  @override
  void dispose() {
    service.listenable.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    allLabels = useState(service.read());
    selectedLabels = useState(widget.initialIDS);

    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      title: _Title(dataType: DataType.Label, color: widget.color),
      content: child(),
      actions: actions(
        context,
        color: widget.color,
        onPressed: onTapDone,
      ),
    );
  }

  Widget child() {
    allLabels.value
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 376, maxWidth: 360),
      child: ScrollConfiguration(
        behavior: NonGlowBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 360,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: allLabels.value.map((e) {
                return IgnorePointer(
                  ignoring: widget.ignore == e.id,
                  child: GestureDetector(
                    onTap: () => onTap(e),
                    child: LabelCard(
                      label: e,
                      enlarge: true,
                      isTaskLabel: true,
                      adjustColor: true,
                      isSelected: selectedLabels.value.contains(e.id),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void onTap(Label label) {
    final values = [...selectedLabels.value];

    if (values.contains(label.id))
      values.remove(label.id);
    else
      values.add(label.id);

    selectedLabels.value = values;
  }

  void onTapDone() {
    var result;

    if (widget.skipLoop)
      result = selectedLabels.value;
    else
      result = selectedLabels.value
          .map((id) => allLabels.value.firstWhere((e) => e.id == id))
          .toList();

    Navigator.pop(context, result);
  }
}

class _Title extends StatelessWidget with Utils {
  final DataType dataType;
  final Color color;

  const _Title({this.dataType, this.color});

  @override
  Widget build(BuildContext context) {
    var title;
    var icon;

    switch (dataType) {
      case DataType.List:
        title = AppLocalizations.instance.w3;
        icon = Icons.playlist_add_outlined;
        break;
      case DataType.Label:
        title = AppLocalizations.instance.w7;
        icon = Icons.new_label_outlined;
        break;
      case DataType.Note:
        throw UnimplementedError();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline2.copyWith(color: color),
        ),
        GestureDetector(
          onTap: () => showModal(
            context: context,
            builder: (_) => DataDialog(dataType: dataType, color: color),
          ),
          child: Container(
            width: 36,
            height: 36,
            child: Icon(icon, color: getOnColor(color)),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ],
    );
  }
}
