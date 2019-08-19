import 'package:flutter/material.dart';
import '../service/service_method.dart';
// 轮播图
import "package:flutter_swiper/flutter_swiper.dart";
// json格式化
import "dart:convert";
// 屏幕适配
import 'package:flutter_screenutil/flutter_screenutil.dart';
// url跳转插件
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;

  // @override
  // void initState() {
  //   super.initState();
  //   print('sssssss');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        // 异步方法
        future: getHomePageContent(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString())['data'];
            List<Map> swiper = (data['slides'] as List).cast();
            List<Map> navgatorList = (data['category'] as List).cast();
            String adPicture = data['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['shopInfo']['leaderImage'];
            String leaderPhone = data['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['recommend'] as List).cast();
            String floor1Title = data['floor1Pic']['PICTURE_ADDRESS'];
            List<Map> floor1 = (data['floor1'] as List).cast();
            String floor2Title = data['floor2Pic']['PICTURE_ADDRESS'];
            List<Map> floor2 = (data['floor2'] as List).cast();
            String floor3Title = data['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor3 = (data['floor3'] as List).cast();

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SwiperDiy(
                    swiperList: swiper,
                  ),
                  TopNavigator(
                    navigatorList: navgatorList,
                  ),
                  AdBanner(
                    adPicture: adPicture,
                  ),
                  LeaderPhone(
                    leaderImage: leaderImage,
                    leaderPhone: leaderPhone,
                  ),
                  Recomend(
                    recommendList: recommendList
                  ),
                  FloorTitle(
                    pictureAddress: floor1Title
                  ),
                  FloorContent(
                    floorGoodsList: floor1
                  ),
                  FloorTitle(
                    pictureAddress: floor2Title
                  ),
                  FloorContent(
                    floorGoodsList: floor2
                  ),
                  FloorTitle(
                    pictureAddress: floor3Title
                  ),
                  FloorContent(
                    floorGoodsList: floor3
                  ),
                ],
            ));
          } else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
      )
    );
  }
}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperList;
  SwiperDiy({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(274.0),
      width: ScreenUtil().setWidth(750.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network('${swiperList[index]['image']}');
        },
        itemCount: swiperList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 顶部列表
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print(item);
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(85),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeLast();
    }
    return Container(
      height: ScreenUtil().setHeight(275),
      padding: EdgeInsets.all(9),
      child: GridView.count(
        // 禁止滚动
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告区域
class AdBanner extends StatelessWidget {
  final String adPicture;

  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话
  const LeaderPhone({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    // 判断是否可以拨打
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '===不能进行访问===';
    }
  }
}

// 商品推荐
class Recomend extends StatelessWidget {

  final List recommendList;

  const Recomend({Key key, this.recommendList}) : super(key: key);

  // 标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(12, 2, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: .5, color: Colors.black12)
        ),
      ),
      height: ScreenUtil().setHeight(60),
      child: Text(
        '商品推荐',
        style: TextStyle(
          color: Colors.pink
        ),
      ),
    );
  }

  // 商品单独项
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(270),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              width: .5,
              color: Colors.black12,
            )
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('¥${recommendList[index]["mallPrice"]}'),
            Text(
              '¥${recommendList[index]["price"]}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }

  // 横向列表
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(270),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList()
        ],
      ),
      margin: EdgeInsets.only(top: 12),
      height: ScreenUtil().setHeight(330),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {

  final String pictureAddress;

  const FloorTitle({Key key, this.pictureAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(pictureAddress),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {

  final List floorGoodsList;

  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }
  
  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {print('点击了楼层商品');},
        child: Image.network(goods['image']),
      ),
    );
  }

}


