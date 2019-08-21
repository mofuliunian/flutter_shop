import 'package:flutter/material.dart';
import 'pages/index_page.dart';
// 调试使用
// import 'package:flutter/rendering.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import './provide/details_info.dart';
import './provide/currentIndex.dart';
// 路由管理
import 'package:fluro/fluro.dart';
import './routers/routers.dart';
import './routers/application.dart';

void main() {
  // 调试使用
  // debugPaintSizeEnabled = true;

  var counter = Counter();
  var childCategoryList = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var detailsInfoProvide = DetailsInfoProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers = Providers();
    
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategoryList))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));


  runApp(ProviderNode(child: MyApp(), providers: providers,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        // 路由注册
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}
