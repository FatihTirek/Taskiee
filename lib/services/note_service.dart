import 'package:taskiee/models/note.dart';
import 'package:taskiee/services/service.dart';

class NoteService extends Service {
  NoteService() : super('Notes', Note.fromMap, Note.toMap);

  @override
  List search(String keyword, List cache) {
    final bool Function(dynamic) test =
        (e) => e.content.toLowerCase().contains(keyword);
    return cache.where(test).toList();
  }
}
