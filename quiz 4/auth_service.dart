import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    final res = await client.auth.signUp(email: email, password: password);
    return res;
  }

  Future<GotrueSessionResponse> signIn(String email, String password) async {
    final res = await client.auth.signInWithPassword(email: email, password: password);
    return res;
  }

  User? currentUser() {
    return client.auth.currentUser;
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
