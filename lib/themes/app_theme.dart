import 'dart:io';

import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/themes/themes.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/themes/text_theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/theme_service.dart';

enum Language { English, Turkish }

enum ListIconSize { Normal, Big, Bigger }

enum FABShape { RRect, Hexagon, Circular }

enum SortBarType { Normal, ColoredBorder }

enum TaskDisplay { All, Short, Medium, Long }

enum DismissibleType { Colored, ColoredBorder }

enum RectShape { RRectS, RRectM, RRectL, BeveledRect }

enum LabelType { Normal, ColoredBorder, Colored, Faded, FCMixin }

enum ThemeType {
  ThemeV1,
  ThemeV2,
  ThemeV3,
  ThemeV4,
  ThemeV5,
  ThemeV6,
  ThemeV7,
  ThemeV9,
  ThemeV8,
}

enum Font {
  Roboto,
  Ubuntu,
  PtSans,
  Rubik,
  SourceSansPro,
  FiraSans,
  OpenSans,
  Righteous,
  WorkSans,
  Prompt,
  QuickSand,
  Kanit
}

enum SortType {
  AlphabeticAZ,
  AlphabeticZA,
  CreationNewest,
  CreationOldest,
  Custom,
}

class AppTheme with Utils {
  final Font font;
  final Color color;
  final bool lights;
  final bool vibration;
  final bool autoDelete;
  final String soundUri;
  final Language language;
  final FABShape fabShape;
  final bool strikeThrough;
  final bool includeSubtask;
  final bool showInCalendar;
  final ThemeType themeType;
  final RectShape listShape;
  final SortType listSortType;
  final bool moveBottomNewTask;
  final SortType labelSortType;
  final SortBarType sortBarType;
  final TaskDisplay taskDisplay;
  final bool moveBottomCompleted;
  final LabelType innerLabelType;
  final LabelType outerLabelType;
  final ListIconSize listIconSize;
  final RectShape outerLabelShape;
  final RectShape innerLabelShape;
  final bool darkenBottomBarColor;
  final DismissibleType dismissibleType;

  const AppTheme({
    this.language,
    this.soundUri,
    this.lights = true,
    this.vibration = true,
    this.autoDelete = false,
    this.font = Font.Roboto,
    this.strikeThrough = true,
    this.showInCalendar = true,
    this.includeSubtask = false,
    this.moveBottomNewTask = false,
    this.moveBottomCompleted = false,
    this.darkenBottomBarColor = false,
    this.listShape = RectShape.RRectS,
    this.fabShape = FABShape.Circular,
    this.themeType = ThemeType.ThemeV8,
    this.color = const Color(0xFF6200EA),
    this.taskDisplay = TaskDisplay.Medium,
    this.sortBarType = SortBarType.Normal,
    this.outerLabelType = LabelType.Normal,
    this.innerLabelType = LabelType.Colored,
    this.listIconSize = ListIconSize.Normal,
    this.outerLabelShape = RectShape.RRectS,
    this.innerLabelShape = RectShape.RRectS,
    this.listSortType = SortType.CreationNewest,
    this.labelSortType = SortType.CreationNewest,
    this.dismissibleType = DismissibleType.Colored,
  });

