import 'dart:convert';
import 'package:http/http.dart' as http;

class ZmanimService {
  static Future<Map<String, dynamic>> getZmanim({
    required double latitude,
    required double longitude,
  }) async {
    final today = DateTime.now();
    final date =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final url = Uri.parse(
      'https://www.hebcal.com/zmanim?cfg=json'
      '&latitude=$latitude'
      '&longitude=$longitude'
      '&tzid=Asia/Jerusalem'
      '&date=$date',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load zmanim");
    }
  }
}