import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/widgets/info_box.dart';
import 'package:taskiee/widgets/gridviews.dart';
import 'package:taskiee/widgets/task_card.dart';
import 'package:taskiee/screens/task_filter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/note_service.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/services/subtask_service.dart';
import 'package:taskiee/widgets/grouped_task_card.dart';
import 'package:taskiee/widgets/contextual_app_bar.dart';
import 'package:taskiee/pickers/search_items_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

enum Option { Toggle, Picker, Filter }

class Search extends StatefulHookWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with Utils {
  Color appColor;
  ThemeData theme;
  TextEditingController controller;

  ValueNotifier<bool> showClear;
  ValueNotifier<bool> showCompleted;
  ValueNotifier<bool> keyboardVisible;

  ValueNotifier<bool> showTasks;
  ValueNotifier<bool> showLists;
  ValueNotifier<bool> showNotes;
  ValueNotifier<bool> showLabels;
  ValueNotifier<bool> showSubTasks;

  ValueNotifier<List> taskData;
  ValueNotifier<List> listData;
  ValueNotifier<List> noteData;
  ValueNotifier<List> labelData;
  ValueNotifier<List> subTaskData;

  ValueNotifier<List> cacheTask;
  ValueNotifier<List> cacheList;
  ValueNotifier<List> cacheNote;
  ValueNotifier<List> cacheLabel;
  ValueNotifier<List> cacheSubTask;

  final serviceTask = TaskService();
  final serviceList = ListService();
  final serviceNotes = NoteService();
  final serviceLabel = LabelService();
  final serviceSubTask = SubTaskService();
  final localizations = AppLocalizations.instance;
  final keyboardController = KeyboardVisibilityController();

  @override
  void initState() {
    super.initState();

    serviceTask.listenable.addListener(() {
      if (mounted && ModalRoute.of(context).isCurrent) {
        cacheTask.value = serviceTask.read();
        final keyword = controller.text.trim();

        if (showTasks.value)
          taskData.value = serviceTask.search(keyword, cacheTask.value);
      }
    });

    serviceSubTask.listenable.addListener(() {
      if (showSubTasks.value && mounted && ModalRoute.of(context).isCurrent) {
        cacheSubTask.value = serviceSubTask.read();
        subTaskData.value =
            serviceSubTask.search(controller.text.trim(), cacheSubTask.value);
      }
    });

    serviceLabel.listenable.addListener(() {
      if (showLabels.value && mounted && ModalRoute.of(context).isCurrent) {
        cacheLabel.value = serviceLabel.read();
        labelData.value =
            serviceLabel.search(controller.text.trim(), cacheLabel.value);
      }
    });

    serviceList.listenable.addListener(() {
      if (showLists.value && mounted && ModalRoute.of(context).isCurrent) {
        cacheList.value = serviceList.read();
        listData.value =
            serviceList.search(controller.text.trim(), cacheList.value);
      }
    });

    serviceNotes.listenable.addListener(() {
      if (showNotes.value && mounted && ModalRoute.of(context).isCurrent) {
        cacheNote.value = serviceNotes.read();
        noteData.value = serviceNotes.search(
            controller.text.trim(), cacheNote.value)
          ..sort(sortNotesByImportance);
      }
    });

    keyboardController.onChange.listen((visible) {
      if (mounted) {
        if (!visible) FocusScope.of(context).unfocus();
        keyboardVisible.value = visible;
      }
    });
  }

