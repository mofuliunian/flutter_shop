import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

//  {}为可选参数
Future resquest(url, {formData}) async {
  print('开始获取数据');
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    return print('ERROR:=======$e');
  }
}

// 获取首页主体内容
Future getHomePageContent() async {
  print('开始获取首页主体内容');
  return resquest('homePageContent', formData: {'lon': '115.02932', 'lat': '35.7618'});
}

// 获取首页火爆专区内容
Future getHomePageBelowContent(page) async {
  print('开始获取首页火爆专区内容');
  return resquest('homePageBelowContent', formData: page);
}

// 获取分类信息
Future getCategory() async{
  print('开始获取分类信息');
  return resquest('getCategory');
}

// 获取分类商品列表信息
Future getMallGoods(formData) async{
  print('开始获取分类商品列表信息');
  return resquest('getMallGoods', formData: formData);
}
