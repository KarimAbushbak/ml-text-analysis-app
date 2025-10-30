import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sentiment_app/sentiment_model.dart';

class SentimentService {
  // Automatically detect the correct base URL based on platform
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android emulator uses 10.0.2.2 to access host localhost
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // iOS simulator can use localhost
      return 'http://localhost:8000';
    } else {
      // Desktop platforms
      return 'http://localhost:8000';
    }
  }
  
  static Future<SentimentResponse> analyzeSentiment(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SentimentResponse.fromJson(data);
      } else {
        throw Exception('Failed to analyze sentiment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to sentiment analysis service: $e');
    }
  }


}

