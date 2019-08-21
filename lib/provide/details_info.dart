import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {

  DetailsModel goodsInfo;

  bool isLeft = true;
  bool isRight = false;

  // tabbar切换
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  // 从后台获取商品数据
  getGoodsInfo(String id) async {
    var formData = {
      'goodId': id
    };
    await getGoodDetailById(formData).then((res) {
      var responseDate = json.decode(res.toString());
      goodsInfo = DetailsModel.fromJson(responseDate);
      notifyListeners();
    });
  }

}
