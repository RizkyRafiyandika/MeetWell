import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fitness2/models/popular_model.dart';

class DietService {
  // Pilih URL yang sesuai dengan platform
  static final String _baseUrl =
      kIsWeb ? 'http://localhost:4000' : 'http://10.0.2.2:4000';

  // Fetch Popular Diets
  Future<List<PopularDietsModel>> fetchPopularDiets() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/popular-diets'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => PopularDietsModel.fromJson(item)).toList();
      } else {
        print("Error fetching popular diets: ${response.statusCode}");
        throw Exception('Failed to fetch popular diets');
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  // Fetch Categories
  // static Future<List<CategoryModel>> fetchCategories() async {
  //   try {
  //     final response = await http.get(Uri.parse('$_baseUrl/api/categories'));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> jsonData = json.decode(response.body);
  //       return jsonData.map((item) => CategoryModel.fromJson(item)).toList();
  //     } else {
  //       print("Error: Status Code ${response.statusCode}");
  //       throw Exception('Gagal mengambil kategori dari API');
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     return [];
  //   }
  // }
}
