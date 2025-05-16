import 'dart:convert';

import 'package:http/http.dart' as http;

class PushService {
  static final PushService _pushService = PushService._internal();

  factory PushService() {
    return _pushService;
  }

  PushService._internal();

  final String _baseUrl =
      'https://us-central1-survival-photopin.cloudfunctions.net';

  Future<bool> sendPush({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'title': title, 'body': body}),
      );

      if (response.statusCode == 200) return true;
      print('PushService 실패: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      print('PushService 오류: $e');
      return false;
    }
  }
}
