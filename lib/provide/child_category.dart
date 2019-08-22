import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  
  List<BxMallSubDto> childCategoryList = [];
  // 子类高亮索引
  int childIndex = 0;
  //大类索引
  int categoryIndex = 0; 
  // 选中的左侧大类id
  String categoryId = '4';
  // 选中的右侧顶部小类id
  String subId = '';
  // 商品页码
  int page = 1;
  // 显示没有数据的文字
  String noMoreText = '';
  
  // 大类切换
  getChildCategory(List<BxMallSubDto> list, String id) {
    childIndex = 0;
    categoryId = id;
    page = 1;
    noMoreText = '';
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallSubName = '全部';
    all.mallCategoryId = '';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变左侧导航
  changeCategory(String id,int index){
    categoryId = id;
    categoryIndex = index;
    subId = '';
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(int index, String id) {
    childIndex = index;
    page = 1;
    noMoreText = '';
    subId = id;
    notifyListeners();
  }

  // 页码增加
  addPage() {
    page++;
  }

  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

}
