import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/widgets/info_box.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/widgets/label_card.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/widgets/grouped_task_card.dart';
import 'package:taskiee/widgets/contextual_app_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ignore: must_be_immutable
class TaskFilter extends HookWidget with Utils {
  Color color;
  ThemeData theme;
  List currentTasks;
  ValueNotifier<List> filters;
  ValueNotifier<bool> showCompleted;


  final serviceTask = TaskService();
  final serviceLabel = LabelService();
  final localizations = AppLocalizations.instance;

  @override
  Widget build(BuildContext context) {
    filters = useState([]);
    theme = Theme.of(context);
    showCompleted = useState(false);
    color = useProvider(themePod).appTheme.color;

    final labels = serviceLabel.read()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    final painter = TextPainter(
      text: TextSpan(text: 'PlaceHolder', style: theme.textTheme.subtitle1),
      maxLines: 1,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
      textDirection: TextDirection.ltr,
    )..layout();

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: ScaffoldMessenger(
        child: Scaffold(
          bottomNavigationBar: Container(
            height: 2 * (painter.size.height + 8) + 22,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.black54,
                )
              ],
            ),
            child: labels.isEmpty
                ? Center(
                    child: Text(
                      localizations.w46,
                      style: theme.textTheme.headline4,
                    ),
                  )
                : MasonryGridView.builder(
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    itemCount: labels.length,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (_, index) {
                      final label = labels[index];
      
                      return Center(
                        child: GestureDetector(
                          onTap: () => handleOnTap(label.id),
                          child: LabelCard(
                            label: label,
                            enlarge: true,
                            isTaskLabel: true,
                            isSelected: filters.value.contains(label.id),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          body: Theme(
            data: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(secondary: color)),
            child: CustomScrollView(slivers: [appBar(context), body()]),
          ),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    if (!useProvider(utilsPod).isShowing) {
      return SliverAppBar(
        pinned: true,
        elevation: 2,
        forceElevated: true,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        title: Text(
          localizations.w8,
          style: theme.textTheme.headline2,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined, color: color),
          onPressed: () => onPop(context),
        ),
        actions: [
          PopupMenuButton(
            tooltip: '',
            icon: Icon(Icons.more_vert_outlined, color: color),
            onSelected: (value) {
              showCompleted.value = !showCompleted.value;
            },
            itemBuilder: (_) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 0,
                child: Text(
                  showCompleted.value ? localizations.w34 : localizations.w33,
                  style: theme.textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return ContextualAppBar(items: currentTasks);
  }

  Widget body() {
    final service = ListService();

    return ValueListenableBuilder(
      valueListenable: serviceTask.listenable,
      builder: (_, __, ___) {
        currentTasks = serviceLabel.getTasksFromLabels(filters.value,
            showCompleted: showCompleted.value);

        if (currentTasks.isNotEmpty) {
          final lists = service.getFromTasks(currentTasks);

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  if (index.isEven) {
                    final list = lists[index ~/ 2];
                    final groupedTasks =
                        currentTasks.where((e) => e.listID == list.id).toList();

                    return GroupedTaskCard(tasks: groupedTasks, list: list);
                  }

                  return const SizedBox(height: 30);
                },
                childCount: 2 * lists.length - 1,
              ),
            ),
          );
        }

        return SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: InfoBox(
              error:
                  filters.value.isEmpty ? localizations.w47 : localizations.w50,
              icon: filters.value.isEmpty ? Icons.search_outlined : null,
            ),
          ),
        );
      },
    );
  }

  void handleOnTap(String id) {
    final values = [...filters.value];

    if (values.contains(id))
      values.remove(id);
    else
      values.add(id);

    filters.value = values;
  }
}
