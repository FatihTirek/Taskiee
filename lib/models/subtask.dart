import 'package:uuid/uuid.dart';
import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';

class SubTask with Utils {
  final String id;
  final int index;
  final String uid;
  final String body;
  final String taskID;
  final String listID;
  final bool completed;
  final DateTime creationDate;

  const SubTask({
    this.id,
    this.uid,
    this.body,
    this.taskID,
    this.listID,
    this.index = 0,
    this.creationDate,
    this.completed = false,
  });

  @override
  bool operator ==(other) {
    return (other is SubTask) && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  static SubTask fromMap(Map map) {
    final id = map['id'];
    final uid = map['uid'];
    final body = map['body'];
    final taskID = map['taskID'];
    final listID = map['listID'];
    final index = map['index'] ?? 0;
    final completed = Utils.serializer(map['completed']);
    final creationDate = DateTime.parse(map['creationDate']);

    return SubTask(
      id: id,
      uid: uid,
      body: body,
      index: index,
      taskID: taskID,
      listID: listID,
      completed: completed,
      creationDate: creationDate,
    );
  }

  static Map<String, dynamic> toMap(SubTask subTask) {
    final map = <String, dynamic>{};

    map['uid'] = userID;
    map['body'] = subTask.body;
    map['index'] = subTask.index;
    map['taskID'] = subTask.taskID;
    map['listID'] = subTask.listID;
    map['completed'] = subTask.completed;
    map['id'] = subTask.id ?? Uuid().v4();
    map['creationDate'] = (subTask.creationDate ?? DateTime.now()).toString();

    return map;
  }

  SubTask copyWith({
    int index,
    String body,
    String taskID,
    String listID,
    bool completed,
    bool newSubTask = false,
  }) {
    return SubTask(
      uid: this.uid,
      body: body ?? this.body,
      index: index ?? this.index,
      taskID: taskID ?? this.taskID,
      listID: listID ?? this.listID,
      id: newSubTask ? Uuid().v4() : this.id,
      completed: completed ?? this.completed,
      creationDate: newSubTask ? DateTime.now() : this.creationDate,
    );
  }
}
