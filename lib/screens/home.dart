import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/gridviews.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/note_service.dart';
import 'package:taskiee/services/label_service.dart';

// ignore: must_be_immutable
class Home extends HookWidget with Utils {
  ValueNotifier<int> currentPage;
  PageController controller;
  TextTheme textTheme;

  final data = [
    {'service': ListService(), 'gridType': GridType.Lists},
    {'service': LabelService(), 'gridType': GridType.Labels},
    {'service': NoteService(), 'gridType': GridType.Notes},
  ];

  @override
  Widget build(BuildContext context) {
    currentPage = useState(0);
    controller = usePageController();
    textTheme = Theme.of(context).textTheme;

    final appTheme = useProvider(themePod).appTheme;

    var dataType;
    var icon;

    switch (currentPage.value) {
      case 0:
        dataType = DataType.List;
        icon = Icons.playlist_add_outlined;
        break;
      case 1:
        dataType = DataType.Label;
        icon = Icons.new_label_outlined;
        break;
      case 2:
        dataType = DataType.Note;
        icon = Icons.note_add_outlined;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                child(AppLocalizations.instance.w51, 0, appTheme.color),
                const SizedBox(width: 16),
                child(AppLocalizations.instance.p5(2), 1, appTheme.color),
                const SizedBox(width: 16),
                child(AppLocalizations.instance.w54, 2, appTheme.color),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => showModal(
              context: context,
              builder: (_) => DataDialog(
                dataType: dataType,
                color: appTheme.color,
              ),
            ),
            icon: Icon(icon, color: appTheme.color),
          ),
        ],
      ),
      body: PageView(
        onPageChanged: (value) => currentPage.value = value,
        controller: controller,
        children: [
          gridView(ListService(), GridType.Lists, appTheme),
          gridView(LabelService(), GridType.Labels, appTheme),
          gridView(NoteService(), GridType.Notes, appTheme),
        ],
      ),
    );
  }

  Widget child(String text, int page, Color appColor) {
    return GestureDetector(
      onTap: () {
        if (currentPage.value != page) {
          currentPage.value = page;
          controller.animateToPage(
            page,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 300),
          );
        }
      },
      child: Text(
        text,
        style: textTheme.headline3.copyWith(
          color: currentPage.value == page ? appColor : null,
        ),
      ),
    );
  }

  Widget gridView(Service service, GridType gridType, AppTheme appTheme) {
    return ValueListenableBuilder(
      valueListenable: service.listenable,
      builder: (_, __, ___) {
        final gridData = service.read();

        switch (gridType) {
          case GridType.Lists:
            gridData.sort((a, b) => sort(a, b, appTheme.listSortType));
            break;
          case GridType.Labels:
            gridData.sort((a, b) => sort(a, b, appTheme.labelSortType));
            break;
          case GridType.Notes:
            gridData.sort((a, b) => sort(a, b, null, isNote: true));
            break;
        }

        return GridViews(gridData: gridData, gridType: gridType);
      },
    );
  }

  int sort(a, b, SortType sortType, {bool isNote = false}) {
    switch (sortType) {
      case SortType.AlphabeticAZ:
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      case SortType.AlphabeticZA:
        return b.name.toLowerCase().compareTo(a.name.toLowerCase());
      case SortType.CreationNewest:
        return b.creationDate.compareTo(a.creationDate);
      case SortType.CreationOldest:
        return a.creationDate.compareTo(b.creationDate);
      case SortType.Custom:
        return a.index.compareTo(b.index);
      default:
        if (isNote) return sortNotesByImportance(a, b);

        return b.creationDate.compareTo(a.creationDate);
    }
  }
}
