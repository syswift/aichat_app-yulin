// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ai_agent_config.dart';

class AIAgentService {
  final String baseUrl;

  AIAgentService({required this.baseUrl});

  // Get available textbooks from the server
  Future<List<TextbookConfig>> getAvailableTextbooks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/textbooks'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) => TextbookConfig(
                title: item['title'],
                id: item['id'],
                description: item['description'] ?? '',
              ),
            )
            .toList();
      } else {
        throw Exception('Failed to load textbooks');
      }
    } catch (e) {
      print('Error fetching textbooks: $e');
      return [];
    }
  }

  // Get LiveKit connection token
  Future<String> getLiveKitToken({
    required String userName,
    required String textbookId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getToken'),
        body: jsonEncode({'user_name': userName, 'textbook_id': textbookId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        throw Exception('Failed to get token: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting token: $e');
      rethrow;
    }
  }

  // Get LiveKit server URL
  Future<String> getLiveKitUrl() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/livekit-url'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      } else {
        throw Exception('Failed to get LiveKit URL');
      }
    } catch (e) {
      print('Error getting LiveKit URL: $e');
      rethrow;
    }
  }
}
