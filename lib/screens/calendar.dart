import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/date_card.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:taskiee/pods/animation_pod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/widgets/grouped_task_card.dart';
import 'package:taskiee/widgets/contextual_app_bar.dart';
import 'package:taskiee/pickers/year_picker.dart' as yearPicker;

class Calendar extends StatefulHookWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with Utils {
  ValueNotifier<DateTime> selectedDate;
  ValueNotifier<DateTime> selectedDay;
  AnimationController animController;
  ScrollController scrollController;
  ValueNotifier<List> allDueTasks;
  ValueNotifier<List> monthDays;

  List currentTasks;
  AppTheme appTheme;
  ThemeData theme;

  final serviceTask = TaskService();
  final serviceList = ListService();

  @override
  void initState() {
    serviceTask.listenable.addListener(() {
      if (mounted) allDueTasks.value = serviceTask.getAllDue();
    });
    super.initState();
  }

  @override
  void dispose() {
    serviceTask.listenable.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    animController =
        useAnimationController(duration: const Duration(milliseconds: 400));
    scrollController = useScrollController(initialScrollOffset: getOffset());
    selectedDate = useState(DateUtils.dateOnly(now));
    selectedDay = useState(DateUtils.dateOnly(now));
    allDueTasks = useState(serviceTask.read());
    appTheme = useProvider(themePod).appTheme;
    monthDays = useState(getMonthDays(now));
    theme = Theme.of(context);

    return CustomScrollView(slivers: [appBar(), body()]);
  }

  Widget appBar() {
    if (!useProvider(utilsPod).isShowing) {
      return SliverAppBar(
        snap: true,
        elevation: 2,
        floating: true,
        forceElevated: true,
        toolbarHeight: 132,
        backgroundColor: theme.colorScheme.surface,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8),
          child: Column(
            children: [controls(), const SizedBox(height: 8), picker()],
          ),
        ),
      );
    }

    return ContextualAppBar(items: currentTasks);
  }

  Widget controls() {
    final format =
        DateFormat('MMMM, y', Localizations.localeOf(context).languageCode);
    final currentDate = format.format(selectedDate.value);
    final exit =
        Tween(begin: 0.0, end: 30.0).chain(CurveTween(curve: standardEasing));
    final enter =
        Tween(begin: -60.0, end: 0.0).chain(CurveTween(curve: standardEasing));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedBuilder(
            animation: animController,
            child: GestureDetector(
              onTap: onYearSelected,
              child: Row(
                children: [
                  Text(currentDate, style: theme.textTheme.headline2),
                  Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: appTheme.color,
                  ),
                ],
              ),
            ),
            builder: (_, child) => Opacity(
              opacity: animController.value <= 0.5
                  ? fadeInAnim(animController).value
                  : fadeOutAnim(animController).value,
              child: Transform.translate(
                offset: animController.value <= 0.5
                    ? Offset(exit.evaluate(animController), 0)
                    : Offset(enter.evaluate(animController), 0),
                child: child,
              ),
            ),
          ),
          Row(
            children: [
              _Button(
                iconData: Icons.arrow_back_outlined,
                onTap: () => onTap(),
              ),
              const SizedBox(width: 12),
              _Button(
                iconData: Icons.arrow_forward_outlined,
                onTap: () => onTap(forward: true),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget body() {
    currentTasks = serviceTask.getFromDue(
      selectedDay.value,
      allDueTasks.value,
      showCompleted: appTheme.showInCalendar,
    );

    final lists = serviceList.getFromTasks(currentTasks);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 26, 16, 96),
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

  Widget picker() {
    return Container(
      height: 72,
      width: double.infinity,
      child: ListView.separated(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: monthDays.value.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) => DateCard(
          onPressed: onPressed,
          tasks: allDueTasks.value,
          controller: animController,
          map: monthDays.value[index],
          selectedDate: selectedDay.value,
        ),
      ),
    );
  }

  List getMonthDays(DateTime dateTime) {
    List monthDays = [];
    final locale = Localizations.localeOf(context).languageCode;
    final numberOfDayInMonth = DateTime(dateTime.year, dateTime.month + 1, 0);

    for (int i = 0; i < numberOfDayInMonth.day; i++) {
      final date = DateTime(dateTime.year, dateTime.month, i + 1);
      final name = DateFormat.E(locale).format(date);
      final data = {'date': date, 'day': date.day, 'name': name};

      monthDays.add(data);
    }

    return monthDays;
  }

  void onYearSelected() async {
    final date = await showModal(
      context: context,
      builder: (_) => yearPicker.YearPicker(
        tasks: allDueTasks.value,
        selectedYear: selectedDate.value.year,
      ),
    );

    if (date != null && date != selectedDate.value) {
      animController.reset();
      await animController.animateTo(0.5);
      monthDays.value = getMonthDays(date);
      selectedDate.value = date;
      await animController.animateTo(1);
    }
  }

  void onTap({bool forward = false}) async {
    if (!animController.isAnimating) {
      animController.reset();
      final result = DateTime(
          selectedDate.value.year,
          forward ? selectedDate.value.month + 1 : selectedDate.value.month - 1,
          1);

      await animController.animateTo(0.5);
      monthDays.value = getMonthDays(result);
      selectedDate.value = result;
      await animController.animateTo(1);
    }
  }

  void onPressed(DateTime dateTime) {
    selectedDay.value = dateTime;
    context.read(animationPod).clear();
  }

  double getOffset() {
    final now = DateTime.now();
    final width = MediaQuery.of(context).size.width;
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    final max = (width / 68).floor();
    final remainder = width - 68 * max - 16;

    return now.day <= lastDay - max
        ? 4.0 + 68.0 * (now.day - 1)
        : 68.0 * (lastDay - max - 1) + 72 - remainder;
  }
}

class _Button extends HookWidget {
  final Function onTap;
  final IconData iconData;

  const _Button({this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColor = useProvider(themePod).appTheme.color;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Icon(iconData, color: appColor),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}
