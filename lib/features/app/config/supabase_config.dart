import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    try {
      final url = dotenv.env['SUPABASE_URL'];
      final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (url == null || url.isEmpty) {
        throw Exception('[SupabaseConfig] Missing SUPABASE_URL in .env');
      }
      if (anonKey == null || anonKey.isEmpty) {
        throw Exception('[SupabaseConfig] Missing SUPABASE_ANON_KEY in .env');
      }

      await Supabase.initialize(url: url, anonKey: anonKey);
    } catch (e, stackTrace) {
      print('[SupabaseConfig] Initialization failed: $e');
      print('[SupabaseConfig] StackTrace: $stackTrace');
    }
  }

  static SupabaseClient get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      throw Exception('[SupabaseConfig] Supabase not initialized: $e');
    }
  }
}
