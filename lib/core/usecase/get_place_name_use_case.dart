import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class GetPlaceNameUseCase {
  final http.Client _client;

  const GetPlaceNameUseCase(this._client);

  Future<String> execute({required Position position}) async {
    final String googlePlaceApiKey = dotenv.env['GOOGLE_PLACE_API_KEY']!;

    final Uri uri =
        Uri.https('maps.googleapis.com', '/maps/api/place/textsearch/json', {
          'query': '${position.latitude}, ${position.longitude}',
          'key': googlePlaceApiKey,
        });

    try {
      http.Response response = await _client.get(uri);
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> resultsList = body['results'];
      Map<String, dynamic> firstResult = resultsList[0];
      return firstResult['name'];
    } catch (e) {
      rethrow;
    }
  }
}
