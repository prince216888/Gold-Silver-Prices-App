import 'dart:convert';
import 'package:http/http.dart' as http;

class  GoldAPI {
  static const String _apiKey = "goldapi-1awqn19m8t3nj3k-io"; // Replace with your actual GoldAPI key
  static const String _baseUrl = "https://www.goldapi.io/api";

  static Future<Map<String, dynamic>> fetchPrices() async {
    try {
      final goldResponse = await http.get(
        Uri.parse("$_baseUrl/XAU/INR"),
        headers: {"x-access-token": _apiKey, "Content-Type": "application/json"},
      );

      final silverResponse = await http.get(
        Uri.parse("$_baseUrl/XAG/INR"),
        headers: {"x-access-token": _apiKey, "Content-Type": "application/json"},
      );

      if (goldResponse.statusCode == 200 && silverResponse.statusCode == 200) {
        final goldData = jsonDecode(goldResponse.body);
        final silverData = jsonDecode(silverResponse.body);

        double goldPriceINR = goldData['price'];
        double silverPriceINR = silverData['price'];

        return {
          "gold": {
            "XAU": goldPriceINR,
            "1g": goldPriceINR / 31.1035,
            "10g": (goldPriceINR / 31.1035) * 10,
            "100g": (goldPriceINR / 31.1035) * 100,
            "1kg": (goldPriceINR / 31.1035) * 1000,
          },
          "silver": {
            "XAG": silverPriceINR,
            "1g": silverPriceINR / 31.1035,
            "10g": (silverPriceINR / 31.1035) * 10,
            "100g": (silverPriceINR / 31.1035) * 100,
            "1kg": (silverPriceINR / 31.1035) * 1000,
          }
        };
      } else {
        throw Exception("Failed to fetch prices");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
