import 'dart:convert';
import 'package:http/http.dart' as http;

String url = "https://rest.coinapi.io/v1/exchangerate";
String apiKey = 'ACB85053-F12A-4C95-A402-A47F49709F1B';

class CoinApiSrvs {
  Future<Map<String, dynamic>> getCurrencyRate(String currency) async {
    var uri = Uri.parse('$url/BTC/$currency');

    http.Response response = await http.get(
      uri,
      headers: {
        "X-CoinAPI-Key": apiKey // Replace with your API key
      },
    );

    /// fiber optic cabel
    // await http.post(uri);
    // await http.put(uri);
    // await http.delete(uri);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          jsonDecode(response.body) as Map<String, dynamic>;

      return jsonResponse;
    } else {
      return {};
    }
  }
}

/// Http Request
/// CRUD
/// C - Create
/// R - Read
/// U - Update
/// D - Delete