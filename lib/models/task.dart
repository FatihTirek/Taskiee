import 'package:uuid/uuid.dart';
import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:taskiee/models/repeat.dart';
import 'package:taskiee/services/util_service.dart';

class Task with Utils {
  final int done;
  final int total;
  final String id;
  final int index;
  final String uid;
  final String body;
  final String note;
  final String link;
  final String listID;
  final List labelIDS;
  final Repeat repeat;
  final bool completed;
  final bool important;
  final bool generated;
  final DateTime dueDate;
  final DateTime reminder;
  final int notificationID;
  final DateTime creationDate;

  const Task({
    this.id,
    this.uid,
    this.body,
    this.note,
    this.link,
    this.listID,
    this.repeat,
    this.dueDate,
    this.reminder,
    this.done = 0,
    this.index = 0,
    this.total = 0,
    this.creationDate,
    this.notificationID,
    this.completed = false,
    this.important = false,
    this.generated = false,
    this.labelIDS = const [],
  });

  @override
  bool operator ==(Object other) {
    return (other is Task) &&
        other.id == id &&
        other.total == total &&
        other.done == done &&
        other.labelIDS == labelIDS &&
        other.index == index &&
        other.body == body &&
        other.note == note &&
        other.link == link &&
        other.listID == listID &&
        other.repeat == repeat &&
        other.completed == completed &&
        other.important == important &&
        other.dueDate == dueDate &&
        other.reminder == reminder;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      index.hashCode ^
      total.hashCode ^
      done.hashCode ^
      labelIDS.hashCode ^
      body.hashCode ^
      note.hashCode ^
      link.hashCode ^
      listID.hashCode ^
      repeat.hashCode ^
      completed.hashCode ^
      important.hashCode ^
      dueDate.hashCode ^
      reminder.hashCode;

  static Task fromMap(Map map) {
    final id = map['id'];
    final uid = map['uid'];
    final body = map['body'];
    final listID = map['listID'];
    final done = map['done'] ?? 0;
    final note = map['note'] ?? '';
    final link = map['link'] ?? '';
    final total = map['total'] ?? 0;
    final index = map['index'] ?? 0;
    final labelIDS = map['labelIDS'];
    final notificationID = map['notificationID'];
    final repeat = Repeat.fromMap(map['recurrence']);
    final dueDate = DateTime.tryParse(map['dueDate']);
    final reminder = DateTime.tryParse(map['reminder']);
    final completed = Utils.serializer(map['completed']);
    final important = Utils.serializer(map['important']);
    final generated = Utils.serializer(map['generated']);
    final creationDate = DateTime.parse(map['creationDate']);

    return Task(
      id: id,
      uid: uid,
      link: link,
      body: body,
      note: note,
      done: done,
      index: index,
      total: total,
      listID: listID,
      repeat: repeat,
      dueDate: dueDate,
      reminder: reminder,
      labelIDS: labelIDS,
      completed: completed,
      important: important,
      generated: generated,
      creationDate: creationDate,
      notificationID: notificationID,
    );
  }

  static Map toMap(Task task) {
    final map = <String, dynamic>{};

    map['id'] = task.id;
    map['uid'] = userID;
    map['body'] = task.body;
    map['done'] = task.done;
    map['total'] = task.total;
    map['index'] = task.index;
    map['listID'] = task.listID;
    map['note'] = task.note ?? '';
    map['link'] = task.link ?? '';
    map['labelIDS'] = task.labelIDS;
    map['completed'] = task.completed;
    map['important'] = task.important;
    map['generated'] = task.generated;
    map['dueDate'] = task.dueDate.toString();
    map['reminder'] = task.reminder.toString();
    map['notificationID'] = task.notificationID;
    map['recurrence'] = Repeat.toMap(task.repeat);
    map['creationDate'] = task.creationDate.toString();

    return map;
  }

  Task copyWith({
    int done,
    int total,
    int index,
    String body,
    String note,
    String link,
    String listID,
    List labelIDS,
    Repeat repeat,
    bool completed,
    bool important,
    bool generated,
    DateTime dueDate,
    DateTime reminder,
    int notificationID,
    bool newTask = false,
    bool getNID = false,
  }) {
    return Task(
      uid: this.uid,
      body: body ?? this.body,
      done: done ?? this.done,
      note: note ?? this.note,
      link: link ?? this.link,
      total: total ?? this.total,
      index: index ?? this.index,
      listID: listID ?? this.listID,
      repeat: repeat ?? this.repeat,
      dueDate: dueDate ?? this.dueDate,
      id: newTask ? Uuid().v4() : this.id,
      labelIDS: labelIDS ?? this.labelIDS,
      reminder: reminder ?? this.reminder,
      completed: completed ?? this.completed,
      important: important ?? this.important,
      generated: generated ?? this.generated,
      creationDate: newTask ? DateTime.now() : this.creationDate,
      notificationID: newTask || getNID
          ? UtilService.getValidNotificationID()
          : this.notificationID,
    );
  }

  Task copyWithNull() {
    return Task(
      id: this.id,
      uid: this.uid,
      dueDate: null,
      body: this.body,
      link: this.link,
      note: this.note,
      done: this.done,
      total: this.total,
      index: this.index,
      listID: this.listID,
      repeat: this.repeat,
      reminder: this.reminder,
      labelIDS: this.labelIDS,
      generated: this.generated,
      completed: this.completed,
      important: this.important,
      creationDate: this.creationDate,
      notificationID: this.notificationID,
    );
  }
}
