import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/task.dart';
import 'package:taskiee/i18n/localizations.dart';
import 'package:animations/animations.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/pickers/data_picker.dart';
import 'package:taskiee/services/task_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:taskiee/dialogs/delete_dialog.dart';
import 'package:taskiee/services/subtask_service.dart';

class UtilsPod extends ChangeNotifier with Utils {
  List _selectedData = [];

  bool _isShowing = false;
  bool _isAnimating = false;

  bool get isShowing => _isShowing;

  bool get isAnimating => _isAnimating;

  int get length => _selectedData.length;

  bool get isTaskOnly => _selectedData.every((e) => e is Task);

  set isShowing(bool value) {
    if (!value) _selectedData.clear();
    _isShowing = value;
    notifyListeners();
  }

  set isAnimating(bool value) {
    _isAnimating = value;
    notifyListeners();
  }

  bool contains(data) => _selectedData.map((e) => e.id).contains(data?.id);

  Future<void> animate(List params, {justAnimate = false}) async {
    _selectedData.addAll(params[0]);

    this.isAnimating = true;
    await Future.delayed(const Duration(milliseconds: 550));
    this.isAnimating = false;

    if (!justAnimate) params[1](params[0]);

    _selectedData.clear();
  }

  void onSelectAll(List items) {
    if (_selectedData.length == items.length) {
      _selectedData.clear();
    } else {
      _selectedData.clear();
      _selectedData.addAll(items);
    }

    notifyListeners();
  }

  void onSchedule(BuildContext context,
      {Color color, bool noDue = false}) async {
    final service = TaskService();

    if (noDue) {
      _selectedData.forEach((e) => service.updateDueDate(e.id, null));
      this.isShowing = false;
    } else {
      final date = await openDatePicker(
        context: context,
        color: color ?? context.read(themePod).appTheme.color,
      );

      if (date != null) {
        _selectedData.forEach((e) {
          if (e.dueDate != date) service.updateDueDate(e.id, date);
        });
        this.isShowing = false;
      }
    }
  }

  void onMark() {
    final service = TaskService();

    _selectedData.forEach((e) {
      if (!e.completed) service.updateImportant(e.id, true);
    });
    this.isShowing = false;
  }

  void onMove(BuildContext context, Color color) async {
    final service = TaskService();
    final list = await showModal(
      context: context,
      builder: (_) =>
          ListPicker(color: color ?? context.read(themePod).appTheme.color),
    );

    if (list != null) {
      _selectedData.forEach((e) {
        if (e.listID != list.id)
          service.updateListID(
              e.id, list.id, context.read(themePod).appTheme.includeSubtask);
      });
      this.isShowing = false;
    }
  }

  void onDelete(BuildContext context, Color color) async {
    final includeSubtask = context.read(themePod).appTheme.includeSubtask;

    showModal(
      context: context,
      builder: (_) => DeleteDialog(
        onPressed: () async {
          this.isAnimating = true;
          await Future.delayed(const Duration(milliseconds: 550));
          this.isAnimating = false;

          _selectedData.forEach((data) {
            if (data is Task)
              TaskService().delete(data.id, includeSubtask: includeSubtask);
            else
              SubTaskService().delete(data.id,
                  direct: true, includeSubtask: includeSubtask);
          });

          this.isShowing = false;
        },
        content: AppLocalizations.instance.w48,
        color: color ?? context.read(themePod).appTheme.color,
        title: AppLocalizations.instance.p6(_selectedData.length),
      ),
    );
  }

  void onTap(data) {
    if (data != null) {
      if (contains(data)) {
        _selectedData.removeWhere((e) => e.id == data.id);
        notifyListeners();
      } else {
        _selectedData.add(data);
        notifyListeners();
      }
    }
  }
}

final utilsPod = ChangeNotifierProvider((_) => UtilsPod());
