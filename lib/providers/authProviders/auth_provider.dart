import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the AuthState class to hold the user and authentication status
class AuthState {
  final User? user;
  final bool isSignedIn;

  AuthState({this.user, this.isSignedIn = false});

  AuthState copyWith({User? user, bool? isSignedIn}) {
    return AuthState(
      user: user ?? this.user,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}

// Create a StateNotifier to manage the authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  // Method to update the state when the user signs in
  void signIn(User user) {
    state = state.copyWith(user: user, isSignedIn: true);
  }

  // Method to update the state when the user signs out
  void signOut() {
    state = state.copyWith(user: null, isSignedIn: false);
  }
}

// Create a provider for the AuthNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
