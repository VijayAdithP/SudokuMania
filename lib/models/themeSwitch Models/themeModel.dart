import 'package:hive_ce_flutter/hive_flutter.dart';

part 'themeModel.g.dart';

@HiveType(typeId: 50)
enum ThemePreference {
  @HiveField(0)
  light,

  @HiveField(1)
  dark,
}

