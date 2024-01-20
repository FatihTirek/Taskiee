import 'package:taskiee/services/service.dart';
import 'package:taskiee/themes/app_theme.dart';

class ThemeService extends Service {
  ThemeService() : super('themeData', AppTheme.fromMap, AppTheme.toMap);

  @override
  List search(String keyword, List cache) => throw UnimplementedError();
}