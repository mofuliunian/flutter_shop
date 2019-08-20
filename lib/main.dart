import 'package:flutter/material.dart';
import 'pages/index_page.dart';
// 调试使用
// import 'package:flutter/rendering.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';

void main() {
  // 调试使用
  // debugPaintSizeEnabled = true;

  var counter = Counter();
  var childCategoryList = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var providers = Providers();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategoryList))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers,));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}
