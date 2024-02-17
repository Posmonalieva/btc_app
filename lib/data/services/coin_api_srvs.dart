import 'package:btc_app/data/repositories/coin/models/coin.model.dart';
import 'package:btc_app/data/services/network_services.dart';
import 'package:btc_app/utils/constant_datas.dart';

class CoinApiSrvs {
  Future<CoinModel> getCurrencyRate(String currency) async {
    final uri = Uri.parse('${ApiKeys.url}/BTC/$currency');

    final data = await NetworkServices.get(uri);

    final CoinModel coinModel = CoinModel.fromJson(data);

    return coinModel;
  }
}
