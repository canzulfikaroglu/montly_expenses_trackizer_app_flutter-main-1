import 'dart:convert';

import 'package:http/http.dart' as http;

const baseUrl =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBtSNCHNtX3ak_B8VgitW4_1YNq-6tYyRM";
final header = {
  "Content-Type": "application/json",
};
Future<String?> getGeminiData(String input) async {
  var message = {
    "contents": [
      {
        "parts": [
          {"text": "$input ."}
        ]
      }
    ]
  };
  try {
    final response = await http.post(Uri.parse(baseUrl),
        headers: header, body: jsonEncode(message));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var responseText =
          result["candidates"][0]["content"]["parts"][0]["text"].toString();
      return responseText;
    } else {
      return ("Request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    return ("Error: $e");
  }
}
