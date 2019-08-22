import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cardList = [];
  // 总价
  double allPrice = 0.0;
  // 总数量
  int allGoodsCounter = 0;
  // 全选按钮
  bool isAllCheck = true;

  save(goodsId, goodsName, count, price, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    var temp = cartString == null ? [] : json.decode(cartString);
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int index = 0;
    allGoodsCounter = 0;
    allPrice = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[index]['count'] = item['count'] + 1;
        cardList[index].count++;
        isHave = true;
      }
      if (item['isCheck']) {
        allGoodsCounter += cardList[index].count;
      }
      index++;
    });
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'image': image,
        'isCheck': true,
      };
      allGoodsCounter += count;
      // allPrice = count * price;
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
      allPrice = 0.0;
      allGoodsCounter = 0;
      isAllCheck = true;
      tempList.forEach((item) {
        cardList.add(CartInfoModel.fromJson(item));
        if (item['isCheck']) {
          allPrice += item['count'] * item['price'];
          allGoodsCounter += item['count'];
        } else {
          isAllCheck = false;
        }
      });
    }
    notifyListeners();
  }

  // 删除单个购物车商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartString', cartString);
    await getCartInfo();
    notifyListeners();
  }

  // 多选按钮
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartString', cartString);
    await getCartInfo();
    notifyListeners();
  }

  // 全选按钮
  changeAllCheckState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];
    isAllCheck = isCheck;
    tempList.forEach((item) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    });
    tempList = newList;
    cartString = json.encode(tempList).toString();
    prefs.setString('cartString', cartString);
    await getCartInfo();
    notifyListeners();
  }

  // 商品数量加减
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartString');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartString', cartString);
    await getCartInfo();
    notifyListeners();
  }

}
