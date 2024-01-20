import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class Service {
  final String table;
  final Function _toMap;
  final Function _fromMap;

  Service(this.table, this._fromMap, this._toMap);

  // final db = FirebaseFirestore.instance;

  Future clear() => Hive.box(table).clear();

  List values() => Hive.box(table).values.toList();

  Future initialize() async => await Hive.openBox(table);

  ValueListenable get listenable => Hive.box(table).listenable();

  // Query get query => db.collection(table).where('uid', isEqualTo: userID);

  ValueListenable listen(String id) => Hive.box(table).listenable(keys: [id]);

  List read({bool omit = true}) {
    final items = Hive.box(table).values.map((e) => _fromMap(e)).toList();

    if (omit)
      return items;
    else
      return items..sort((a, b) => b.creationDate.compareTo(a.creationDate));
  }

  // void write(dynamic data) {
  //   final item = data is Map ? data : _toMap(data);
  //   db.collection(table).doc(item['id']).set(item);
  // }

  // void writeToHive(dynamic data) {
  //   final item = data is Map ? data : _toMap(data);
  //   Hive.box(table).put(item['id'], item);
  // }

  // void delete(String id) => db.collection(table).doc(id).delete();

  void write(dynamic data) {
    final item = data is Map ? data : _toMap(data);
    Hive.box(table).put(item['id'], item);
  }

  void delete(String id) => Hive.box(table).delete(id);

  List search(String keyword, List cache);

  dynamic getFromID(String id) {
    final item = Hive.box(table).get(id);
    final result = item != null ? _fromMap(item) : [];

    return result;
  }

  void updateShowCompleted(String id, bool showCompleted) {
    final item = getFromID(id);
    final result = item.copyWith(showCompleted: showCompleted);

    write(result);
  }
}
