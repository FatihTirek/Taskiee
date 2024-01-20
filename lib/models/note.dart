import 'package:uuid/uuid.dart';
import 'package:taskiee/main.dart';

class Note {
  final String id;
  final String uid;
  final bool pinned;
  final String content;
  final DateTime reminder;
  final int notificationID;
  final DateTime creationDate;

  const Note({
    this.id,
    this.uid,
    this.pinned,
    this.content,
    this.reminder,
    this.creationDate,
    this.notificationID,
  });

  static Note fromMap(Map map) {
    final id = map['id'];
    final uid = map['uid'];
    final pinned = map['pinned'];
    final content = map['content'];
    final notificationID = map['notificationID'];
    final reminder = DateTime.tryParse(map['reminder']);
    final creationDate = DateTime.parse(map['creationDate']);

    return Note(
      id: id,
      uid: uid,
      pinned: pinned,
      content: content,
      reminder: reminder,
      creationDate: creationDate,
      notificationID: notificationID,
    );
  }

  static Map toMap(Note note) {
    final map = <String, dynamic>{};

    map['uid'] = userID;
    map['pinned'] = note.pinned;
    map['content'] = note.content;
    map['id'] = note.id ?? Uuid().v4();
    map['reminder'] = note.reminder.toString();
    map['notificationID'] = note.notificationID;
    map['creationDate'] = (note.creationDate ?? DateTime.now()).toString();

    return map;
  }

  Note copyWith({
    String id,
    bool pinned,
    String content,
    DateTime reminder,
    int notificationID,
    DateTime creationDate,
    bool acceptNull = false,
  }) {
    return Note(
      uid: this.uid,
      id: id ?? this.id,
      pinned: pinned ?? this.pinned,
      content: content ?? this.content,
      creationDate: creationDate ?? this.creationDate,
      notificationID: notificationID ?? this.notificationID,
      reminder: acceptNull ? reminder : reminder ?? this.reminder,
    );
  }
}
