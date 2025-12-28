import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/Book.dart';

class ApiService {
  // Возвращаем список объектов Book, а не сырой JSON
  static Future<List<Book>> fetchBooks() async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/books');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Декодируем utf8
        final List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
        return body.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }
}


