import 'dart:developer';
import 'dart:io' show Platform;
import 'package:btc_app/constant_datas.dart';
import 'package:btc_app/coin_api_srvs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({super.key});

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  final double _btcValue = 1;
  double _fiatMoneyValue = 0;

  String dropdownValue = currencyList.first;

  int _selectedItemIndex = (currencyList.length / 2).round();

  @override
  void didChangeDependencies() async {
    await getCurrencyRate(currencyList[_selectedItemIndex]);
    super.didChangeDependencies();
  }

  Future<void> getCurrencyRate(String currency) async {
    final response = await CoinApiSrvs().getCurrencyRate(currency);
    log('response: $response');

    _fiatMoneyValue = (response['rate'] as double).roundToDouble();
    log('_fiatMoneyValue: $_fiatMoneyValue');

    setState(() {});
  }

  Widget buildItemsForiOS() {
    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      // This sets the initial item.
      scrollController: FixedExtentScrollController(
        initialItem: _selectedItemIndex,
      ),
      // This is called when selected item is changed.
      onSelectedItemChanged: (int selectedItem) async {
        await getCurrencyRate(currencyList[_selectedItemIndex]);

        setState(() {
          _selectedItemIndex = selectedItem;
        });
      },
      children: currencyList
          .map<Widget>(
            (currency) => Center(
              child: Text(
                currency,
              ),
            ),
          )
          .toList(),

      /// 3-variant List тин озундо generate деген function бар экен !!!
      //   List<Widget>.generate(currencyList.length, (int index) {
      //     return Center(
      //       child: Text(
      //         currencyList[index],
      //       ),
      //     );
      //   }),
    );
  }

  /// 2-chi jolu  !!!!
  // List<DropdownMenuItem<String>> tizmeniAylanipOzgort() {
  //   return currencyList.map<DropdownMenuItem<String>>(
  //     (String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(
  //           value,
  //           style: const TextStyle(color: Colors.black),
  //         ),
  //       );
  //     },
  //   ).toList();
  // }

  Widget buildItemsForAndroid() {
    ///1- variant
    List<DropdownMenuItem<String>> items = [];
    for (var currency in currencyList) {
      final dropdownMenuItem = DropdownMenuItem<String>(
        value: currency,
        child: Text(
          currency,
          style: const TextStyle(color: Colors.black),
        ),
      );

      // log('dropdownMenuItem = ${dropdownMenuItem.value}');

      items.add(dropdownMenuItem);
    }

    // log('items = $items');
    /// 1-variantyn ayagi

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: items,
    );
  }

  String getSelectCurrency() {
    if (!Platform.isIOS) {
      return currencyList[_selectedItemIndex];
    } else {
      return dropdownValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          '🤑Coin Ticker',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                  ),
                  child: Text(
                    '$_btcValue BTC = $_fiatMoneyValue ${getSelectCurrency()}'
                        .toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.blueAccent,
            height: 200,
            width: double.infinity,
            child: Center(
              child:
                  !Platform.isIOS ? buildItemsForiOS() : buildItemsForAndroid(),
            ),
          ),
        ],
      ),
    );
  }
}
