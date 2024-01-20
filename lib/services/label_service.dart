import 'package:taskiee/models/label.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/services/task_service.dart';

class LabelService extends Service {
  LabelService() : super('labels', Label.fromMap, Label.toMap);

  List getLabels(List labelIDS) => labelIDS.map((e) => getFromID(e)).toList();

  List getTasksFromLabels(List labelIDS, {bool showCompleted = true}) {
    final service = TaskService();

    if (labelIDS.isNotEmpty) {
      final tasks = service.read().where((e) => e.labelIDS.toSet().containsAll(labelIDS));
      final result = showCompleted ? tasks : tasks.where((e) => !e.completed);

      return result.toList();
    }

    return [];
  }

  @override
  List search(String keyword, List cache) {
    final bool Function(dynamic) test =
        (e) => e.name.toLowerCase().contains(keyword);
    return cache.where(test).toList();
  }

  @override
  void delete(String id) {
    final service = TaskService();
    final tasks = getTasksFromLabels([id]);

    super.delete(id);
    tasks.forEach((task) {
      service.write(task.copyWith(labelIDS: task.labelIDS..remove(id)));
    });
  }
}
