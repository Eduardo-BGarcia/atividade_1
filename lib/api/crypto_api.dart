import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class CryptoApi {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<CryptoModel>> fetchMarketCryptos() async {
    final url = Uri.parse(
      '$_baseUrl/coins/markets?vs_currency=brl&order=market_cap_desc&per_page=250&page=1&sparkline=false',
    );

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => CryptoModel.fromJson(item)).toList();
    } else {
      throw Exception(
        'Erro ao consumir API do CoinGecko: Status ${response.statusCode} - ${response.reasonPhrase}',
      );
    }
  }
}

