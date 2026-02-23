import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: 'https://YOUR_PROJECT_ID.supabase.co',
      anonKey: 'YOUR_ANON_KEY',
    );

    _initialized = true;
  }

  static SupabaseClient? get client {
    return Supabase.instance.client;
  }
}
