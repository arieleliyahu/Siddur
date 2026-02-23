import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';

class PrayerRepository {
  final SupabaseClient? supabase;
  PrayerRepository(this.supabase);

  Future<String> loadPrayer(String fileName,
      {bool preferRemote = true}) async {
    if (preferRemote && supabase != null) {
      try {
        final storage = supabase!.storage.from('prayers');
        final Uint8List data = await storage.download(fileName);
        return const Utf8Decoder().convert(data);
      } catch (e) {
        print('Failed to load $fileName from Supabase: $e');
      }
    }

    return await rootBundle.loadString('assets/prayers/$fileName');
  }
}
