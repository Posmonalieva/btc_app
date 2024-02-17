import 'package:btc_app/data/repositories/coin/models/coin.model.dart';
import 'package:btc_app/data/services/coin_api_srvs.dart';

class CoinRepository {
  final CoinApiSrvs _coinApiSrvs = CoinApiSrvs();
  Future<CoinModel> getCurrencyRate(String currency) async {
    return _coinApiSrvs.getCurrencyRate(currency);
  }
}
