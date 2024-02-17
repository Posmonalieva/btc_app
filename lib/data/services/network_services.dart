import 'dart:convert';

import 'package:btc_app/utils/constant_datas.dart';
import 'package:http/http.dart' as http;

class NetworkServices {
  static Future<Map<String, dynamic>> get(Uri uri) async {
    http.Response response = await http.get(
      uri,
      headers: {"X-CoinAPI-Key": ApiKeys.apiKey},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse;
    } else {
      return {};
    }
  }
}
