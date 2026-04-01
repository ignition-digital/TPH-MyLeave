import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState {
  final User? user;
  final String? error;
  final bool isLoading;

  AuthState({
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    User? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseClient client = Supabase.instance.client;

  AuthNotifier() : super(AuthState()) {
    _init();
  }

  void _init() {
    final session = client.auth.currentSession;

    if (session != null) {
      state = state.copyWith(user: session.user);
    }

    client.auth.onAuthStateChange.listen((data) {
      state = state.copyWith(user: data.session?.user);
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final res = await client.auth.signUp(
        email: email,
        password: password,
      );

      if (res.user == null) {
        state = state.copyWith(
          error: "Signup failed. Try again later.",
          isLoading: false,
        );
        return;
      }

      state = state.copyWith(user: res.user, isLoading: false);

    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: "Unexpected error occurred",
        isLoading: false,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final res = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(user: res.user, isLoading: false);

    } on AuthException catch (e) {
      state = state.copyWith(error: e.message, isLoading: false);
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
    state = AuthState();
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});