  @override
  void dispose() {
    serviceSubTask.listenable.removeListener(() {});
    serviceLabel.listenable.removeListener(() {});
    serviceTask.listenable.removeListener(() {});
    serviceList.listenable.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    controller = useTextEditingController();
    appColor = useProvider(themePod).appTheme.color;

    cacheTask = useState(serviceTask.read());
    cacheList = useState(serviceList.read());
    cacheNote = useState(serviceNotes.read());
    cacheLabel = useState(serviceLabel.read());
    cacheSubTask = useState(serviceSubTask.read());

    taskData = useState([]);
    listData = useState([]);
    noteData = useState([]);
    labelData = useState([]);
    subTaskData = useState([]);

    showTasks = useState(true);
    showNotes = useState(false);
    showLists = useState(false);
    showLabels = useState(false);
    showSubTasks = useState(false);

    showClear = useState(false);
    showCompleted = useState(false);
    keyboardVisible = useState(false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          appBar(),
          ...taskWidgets(),
          ...subTaskWidgets(),
          ...noteWidgets(),
          ...listWidgets(),
          ...labelWidgets(),
          infoWidget(),
          spacer(),
        ],
      ),
    );
  }

  Widget appBar() {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 12),
      sliver: useProvider(utilsPod).isShowing
          ? ContextualAppBar(items: [...taskData.value, ...subTaskData.value])
          : SliverAppBar(
              pinned: true,
              title: title(),
              elevation: 2,
              actions: action(),
              forceElevated: true,
            ),
    );
  }

  Widget title() {
    return TextField(
      onChanged: onChanged,
      cursorColor: appColor,
      controller: controller,
      style: theme.textTheme.bodyText1,
      decoration: InputDecoration(
        hintText: localizations.w70,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: theme.textTheme.bodyText1.copyWith(color: appColor),
      ),
    );
  }

  List<Widget> action() {
    return [
      showClear.value
          ? IconButton(
              onPressed: onClear,
              icon: Icon(Icons.clear_outlined, color: appColor),
            )
          : const SizedBox(),
      PopupMenuButton(
        tooltip: '',
        onSelected: onSelected,
        icon: Icon(Icons.more_vert_outlined, color: appColor),
        itemBuilder: (_) => <PopupMenuEntry>[
          PopupMenuItem(
            value: Option.Toggle,
            child: Text(
              showCompleted.value ? localizations.w34 : localizations.w33,
            ),
            textStyle: theme.textTheme.bodyText1,
          ),
          PopupMenuItem(
            value: Option.Picker,
            child: Text(localizations.w20.capitalize()),
            textStyle: theme.textTheme.bodyText1,
          ),
          PopupMenuItem(
            value: Option.Filter,
            child: Text(localizations.w35),
            textStyle: theme.textTheme.bodyText1,
          ),
        ],
      ),
    ];
  }

  List<Widget> taskWidgets() {
    if (showTasks.value) {
      var tasks = showCompleted.value
          ? taskData.value
          : taskData.value.where((e) => !e.completed).toList();

      final lists = serviceList.getFromTasks(tasks);

      if (tasks.isNotEmpty) {
        return [
          separator(localizations.w53),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 22, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  if (index.isEven) {
                    final list = lists[index ~/ 2];
                    final groupedTasks =
                        tasks.where((e) => e.listID == list.id).toList();

                    return GroupedTaskCard(list: list, tasks: groupedTasks);
                  }

                  return const SizedBox(height: 30);
                },
                childCount: 2 * lists.length - 1,
              ),
            ),
          ),
        ];
      }
    }

    return [];
  }

  List<Widget> subTaskWidgets() {
    if (showSubTasks.value) {
      var subTasks = showCompleted.value
          ? subTaskData.value
          : subTaskData.value.where((e) => !e.completed).toList();

      if (subTasks.isNotEmpty) {
        return [
          separator(localizations.w55),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) {
                  final subTask = subTasks[index];
                  final task = serviceTask.getFromID(subTask.taskID);
                  final list = serviceList.getFromID(task.listID);

                  return TaskCard(
                    task: task,
                    subTask: subTask,
                    useSizedBox: true,
                    color: list.color,
                    key: ValueKey(subTask.id),
                    cardType: CardType.SubTask,
                    subTaskUsedIn: SubTaskUsedIn.InSearch,
                    borderRadius: BorderRadius.circular(4),
                  );
                },
                childCount: subTasks.length,
              ),
            ),
          ),
        ];
      }
    }

    return [];
  }

  List<Widget> labelWidgets() {
    if (labelData.value.isNotEmpty && showLabels.value) {
      return [
        separator(localizations.p5(2)),
        GridViews(
          inSearch: true,
          gridType: GridType.Labels,
          gridData: labelData.value,
        ),
      ];
    }

    return [];
  }

  List<Widget> listWidgets() {
    if (listData.value.isNotEmpty && showLists.value) {
      return [
        separator(localizations.w51),
        GridViews(
          inSearch: true,
          gridType: GridType.Lists,
          gridData: listData.value,
        ),
      ];
    }

    return [];
  }

  List<Widget> noteWidgets() {
    if (noteData.value.isNotEmpty && showNotes.value) {
      return [
        separator(localizations.w54),
        GridViews(
          inSearch: true,
          gridType: GridType.Notes,
          gridData: noteData.value,
        ),
      ];
    }

    return [];
  }

  Widget infoWidget() {
    if (isEmpty()) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 68),
          child: InfoBox(
            error: controller.text.isEmpty
                ? localizations.w49
                : localizations.w50,
            icon: controller.text.isEmpty ? Icons.search_outlined : null,
          ),
        ),
      );
    }

    return SliverToBoxAdapter();
  }

  Widget spacer() {
    if (!keyboardVisible.value && !isEmpty())
      return SliverToBoxAdapter(child: const SizedBox(height: 56));

    return SliverToBoxAdapter();
  }

  Widget separator(String text) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(text, style: theme.textTheme.headline2),
      ),
    );
  }

  bool isEmpty() {
    return taskData.value.isEmpty &&
        listData.value.isEmpty &&
        subTaskData.value.isEmpty &&
        labelData.value.isEmpty &&
        noteData.value.isEmpty;
  }

  void onChanged(String value) {
    final text = value.trim().toLowerCase();

    showClear.value = value.isNotEmpty;

    if (text.isNotEmpty) {
      if (showTasks.value)
        taskData.value = serviceTask.search(text, cacheTask.value);
      if (showLists.value)
        listData.value = serviceList.search(text, cacheList.value);
      if (showNotes.value)
        noteData.value = serviceNotes.search(text, cacheNote.value)
          ..sort(sortNotesByImportance);
      if (showLabels.value)
        labelData.value = serviceLabel.search(text, cacheLabel.value);
      if (showSubTasks.value)
        subTaskData.value = serviceSubTask.search(text, cacheSubTask.value);
    } else {
      taskData.value = [];
      listData.value = [];
      noteData.value = [];
      labelData.value = [];
      subTaskData.value = [];
    }
  }

  void onClear() {
    showClear.value = false;
    controller.clear();

    taskData.value = [];
    listData.value = [];
    noteData.value = [];
    labelData.value = [];
    subTaskData.value = [];
  }

  void onSelected(option) async {
    switch (option) {
      case Option.Toggle:
        {
          showCompleted.value = !showCompleted.value;
          break;
        }
      case Option.Picker:
        {
          final valuesBool = [
            showTasks.value,
            showLists.value,
            showNotes.value,
            showLabels.value,
            showSubTasks.value,
          ];

          final values = await showModal(
            context: context,
            builder: (_) => SearchItemsPicker(data: valuesBool),
          );

          if (values != null) {
            final text = controller.text.trim();

            if (showTasks.value != values[0]) {
              if (showTasks.value || text.isEmpty)
                taskData.value = [];
              else
                taskData.value = serviceTask.search(text, cacheTask.value);
              showTasks.value = values[0];
            }
            if (showNotes.value != values[2]) {
              if (showNotes.value || text.isEmpty)
                noteData.value = [];
              else
                noteData.value = serviceNotes.search(text, cacheNote.value)
                  ..sort(sortNotesByImportance);
              showNotes.value = values[2];
            }
            if (showLists.value != values[1]) {
              if (showLists.value || text.isEmpty)
                listData.value = [];
              else
                listData.value = serviceList.search(text, cacheList.value);
              showLists.value = values[1];
            }
            if (showLabels.value != values[3]) {
              if (showLabels.value || text.isEmpty)
                labelData.value = [];
              else
                labelData.value = serviceLabel.search(text, cacheLabel.value);
              showLabels.value = values[3];
            }
            if (showSubTasks.value != values[4]) {
              if (showSubTasks.value || text.isEmpty)
                subTaskData.value = [];
              else
                subTaskData.value =
                    serviceSubTask.search(text, cacheSubTask.value);
              showSubTasks.value = values[4];
            }
          }
          break;
        }
      case Option.Filter:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => TaskFilter()));
          break;
        }
    }
  }
}