  static AppTheme fromMap(Map map) {
    final lights = Utils.serializer(map['lights']);
    final soundUri = map['soundUri'];
    final color = Color(map['color']);
    final vibration = Utils.serializer(map['vibration']);
    final autoDelete = map['autoDelete'] ?? false;
    final font = Font.values.elementAt(map['appFont']);
    final strikeThrough = map['strikeThrough'] ?? true;
    final showInCalendar = map['showInCalendar'] ?? true;
    final includeSubtask = map['includeSubtask'] ?? false;
    final moveBottomNewTask = map['moveBottomNewTask'] ?? false;
    final moveBottomCompleted = map['moveBottomCompleted'] ?? false;
    final darkenBottomBarColor = map['darkenBottomBarColor'] ?? false;
    final fabShape = FABShape.values.elementAt(map['fabShape']);
    final language = Language.values.elementAt(map['language']);
    final themeType = ThemeType.values.elementAt(map['themeType']);
    final listShape = RectShape.values.elementAt(map['listShape']);
    final sortBarType = SortBarType.values.elementAt(map['sortBarType']);
    final taskDisplay = TaskDisplay.values.elementAt(map['taskDisplay']);
    final listIconSize = ListIconSize.values.elementAt(map['listIconSize']);
    final outerLabelType = LabelType.values.elementAt(map['outerLabelType']);
    final innerLabelType = LabelType.values.elementAt(map['innerLabelType']);
    final outerLabelShape = RectShape.values.elementAt(map['outerLabelShape']);
    final innerLabelShape = RectShape.values.elementAt(map['innerLabelShape']);
    final dismissibleType =
        DismissibleType.values.elementAt(map['dismissibleType']);
    final listSortType = SortType.values
        .elementAt(map['listSortType'] ?? SortType.CreationNewest.index);
    final labelSortType = SortType.values
        .elementAt(map['labelSortType'] ?? SortType.CreationNewest.index);

    return AppTheme(
      font: font,
      color: color,
      lights: lights,
      fabShape: fabShape,
      language: language,
      soundUri: soundUri,
      vibration: vibration,
      listShape: listShape,
      themeType: themeType,
      autoDelete: autoDelete,
      sortBarType: sortBarType,
      taskDisplay: taskDisplay,
      listIconSize: listIconSize,
      listSortType: listSortType,
      strikeThrough: strikeThrough,
      labelSortType: labelSortType,
      includeSubtask: includeSubtask,
      showInCalendar: showInCalendar,
      outerLabelType: outerLabelType,
      innerLabelType: innerLabelType,
      outerLabelShape: outerLabelShape,
      innerLabelShape: innerLabelShape,
      dismissibleType: dismissibleType,
      moveBottomNewTask: moveBottomNewTask,
      moveBottomCompleted: moveBottomCompleted,
      darkenBottomBarColor: darkenBottomBarColor,
    );
  }

  static Map<String, dynamic> toMap(AppTheme appTheme) {
    final map = <String, dynamic>{};

    map['id'] = 'ThemeID';
    map['soundUri'] = appTheme.soundUri;
    map['color'] = appTheme.color.value;
    map['appFont'] = appTheme.font.index;
    map['autoDelete'] = appTheme.autoDelete;
    map['strikeThrough'] = appTheme.strikeThrough;
    map['showInCalendar'] = appTheme.showInCalendar;
    map['includeSubtask'] = appTheme.includeSubtask;
    map['lights'] = Utils.serializer(appTheme.lights);
    map['moveBottomNewTask'] = appTheme.moveBottomNewTask;
    map['vibration'] = Utils.serializer(appTheme.vibration);
    map['moveBottomCompleted'] = appTheme.moveBottomCompleted;
    map['darkenBottomBarColor'] = appTheme.darkenBottomBarColor;
    map['fabShape'] = appTheme.fabShape.index;
    map['language'] = appTheme.language.index;
    map['themeType'] = appTheme.themeType.index;
    map['listShape'] = appTheme.listShape.index;
    map['listSortType'] = appTheme.listSortType.index;
    map['sortBarType'] = appTheme.sortBarType.index;
    map['taskDisplay'] = appTheme.taskDisplay.index;
    map['labelSortType'] = appTheme.labelSortType.index;
    map['listIconSize'] = appTheme.listIconSize.index;
    map['outerLabelType'] = appTheme.outerLabelType.index;
    map['innerLabelType'] = appTheme.innerLabelType.index;
    map['outerLabelShape'] = appTheme.outerLabelShape.index;
    map['innerLabelShape'] = appTheme.innerLabelShape.index;
    map['dismissibleType'] = appTheme.dismissibleType.index;

    return map;
  }

