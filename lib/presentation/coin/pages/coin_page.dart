import 'dart:developer';
import 'dart:io' show Platform;

import 'package:btc_app/utils/constant_datas.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/coin/models/coin.model.dart';
import '../../../data/repositories/coin/repositories/coin_repository.dart';
import '../../../data/services/coin_api_srvs.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CoinPageState createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  //int _btcValue = 1;
  double _fiatMoneyValue = 0;
  final int _btcValue = 1;

  CoinModel? _coinModel;

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
    _coinModel = await CoinRepository().getCurrencyRate(currency);

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
        await getCurrencyRate(currencyList[selectedItem]);

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
    );
  }

  Widget buildItemsForAndroid() {
    List<DropdownMenuItem<String>> items = [];

    for (var currency in currencyList) {
      items.add(
        DropdownMenuItem<String>(
          value: currency,
          child: Text(
            currency,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    }

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
                  child: _buildText(),
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

  Widget _buildText() {
    if (_coinModel == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Text(
        '$_btcValue BTC = ${_coinModel!.rate.toStringAsFixed(2)} ${getSelectCurrency()}'
            .toUpperCase(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
