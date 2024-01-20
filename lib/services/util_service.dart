import 'dart:math';

import 'package:hive/hive.dart';
import 'package:taskiee/services/subtask_service.dart';
import 'package:taskiee/services/task_service.dart';

class UtilService {
  static const _table = 'Utils';

  static Future initialize() async => await Hive.openBox(_table);

  static int getValidNotificationID() {
    final box = Hive.box(_table);
    final newNotificationID = box.get('key', defaultValue: 0) + 1;

    if (newNotificationID == pow(2, 31) - 2) {
      box.put('key', 0);
      return 0;
    }

    box.put('key', newNotificationID);
    return newNotificationID;
  }

  static void markAsOldUser() {
    final box = Hive.box(_table);

    if (box.get('oldUser') == null) box.put('oldUser', true);
  }

  static void migrateOldData() {
    final box = Hive.box(_table);
    final migratedTSN = box.get('migratedTSN', defaultValue: false);
    final migratedSLI = box.get('migratedSLI', defaultValue: false);

    if (!migratedTSN) {
      TaskService().migrateTSN();
      box.put('migratedTSN', true);
    }

    if (!migratedSLI) {
      SubTaskService().migrateSLI();
      box.put('migratedSLI', true);
    }
  }
}
