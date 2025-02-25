import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://reecurbemkhjmectdkyp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJlZWN1cmJlbWtoam1lY3Rka3lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU5NzEwMjEsImV4cCI6MjA1MTU0NzAyMX0.-u1TMMGBbJQ8_Eqk0Z4LzkA06OaTs7josfi8AAbX-Dw',
    );
  }

  static final SupabaseClient client = Supabase.instance.client;

  // Helper methods for common operations
  static Future<User?> getCurrentUser() async {
    return client.auth.currentUser;
  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static Future<String?> getUserRole() async {
    final user = client.auth.currentUser;
    if (user == null) return null;

    try {
      final data =
          await client
              .from('profiles')
              .select('role')
              .eq('id', user.id)
              .single();

      return data['role'] as String?;
    } catch (e) {
      print('获取用户角色失败: $e');
      return null;
    }
  }

  static Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await client.from('profiles').update({'role': newRole}).eq('id', userId);

      print('用户权限已修改为: $newRole');
      return true;
    } catch (e) {
      print('修改失败: $e');
      return false;
    }
  }
}
