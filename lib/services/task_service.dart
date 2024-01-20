import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart';
import 'package:taskiee/models/task.dart';
import 'package:taskiee/pods/theme_pod.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/pods/animation_pod.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/label_service.dart';
import 'package:taskiee/services/subtask_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskService extends Service with Utils {
  TaskService() : super('tasks', Task.fromMap, Task.toMap);

  void migrateTSN() {
    final service = SubTaskService();

    read().forEach((e) {
      final subtasks = service.getFromTaskID(e.id);
      final done = subtasks.where((e) => e.completed).length;

      write(e.copyWith(total: subtasks.length, done: done));
    });
  }

  void createTask(BuildContext context, Task task) {
    task = context.read(themePod).appTheme.moveBottomNewTask
        ? task.copyWith(index: values().length)
        : task;

    write(task);
    scheduleNotification(context, task);
    ListService().updateTotal(task.listID);
    context.read(animationPod).add(task.id);
  }

  bool isAnyTask(
    List tasks,
    bool showCompleted,
    bool Function(dynamic e) test,
  ) {
    tasks = showCompleted ? tasks : tasks.where((e) => !e.completed).toList();

    return tasks.any(test);
  }

  List getAllDue() => read().where((e) => e.dueDate != null).toList();

  List getFromDue(DateTime dateTime, List cache, {bool showCompleted = true}) {
    final tasks = cache.where((e) => e.dueDate == dateTime);
    final result = showCompleted ? tasks : tasks.where((e) => !e.completed);

    return result.toList();
  }

  List getFromListID(String id, {bool omit = true}) =>
      read(omit: omit).where((e) => e.listID == id).toList();

  List getFromLabelID(String id) => LabelService().getTasksFromLabels([id]);

  void onChecked(BuildContext context, String id, bool value,
      {Task task, bool ignoreWrite = false}) {
    final appTheme = context.read(themePod).appTheme;
    task = task ?? getFromID(id);

    if (value)
      flutterLocalNotificationsPlugin.cancel(task.notificationID);
    else
      scheduleNotification(context, task.copyWith(completed: false));

    if (!appTheme.autoDelete)
      ListService().updateDone(task.listID, increase: value);

    if (task.repeat != null && !task.generated && value) {
      final service = SubTaskService();
      final subTasks = service.getFromTaskID(task.id);
      final dueDate = generateDate(task.dueDate, task.repeat);
      final reminder = task.reminder != null
          ? generateDate(task.reminder, task.repeat)
          : null;

      final newTask = task.copyWith(
        reminder: reminder,
        dueDate: dueDate,
        newTask: true,
      );

      if (subTasks.isNotEmpty) {
        final serviceList = ListService();

        subTasks.forEach((subtask) {
          service.write(subtask.copyWith(taskID: newTask.id, newSubTask: true));

          if (appTheme.includeSubtask) {
            serviceList.updateTotal(newTask.listID);

            if (subtask.completed)
              serviceList.updateDone(newTask.listID, increase: true);
          }
        });
      }

      if (!ignoreWrite && !appTheme.autoDelete)
        write(task.copyWith(completed: value, generated: true));

      createTask(context, newTask);
    } else {
      if (!ignoreWrite && !appTheme.autoDelete)
        write(task.copyWith(completed: value));
    }
  }

  void deleteFromListID(String id, bool includeSubtask) => getFromListID(id)
      .forEach((e) => delete(e.id, skip: true, includeSubtask: includeSubtask));

  void deleteCompleted(utilsPod, tasks, bool includeSubtask, {bool skip = false}) {
    final function =
        (items) => items.forEach((e) => delete(e.id, includeSubtask: includeSubtask));

    if (skip)
      function(tasks);
    else
      utilsPod.animate([tasks, function]);
  }

  void deleteCompletedForAutoDelete(bool includeSubtask) {
    read(omit: true).forEach((e) {
      if (e.completed) delete(e.id, includeSubtask: includeSubtask);
    });
  }

  @override
  List search(String keyword, List cache, {bool isNote = false}) {
    final bool Function(dynamic) test = isNote
        ? (e) => e.note != null && e.note.toLowerCase().contains(keyword)
        : (e) => e.body.toLowerCase().contains(keyword);

    return cache.where(test).toList();
  }

  @override
  void delete(String id, {bool includeSubtask, bool skip = false}) {
    final task = getFromID(id);
    final service = ListService();
    flutterLocalNotificationsPlugin.cancel(task.notificationID);

    super.delete(id);
    SubTaskService().delete(id, includeSubtask: includeSubtask);

    if (!skip) {
      service.updateTotal(task.listID, decrease: true);
      if (task.completed) service.updateDone(task.listID);
    }
  }

  void updateImportant(String id, bool important) {
    final task = getFromID(id);
    final result = task.copyWith(important: important);

    write(result);
  }

  void updateDueDate(String id, DateTime dueDate) {
    final task = getFromID(id);
    final result =
        dueDate == null ? task.copyWithNull() : task.copyWith(dueDate: dueDate);

    write(result);
  }

  void updateListID(String id, String listID, bool includeSubtask) {
    final serviceList = ListService();
    final serviceSubTask = SubTaskService();

    final task = getFromID(id);
    final result = task.copyWith(listID: listID);
    final subtasks = serviceSubTask.getFromTaskID(task.id);

    if (includeSubtask) {
      final length = subtasks.where((e) => e.completed).length;

      serviceList.updateTotal(listID, number: subtasks.length);
      serviceList.updateTotal(task.listID,
          decrease: true, number: subtasks.length);

      serviceList.updateDone(task.listID, number: length);
      serviceList.updateDone(listID, increase: true, number: length);
    }

    serviceList.updateTotal(result.listID);
    serviceList.updateTotal(task.listID, decrease: true);

    if (task.completed) {
      serviceList.updateDone(task.listID);
      serviceList.updateDone(result.listID, increase: true);
    }

    write(result);
    subtasks.forEach((e) => serviceSubTask.write(e.copyWith(listID: listID)));
  }
}
