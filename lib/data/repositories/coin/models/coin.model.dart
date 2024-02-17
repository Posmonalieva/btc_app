class CoinModel {
  final String time;
  final String assetIdBase;
  final String assetIdQuote;
  final double rate;

  CoinModel({
    required this.time,
    required this.assetIdBase,
    required this.assetIdQuote,
    required this.rate,
  });

  CoinModel.fromJson(Map<String, dynamic> json)
      : time = json['time'] as String,
        assetIdBase = json['asset_id_base'],
        assetIdQuote = json['asset_id_quote'],
        rate = json['rate'] as double;

  Map<String, dynamic> toJson() => {
        'time': time,
        'asset_id_base': assetIdBase,
        'asset_id_quote': assetIdQuote,
        'rate': rate,
      };
}