  AppTheme copyWith({
    Font font,
    Color color,
    bool lights,
    bool vibration,
    bool autoDelete,
    String soundUri,
    FABShape fabShape,
    Language language,
    bool strikeThrough,
    bool showInCalendar,
    ThemeType themeType,
    RectShape listShape,
    bool includeSubtask,
    SortType listSortType,
    SortType labelSortType,
    bool moveBottomNewTask,
    SortBarType sortBarType,
    TaskDisplay taskDisplay,
    bool moveBottomCompleted,
    LabelType innerLabelType,
    LabelType outerLabelType,
    ListIconSize listIconSize,
    RectShape outerLabelShape,
    RectShape innerLabelShape,
    bool darkenBottomBarColor,
    DismissibleType dismissibleType,
  }) {
    return AppTheme(
      font: font ?? this.font,
      color: color ?? this.color,
      lights: lights ?? this.lights,
      fabShape: fabShape ?? this.fabShape,
      language: language ?? this.language,
      soundUri: soundUri ?? this.soundUri,
      vibration: vibration ?? this.vibration,
      listShape: listShape ?? this.listShape,
      themeType: themeType ?? this.themeType,
      autoDelete: autoDelete ?? this.autoDelete,
      sortBarType: sortBarType ?? this.sortBarType,
      taskDisplay: taskDisplay ?? this.taskDisplay,
      listIconSize: listIconSize ?? this.listIconSize,
      listSortType: listSortType ?? this.listSortType,
      strikeThrough: strikeThrough ?? this.strikeThrough,
      labelSortType: labelSortType ?? this.labelSortType,
      includeSubtask: includeSubtask ?? this.includeSubtask,
      showInCalendar: showInCalendar ?? this.showInCalendar,
      outerLabelType: outerLabelType ?? this.outerLabelType,
      innerLabelType: innerLabelType ?? this.innerLabelType,
      outerLabelShape: outerLabelShape ?? this.outerLabelShape,
      innerLabelShape: innerLabelShape ?? this.innerLabelShape,
      dismissibleType: dismissibleType ?? this.dismissibleType,
      moveBottomNewTask: moveBottomNewTask ?? this.moveBottomNewTask,
      moveBottomCompleted: moveBottomCompleted ?? this.moveBottomCompleted,
      darkenBottomBarColor: darkenBottomBarColor ?? this.darkenBottomBarColor,
    );
  }

  static AppTheme _internal() {
    final locales = AppLocalizationsDelegate.locales;
    final systemLocale = Platform.localeName.substring(0, 2);
    final languageCode = locales.firstWhere(
      (e) => e == systemLocale,
      orElse: () => AppLocalizationsDelegate.defaultLocale,
    );
    final language = Language.values[locales.indexOf(languageCode)];

    return AppTheme().copyWith(language: language);
  }

  static AppTheme getAppTheme() {
    final appThemeData = ThemeService().read();

    if (appThemeData.isEmpty)
      return _internal();
    else
      return appThemeData.first;
  }

  // ignore: missing_return
  static ThemeData getThemeData(BuildContext context, {ThemeType themeType}) {
    final pod = context.read(themePod);
    final appTextTheme = AppTextTheme(pod.appTheme.font);

    switch (themeType ?? pod.appTheme.themeType) {
      case ThemeType.ThemeV1:
        return appTextTheme.finalizeTheme(themeV1);
      case ThemeType.ThemeV2:
        return appTextTheme.finalizeTheme(themeV2);
      case ThemeType.ThemeV3:
        return appTextTheme.finalizeTheme(themeV3);
      case ThemeType.ThemeV4:
        return appTextTheme.finalizeTheme(themeV4);
      case ThemeType.ThemeV5:
        return appTextTheme.finalizeTheme(themeV5);
      case ThemeType.ThemeV6:
        return appTextTheme.finalizeTheme(themeV6);
      case ThemeType.ThemeV7:
        return appTextTheme.finalizeTheme(themeV7);
      case ThemeType.ThemeV8:
        return appTextTheme.finalizeTheme(themeV8);
      case ThemeType.ThemeV9:
        return appTextTheme.finalizeTheme(themeV9);
    }
  }

  // ignore: missing_return
  static String getLanguage(Language language) {
    switch (language) {
      case Language.Turkish:
        return 'Türkçe';
      case Language.English:
        return 'English';
    }
  }
}
