import 'package:taskiee/models/subtask.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/services/list_service.dart';
import 'package:taskiee/services/task_service.dart';

class SubTaskService extends Service {
  SubTaskService() : super('subTasks', SubTask.fromMap, SubTask.toMap);

  void migrateSLI() {
    final service = TaskService();

    read().forEach((e) {
      final task = service.getFromID(e.taskID);

      write(e.copyWith(listID: task.listID));
    });
  }

  List getFromTaskID(String taskID) =>
      read().where((e) => e.taskID == taskID).toList();

  @override
  List search(String keyword, List cache) {
    final bool Function(dynamic) test =
        (e) => e.body.toLowerCase().contains(keyword);
    return cache.where(test).toList();
  }

  @override
  void delete(String id, {bool includeSubtask, bool direct = false}) {
    final service = ListService();
    final function = (e) {
      super.delete(e.id);

      if (includeSubtask) {
        service.updateTotal(e.listID, decrease: true);

        if (e.completed) service.updateDone(e.listID);
      }
    };

    if (direct)
      function(getFromID(id));
    else
      read().where((e) => e.taskID == id).forEach((e) => function(e));
  }

  void onCheck(String id, bool value) {
    final service = TaskService();
    final subTask = getFromID(id);
    final task = service.getFromID(subTask.taskID);
    final result = subTask.copyWith(completed: value);

    write(result);
    service.write(task.copyWith(done: value ? task.done + 1 : task.done - 1));
  }
}
