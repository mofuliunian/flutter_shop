import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handler.dart';

class Routes {
  static String root = '/';
  static String detailsPage = '/detail';
  static void configureRoutes(Router router) {
    // 路由不存在
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR====>ROUTE WAS NOT FONUND!!!');
        return Text('sss');
      }
    );
    // 路由配置
    router.define(detailsPage, handler: detailsHandler);
    router.define(root, handler: rootHandler);
    // router.define(detailsPage, handler: detailsHandler);

  }
}
