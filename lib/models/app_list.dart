import 'package:uuid/uuid.dart';
import 'package:taskiee/main.dart';
import 'package:taskiee/utils.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart' show Color, IconData;
import 'package:taskiee/dialogs/sort_dialog.dart' show SortBy;

class AppList with Utils {
  final int done;
  final String id;
  final int index;
  final int total;
  final String uid;
  final String name;
  final Color color;
  final SortBy sortBy;
  final bool ascending;
  final IconData iconData;
  final bool showCompleted;
  final DateTime creationDate;

  const AppList({
    this.id,
    this.uid,
    this.name,
    this.color,
    this.iconData,
    this.done = 0,
    this.total = 0,
    this.index = 0,
    this.creationDate,
    this.ascending = true,
    this.showCompleted = true,
    this.sortBy = SortBy.None,
  });

  static AppList fromMap(Map map) {
    final value = map['sortIndex'] != -1;

    final id = map['id'];
    final uid = map['uid'];
    final name = map['name'];
    final done = map['done'];
    final total = map['total'];
    final index = map['index'] ?? 0;
    final color = Color(map['color']);
    final iconData = LineIcon(map['iconData']).icon;
    final showCompleted = map['showCompleted'] ?? true;
    final creationDate = DateTime.parse(map['creationDate']);
    final ascending = Utils.serializer(map['ascending']);
    final sortBy = SortBy.values.elementAt(value ? map['sortIndex'] : 4);

    return AppList(
      id: id,
      uid: uid,
      name: name,
      done: done,
      index: index,
      total: total,
      color: color,
      sortBy: sortBy,
      iconData: iconData,
      ascending: ascending,
      creationDate: creationDate,
      showCompleted: showCompleted,
    );
  }

  static Map<String, dynamic> toMap(AppList list) {
    final map = <String, dynamic>{};

    map['uid'] = userID;
    map['name'] = list.name;
    map['done'] = list.done;
    map['index'] = list.index;
    map['total'] = list.total;
    map['color'] = list.color.value;
    map['ascending'] = list.ascending;
    map['id'] = list.id ?? Uuid().v4();
    map['sortIndex'] = list.sortBy.index;
    map['showCompleted'] = list.showCompleted;
    map['iconData'] = list.iconData.codePoint;
    map['creationDate'] = (list.creationDate ?? DateTime.now()).toString();

    return map;
  }

  AppList copyWith({
    int done,
    int total,
    int index,
    String name,
    Color color,
    SortBy sortBy,
    bool ascending,
    IconData iconData,
    bool showCompleted,
  }) {
    return AppList(
      id: this.id,
      uid: this.uid,
      name: name ?? this.name,
      done: done ?? this.done,
      index: index ?? this.index,
      total: total ?? this.total,
      color: color ?? this.color,
      sortBy: sortBy ?? this.sortBy,
      creationDate: this.creationDate,
      iconData: iconData ?? this.iconData,
      ascending: ascending ?? this.ascending,
      showCompleted: showCompleted ?? this.showCompleted,
    );
  }
}
