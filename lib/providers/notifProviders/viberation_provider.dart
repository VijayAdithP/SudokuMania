import 'package:flutter_riverpod/flutter_riverpod.dart';

class VibeNotifier extends StateNotifier<bool> {
  VibeNotifier() : super(true);

  // Method to update the state when the user signs in
  void turnOffVibe() {
    state = false;
  }

  // Method to update the state when the user signs out
  void turnOnVibe() {
    state = true;
  }
}

// Create a provider for the AuthNotifier
final vibeProvider = StateNotifierProvider<VibeNotifier, bool>((ref) {
  return VibeNotifier();
});
