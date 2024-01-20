import 'package:uuid/uuid.dart';
import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:flutter/material.dart' show Color;
import 'package:taskiee/dialogs/sort_dialog.dart' show SortBy;

class Label with Utils {
  final String id;
  final int index;
  final String uid;
  final String name;
  final Color color;
  final SortBy sortBy;
  final bool ascending;
  final bool showCompleted;
  final DateTime creationDate;

  const Label({
    this.id,
    this.uid,
    this.name,
    this.color,
    this.index = 0,
    this.creationDate,
    this.ascending = true,
    this.showCompleted = true,
    this.sortBy = SortBy.None,
  });

  static Label fromMap(Map map) {
    final value = map['sortIndex'] != -1;

    final id = map['id'];
    final uid = map['uid'];
    final name = map['name'];
    final index = map['index'] ?? 0;
    final color = Color(map['color']);
    final showCompleted = map['showCompleted'] ?? true;
    final creationDate = DateTime.parse(map['creationDate']);
    final ascending = Utils.serializer(map['ascending']);
    final sortBy = SortBy.values.elementAt(value ? map['sortIndex'] : 4);

    return Label(
      id: id,
      uid: uid,
      name: name,
      index: index,
      color: color,
      sortBy: sortBy,
      ascending: ascending,
      creationDate: creationDate,
      showCompleted: showCompleted,
    );
  }

  static Map toMap(Label label) {
    final map = <String, dynamic>{};

    map['uid'] = userID;
    map['name'] = label.name;
    map['index'] = label.index;
    map['color'] = label.color.value;
    map['ascending'] = label.ascending;
    map['id'] = label.id ?? Uuid().v4();
    map['sortIndex'] = label.sortBy.index;
    map['showCompleted'] = label.showCompleted;
    map['creationDate'] = (label.creationDate ?? DateTime.now()).toString();

    return map;
  }

  Label copyWith({
    int index,
    String name,
    Color color,
    SortBy sortBy,
    bool ascending,
    bool showCompleted,
  }) {
    return Label(
      id: this.id,
      uid: this.uid,
      name: name ?? this.name,
      index: index ?? this.index,
      color: color ?? this.color,
      sortBy: sortBy ?? this.sortBy,
      creationDate: this.creationDate,
      ascending: ascending ?? this.ascending,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}
