import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameSourceProvider = StateProvider<GameSource?>((ref) => null);

enum GameSource {
  calendar,
  normal,
}
