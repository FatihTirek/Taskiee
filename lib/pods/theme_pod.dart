import 'package:taskiee/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/themes/app_theme.dart';
import 'package:taskiee/pickers/color_picker.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/theme_service.dart';
import 'package:taskiee/services/subtask_service.dart';

class ThemePod extends ChangeNotifier with Utils {
  AppTheme _appTheme;

  ThemePod(this._appTheme);

  AppTheme get appTheme => _appTheme;

  final service = ThemeService();

  void setLanguage(Language language) {
    if (language != _appTheme.language) {
      final appTheme = _appTheme.copyWith(language: language);

      _runOperation(appTheme);
    }
  }

  void setSoundUri(String soundUri) {
    if (soundUri != _appTheme.soundUri) {
      final appTheme = _appTheme.copyWith(soundUri: soundUri);

      _runOperation(appTheme);
    }
  }

  void setLights(bool lights) {
    if (lights != _appTheme.lights) {
      final appTheme = _appTheme.copyWith(lights: lights);

      _runOperation(appTheme);
    }
  }

  void setVibration(bool vibration) {
    if (vibration != _appTheme.vibration) {
      final appTheme = _appTheme.copyWith(vibration: vibration);

      _runOperation(appTheme);
    }
  }

  void setFont(BuildContext context, Font font) {
    if (font != _appTheme.font) {
      final appTheme = _appTheme.copyWith(font: font);

      _runOperation(appTheme);
      Navigator.pop(context);
    }
  }

  void setTheme(BuildContext context, ThemeType themeType) {
    if (themeType != _appTheme.themeType) {
      final appTheme = _appTheme.copyWith(themeType: themeType);
      SystemChrome.setSystemUIOverlayStyle(
          getUIStyle(context, themeType: themeType));

      _runOperation(appTheme);
      Navigator.pop(context);
    }
  }

  void setColor(BuildContext context) async {
    final color = await showModal(
      context: context,
      builder: (_) => ColorPicker(color: appTheme.color),
    );

    if (color != null && color.value != _appTheme.color.value) {
      final appTheme = _appTheme.copyWith(color: color);

      _runOperation(appTheme);
    }
  }

  void setListSortType(SortType sortType) {
    if (sortType != _appTheme.listSortType) {
      final appTheme = _appTheme.copyWith(listSortType: sortType);

      _runOperation(appTheme);
    }
  }

  void setLabelSortType(SortType sortType) {
    if (sortType != _appTheme.labelSortType) {
      final appTheme = _appTheme.copyWith(labelSortType: sortType);

      _runOperation(appTheme);
    }
  }

  void setButtonShape(BuildContext context, FABShape fabShape) {
    if (fabShape != _appTheme.fabShape) {
      final appTheme = _appTheme.copyWith(fabShape: fabShape);

      _runOperation(appTheme);
      Navigator.pop(context);
    }
  }

  void setListShape(BuildContext context, RectShape rectShape) {
    if (rectShape != _appTheme.listShape) {
      final appTheme = _appTheme.copyWith(listShape: rectShape);

      _runOperation(appTheme);
      Navigator.pop(context);
    }
  }

  void setLabelShape(BuildContext context, RectShape rectShape,
      {bool task = false}) {
    if (task) {
      if (rectShape != _appTheme.innerLabelShape) {
        final appTheme = _appTheme.copyWith(innerLabelShape: rectShape);

        _runOperation(appTheme);
      }
    } else {
      if (rectShape != _appTheme.outerLabelShape) {
        final appTheme = _appTheme.copyWith(outerLabelShape: rectShape);

        _runOperation(appTheme);
      }
    }
    Navigator.pop(context);
  }

  void setLabelType(BuildContext context, LabelType labelType,
      {bool task = false}) {
    if (task) {
      if (labelType != _appTheme.innerLabelType) {
        final appTheme = _appTheme.copyWith(innerLabelType: labelType);

        _runOperation(appTheme);
      }
    } else {
      if (labelType != _appTheme.outerLabelType) {
        final appTheme = _appTheme.copyWith(outerLabelType: labelType);

        _runOperation(appTheme);
      }
    }
    Navigator.pop(context);
  }

  void setListIconSize(ListIconSize listIconSize) {
    if (listIconSize != _appTheme.listIconSize) {
      final appTheme = _appTheme.copyWith(listIconSize: listIconSize);

      _runOperation(appTheme);
    }
  }

  void setTaskDisplay(TaskDisplay taskDisplay) {
    if (taskDisplay != _appTheme.taskDisplay) {
      final appTheme = _appTheme.copyWith(taskDisplay: taskDisplay);

      _runOperation(appTheme);
    }
  }

  void setSortBarType(SortBarType sortBarType) {
    if (sortBarType != _appTheme.sortBarType) {
      final appTheme = _appTheme.copyWith(sortBarType: sortBarType);

      _runOperation(appTheme);
    }
  }

  void setDismissibleType(DismissibleType dismissibleType) {
    if (dismissibleType != _appTheme.dismissibleType) {
      final appTheme = _appTheme.copyWith(dismissibleType: dismissibleType);

      _runOperation(appTheme);
    }
  }

  void setStrikeThrough(bool strikeThrough) {
    final appTheme = _appTheme.copyWith(strikeThrough: strikeThrough);

    _runOperation(appTheme);
  }

  void setAutoDelete(bool autoDelete) {
    if (autoDelete)
      TaskService().deleteCompletedForAutoDelete(_appTheme.includeSubtask);

    final appTheme = _appTheme.copyWith(autoDelete: autoDelete);

    _runOperation(appTheme);
  }

  void setShowInCalendar(bool showInCalendar) {
    final appTheme = _appTheme.copyWith(showInCalendar: showInCalendar);

    _runOperation(appTheme);
  }

  void setMoveBottomNewTask(bool moveBottomNewTask) {
    final appTheme = _appTheme.copyWith(moveBottomNewTask: moveBottomNewTask);

    _runOperation(appTheme);
  }

  void setMoveBottomCompleted(bool moveBottomCompleted) {
    final appTheme =
        _appTheme.copyWith(moveBottomCompleted: moveBottomCompleted);

    _runOperation(appTheme);
  }

  void setDarkenBottomBarColor(bool darkenBottomBarColor) {
    final appTheme =
        _appTheme.copyWith(darkenBottomBarColor: darkenBottomBarColor);

    _runOperation(appTheme);
  }

  void setIncludeSubTask(bool includeSubtask) {
    final serviceList = ListService();

    print(SubTaskService().read());

    SubTaskService().read().forEach((subtask) {
      serviceList.updateTotal(subtask.listID, decrease: !includeSubtask);

      if (subtask.completed)
        serviceList.updateDone(subtask.listID, increase: includeSubtask);
    });

    final appTheme = _appTheme.copyWith(includeSubtask: includeSubtask);

    _runOperation(appTheme);
  }

  void _runOperation(AppTheme appTheme) {
    service.write(appTheme);
    _appTheme = appTheme;
    notifyListeners();
  }
}

final themePod =
    ChangeNotifierProvider((_) => ThemePod(AppTheme.getAppTheme()));
