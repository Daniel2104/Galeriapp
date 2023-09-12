import 'dart:convert';
import 'package:http/http.dart' as http;
import 'image_model.dart';

class UnsplashService {
  static const String apiUrl = 'https://api.unsplash.com';
  static const String apiKey =
      'nFrACNEik1DP3h0XWFMGaDDciXMp_Renopis3r-Agao'; // Reemplaza con tu API key de Unsplash
  static const int perPage = 20; // Número de imágenes por página

  Future<List<UnsplashImage>> getImages({int page = 1}) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/photos?client_id=$apiKey&page=$page&per_page=$perPage'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UnsplashImage.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las imágenes');
    }
  }

  Future<List<UnsplashImage>> searchImage(String query, int page) async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/search/photos?client_id=$apiKey&query=$query&page=$page&per_page=$perPage'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> data2 = data['results'];
      return data2.map((e) => UnsplashImage.fromJson(e)).toList();
      //return data
      //    .map((json) => UnsplashImage.fromJson(json['results']))
      //    .toList();
    } else {
      throw Exception('Error al cargar las imágenes');
    }
  }
}
