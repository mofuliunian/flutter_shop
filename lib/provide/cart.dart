import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cardList = [];

  save(goodsId, goodsName, count, price, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    var temp = cartString == null ? [] : json.decode(cartString);
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int index = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[index]['count'] = item['count'] + 1;
        cardList[index].count++;
        isHave = true;
      }
      index++;
    });
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'image': image
      };
      tempList.add(newGoods);
      cardList.add(CartInfoModel.fromJson(newGoods));
    }

    cartString = json.encode(tempList).toString();
    prefs.setString('cartString', cartString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartString');
    cardList = [];
    print('清空成功========>');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    cardList = [];
    if (cartString != null) {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      tempList.forEach((item) {
        cardList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

}
