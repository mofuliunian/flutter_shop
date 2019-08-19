import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'category_page.dart';
import 'member_page.dart';
// 屏幕适配
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  //  定义底部icon
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心')
    ),
  ];

  // 定义每个页面
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];

  // 显示第几个页面
  int currentIndex = 0;
  // 显示的页面
  var currentPage;

  @override
  void initState() {
    currentPage = tabBodies[currentIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 初始化设计尺寸
    ScreenUtil.instance = ScreenUtil(width: 750.0, height: 1334.0)..init(context);

    // print('设备的像素密度:${ScreenUtil.pixelRatio}');
    // print('设备的高:${ScreenUtil.screenHeight}');
    // print('设备的宽:${ScreenUtil.screenWidth}');
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index) {
          setState(() {
           currentIndex = index;
           currentPage = tabBodies[index]; 
          });
        },
      ),
      // IndexedStack 层布局控件用于保持页面状态
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}
