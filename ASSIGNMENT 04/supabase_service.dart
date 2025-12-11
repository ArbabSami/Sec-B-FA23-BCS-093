import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';

  static Future<void> initialize() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
a
  static final client = Supabase.instance.client;

  static Future<List<dynamic>> getSubmissions() async {
    final response = await client.from('submissions').select();
    return response;
  }

  static Future<void> insertSubmission(Map<String, dynamic> data) async {
    await client.from('submissions').insert(data);
  }

  static Future<void> updateSubmission(int id, Map<String, dynamic> data) async {
    await client.from('submissions').update(data).eq('id', id);
  }

  static Future<void> deleteSubmission(int id) async {
    await client.from('submissions').delete().eq('id', id);
  }
}
