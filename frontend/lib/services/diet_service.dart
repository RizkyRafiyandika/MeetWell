import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitness2/models/popular_model.dart';

class DietService {
  // Ganti dengan IP address lokal laptop kamu (pastikan HP dan laptop satu WiFi)
  static const String _baseUrl = 'http://192.168.100.15:4000';

  // Fetch data dari API (khusus untuk physical device)
  Future<List<PopularDietsModel>> fetchPopularDiets() async {
    final url = Uri.parse('$_baseUrl/api/popular-diets');
    print('📡 Fetching from: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => PopularDietsModel.fromJson(item)).toList();
      } else {
        print("❌ Error fetching popular diets: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Exception occurred: $e");
      return [];
    }
  }
}
