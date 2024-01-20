import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/list_card.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/dialogs/data_dialog.dart' show DataType;
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class Reorder extends HookWidget {
  final DataType dataType;

  const Reorder({this.dataType});

  @override
  Widget build(BuildContext context) {
    String title;
    Service service;
    ShapeBorder shape;
    double aspectRatio;
    ValueNotifier<List> data;
    Function(dynamic data) child;

    switch (dataType) {
      case DataType.List:
        aspectRatio = 1.0;
        service = ListService();
        title = AppLocalizations.instance.w164;
        shape = ListCard.getShapeFromOutside();
        child =
            (list) => ListCard(list: list, draggable: true, key: UniqueKey());
        data = useState(
            service.read()..sort((a, b) => a.index.compareTo(b.index)));
        break;
      case DataType.Label:
        aspectRatio = 2.0;
        service = LabelService();
        title = AppLocalizations.instance.w165;
        shape = LabelCard.getShapeFromOutside();
        child = (label) =>
            LabelCard(label: label, draggable: true, key: UniqueKey());
        data = useState(
            service.read()..sort((a, b) => a.index.compareTo(b.index)));
        break;
      case DataType.Note:
        throw UnimplementedError();
    }

    final labelType = useProvider(themePod).appTheme.outerLabelType;
    final crossAxisExtent = MediaQuery.of(context).size.width - 32;
    final crossAxisCount = (crossAxisExtent / 210).ceil();
    final textTheme = Theme.of(context).textTheme;
    final onlyChild = dataType == DataType.Label &&
        (labelType == LabelType.Faded || labelType == LabelType.FCMixin);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: textTheme.bodyText1.color,
          ),
        ),
        title: Text(title, style: textTheme.headline2),
        actions: [
          IconButton(
            onPressed: () {
              data.value.forEach((value) {
                service.write(
                  value.copyWith(index: data.value.indexOf(value)),
                );
              });
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.done_outline_rounded,
              color: textTheme.bodyText1.color,
            ),
          ),
        ],
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: useProvider(themePod).appTheme.color),
        ),
        child: ReorderableGridView.builder(
          crossAxisSpacing: -22,
          childAspectRatio: aspectRatio,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: dataType == DataType.List ? -22 : -6,
          onReorder: (oldIndex, newIndex) {
            final values = [...data.value];

            final item = values.removeAt(oldIndex);
            values.insert(newIndex, item);

            data.value = values;
          },
          itemCount: data.value.length,
          cacheExtent: data.value.length * 5.0,
          dragWidgetBuilder: (_, child) => onlyChild
              ? child
              : Material(
                  elevation: 12,
                  child: child,
                  shape: shape,
                  color: Colors.transparent,
                ),
          itemBuilder: (_, index) => child(data.value[index]),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 72),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            maxCrossAxisExtent: 192,
            childAspectRatio: aspectRatio,
          ),
        ),
      ),
    );
  }
}
