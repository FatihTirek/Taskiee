enum RepeatType { Days, Weeks, Months, Years }

enum DueFrom { Completion, OldDue }

class Repeat {
  final int amount;
  final DueFrom dueFrom;
  final List<int> weekDays;
  final RepeatType repeatType;

  const Repeat({
    this.amount,
    this.dueFrom,
    this.weekDays,
    this.repeatType,
  });

  static Repeat fromMap(Map map) {
    if (map != null) {
      final value = map['weekDays'];

      final amount = map['frequency'];
      final weekDays = value != null ? value.cast<int>() : null;
      final repeatType = RepeatType.values.elementAt(map['type']);
      final dueFrom = DueFrom.values.elementAt(map['dueFrom'] ?? 1);

      return Repeat(
        amount: amount,
        dueFrom: dueFrom,
        weekDays: weekDays,
        repeatType: repeatType,
      );
    }

    return null;
  }

  static Map<String, dynamic> toMap(Repeat repeat) {
    if (repeat != null) {
      final map = <String, dynamic>{};

      map['frequency'] = repeat.amount;
      map['weekDays'] = repeat.weekDays;
      map['dueFrom'] = repeat.dueFrom.index;
      map['type'] = repeat.repeatType.index;

      return map;
    }

    return null;
  }
}
