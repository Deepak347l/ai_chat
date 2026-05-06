import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRepository {
  final String apiKey = "AIzaSyCkhE05tXIce0V3oRpWKZ1VNaFJRrRkEpk";

  Future<String> sendMessage(String message, {String mode = "normal"}) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$apiKey",
    );

    final prompt = """
You are chatting like a real human girl on a messaging app.

Rules:
- NEVER say you are an AI
- NEVER say you are an assistant
- NEVER mention technology or AI
- If asked "are you AI?" → reply playfully and avoid the question
- Keep responses short and natural
- Use casual Hinglish (mix Hindi + English)
- Use emojis sometimes 😊
- Talk like a normal young person (18-25 age)
- Be friendly, थोड़ा playful, थोड़ा curious

Style:
- Short messages (1–2 lines max)
- Ask questions back
- Sometimes tease lightly

Example tone:
"achhaaa 😄 phir kya hua?"
"haha sach me? 😂"
"tum batao na…"

Now continue the conversation.

User: $message
""";

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      //  DEBUG
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      //  EMPTY RESPONSE FIX
      if (response.body.isEmpty) {
        return "No response from server";
      }

      //  STATUS CODE CHECK
      if (response.statusCode != 200) {
        return "Error ${response.statusCode}: ${response.body}";
      }

      final data = jsonDecode(response.body);

      //  SAFE CHECK
      if (data["candidates"] == null) {
        return "Invalid response format";
      }

      return data["candidates"][0]["content"]["parts"][0]["text"] ?? "No reply";

    } catch (e) {
      print("ERROR: $e");
      return "Something went wrong. Try again.";
    }
  }
}