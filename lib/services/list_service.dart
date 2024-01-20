import 'package:taskiee/models/app_list.dart';
import 'package:taskiee/services/service.dart';
import 'package:taskiee/services/task_service.dart';

class ListService extends Service {
  ListService() : super('lists', AppList.fromMap, AppList.toMap);

  List getFromTasks(List tasks) {
    final uniqueIDS = tasks.map((e) => e.listID).toSet();
    final lists = uniqueIDS.map((e) => getFromID(e)).toList();

    lists.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return lists;
  }

  void updateTotal(String id, {bool decrease = false, int number}) {
    final value = number ?? 1;
    final appList = getFromID(id);
    final result = appList.copyWith(
        total: decrease ? appList.total - value : appList.total + value);

    write(result);
  }

  void updateDone(String id, {bool increase = false, int number}) {
    final value = number ?? 1;
    final appList = getFromID(id);
    final result = appList.copyWith(
        done: increase ? appList.done + value : appList.done - value);

    write(result);
  }

  @override
  List search(String keyword, List cache) {
    final bool Function(dynamic) test =
        (e) => e.name.toLowerCase().contains(keyword);
    return cache.where(test).toList();
  }

  @override
  void delete(String id, {bool includeSubtask}) {
    super.delete(id);
    TaskService().deleteFromListID(id, includeSubtask);
  }
}
