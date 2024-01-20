import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/note.dart';
import 'package:taskiee/widgets/fab.dart';
import 'package:taskiee/screens/home.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/screens/search.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/pods/utils_pod.dart';
import 'package:taskiee/screens/calendar.dart';
import 'package:taskiee/screens/settings.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/widgets/custom_bar.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:taskiee/dialogs/data_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Page { Home, Search, Calendar, Settings }

class Body extends StatefulHookWidget {
  final Note data;

  const Body({this.data});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with Utils {
  bool isLight;
  UtilsPod pod;
  ThemeData theme;
  AppTheme appTheme;
  ValueNotifier<Page> page;

  final pages = [Home(), Search(), Calendar(), Settings()];

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModal(
          context: context,
          builder: (_) => DataDialog(
            data: widget.data,
            dataType: DataType.Note,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    page = useState(Page.Home);
    pod = useProvider(utilsPod);
    appTheme = useProvider(themePod).appTheme;
    isLight = theme.colorScheme.brightness == Brightness.light;

    final splash = theme.textTheme.bodyText1.color.withOpacity(.12);

    return Theme(
      data: theme.copyWith(
        splashColor: splash,
        highlightColor: splash,
        colorScheme: theme.colorScheme.copyWith(secondary: appTheme.color),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: appTheme.color,
          selectionHandleColor: appTheme.color,
          selectionColor: appTheme.color.withOpacity(.24),
        ),
      ),
      child: WillPopScope(
        onWillPop: () => onWillPop(context),
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: CustomNavigationBar(child: child()),
          floatingActionButton:
              IgnorePointer(ignoring: pod.isShowing, child: FAB()),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: PageTransitionSwitcher(
            layoutBuilder: (entries) => Stack(
              children: entries,
              alignment: Alignment.topCenter,
            ),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
              return FadeThroughTransition(
                child: child,
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                fillColor: theme.colorScheme.background,
              );
            },
            child: pages[page.value.index],
          ),
        ),
      ),
    );
  }

  Widget child() {
    return IgnorePointer(
      ignoring: pod.isShowing,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icons(Icons.home_rounded, Page.Home),
          icons(Icons.search_outlined, Page.Search),
          const SizedBox(width: 64),
          icons(Icons.event_rounded, Page.Calendar),
          icons(Icons.settings_rounded, Page.Settings),
        ],
      ),
    );
  }

  Widget icons(IconData iconData, Page page) {
    var size;
    var padding;

    switch (page) {
      case Page.Home:
        size = 28.0;
        padding = EdgeInsets.zero;
        break;
      case Page.Search:
        size = 28.0;
        padding = EdgeInsets.zero;
        break;
      case Page.Calendar:
        size = 26.0;
        padding = EdgeInsets.only(top: 4);
        break;
      case Page.Settings:
        size = 25.0;
        padding = EdgeInsets.only(top: 2);
        break;
    }

    return Expanded(
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (this.page.value != page) this.page.value = page;
          },
          child: Container(
            height: 56,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconData,
                  size: size,
                  color: this.page.value == page
                      ? appTheme.color
                      : theme.textTheme.bodyText1.color,
                ),
                Padding(
                  padding: padding,
                  child: CircleAvatar(
                    radius: this.page.value == page ? 2 : 0,
                    backgroundColor: appTheme.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
