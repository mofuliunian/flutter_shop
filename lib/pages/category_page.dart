import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
// 上拉加载下拉刷新插件
import 'package:flutter_easyrefresh/easy_refresh.dart';
// 轻提示插件
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCatrgoryNav(),
                CategoryGoodsList()
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    _getCategory();
    _getMallGoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1, color: Colors.black12))
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
        itemCount: list.length,
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = index == listIndex ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList, categoryId);
        _getMallGoods(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
          color: isClick ? Colors.grey[100] : Colors.white,
          border: Border(bottom: BorderSide(width: .5, color: Colors.black12)),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  // 获取并切换右侧顶部导航
  void _getCategory() async {
    await getCategory().then((res) {
      var data = json.decode(res);
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  // 获取并切换右侧商品显示
  void _getMallGoods({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': "",
      'page': 1
    };
    await getMallGoods(data).then((res) {
      var data = json.decode(res);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}



// 右侧顶部导航
class RightCatrgoryNav extends StatefulWidget {
  @override
  _RightCatrgoryNavState createState() => _RightCatrgoryNavState();
}

class _RightCatrgoryNavState extends State<RightCatrgoryNav> {

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border:Border(bottom: BorderSide(width: 1, color: Colors.black12))
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _rightInkWell(childCategory.childCategoryList[index], index);
            },
            itemCount: childCategory.childCategoryList.length,
          ),
        );
      },
    );
  }

  Widget _rightInkWell(BxMallSubDto item, int index) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex) ? true : false;
    return InkWell(
      onTap: () {
        Provide.value<ChildCategory>(context).changeChildIndex(index, item.mallSubId);
        _getMallGoods(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 15, 8, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(32),
            color: isClick ? Colors.pink : Colors.black
          ),
        ),
      ),
    );
  }

  void _getMallGoods(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await getMallGoods(data).then((res) {
      var data = json.decode(res);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }

}



// 商品列表， 上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  var scorllController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            // 列表位置放到最上边
            scorllController.jumpTo(0.0);
          }
        } catch(e) {
          print('第一次进入页面$e');
        }

        if (data.goodsList.length > 0) {
          // 有伸缩能力的组件
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                footer: ClassicalFooter(
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  loadReadyText: '上拉加载更多',
                  loadingText: '加载中',
                  infoText: '',
                  loadedText: '加载完成'
                ),
                child: ListView.builder(
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listItemWidget(data.goodsList[index]);
                  },
                  controller: scorllController,
                ),
                onLoad: () async {
                  _getMoreList();
                },
              )
            ),
          );
        } else {
          return Text('暂无数据');
        }
      },
    );
  }

  void _getMoreList() async {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };
    await getMallGoods(data).then((res) {
      var data = json.decode(res);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Fluttertoast.showToast(
          msg: '已经到底了',
          //轻提示大小
          toastLength: Toast.LENGTH_LONG,
          // 提示位置
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16
        );
        Provide.value<ChildCategory>(context).changeNoMore('暂无更多数据');
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(goodsList.data);
      }
    });
  }

  // 商品图片
  Widget _goodsImage(index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(index.image),
    );
  }

  // 商品名称
  Widget _goodsName(index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(340),
      child: Text(
        index.goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28)
        ),
      ),
    );
  }


  // 商品价格
  Widget _goodsPrice(index) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(349),
      child: Row(
        children: <Widget>[
          Text(
            '价格：¥${index.presentPrice}',
            style: TextStyle(
              color: Colors.pink, fontSize: ScreenUtil().setSp(30)
            ),
          ),
          Text(
            '¥${index.oriPrice}',
            style: TextStyle(
              color: Colors.black26,
              decoration: TextDecoration.lineThrough,
              fontSize: ScreenUtil().setSp(22)
            ),
          ),
        ],
      ),
    );
  }

  // 列表item组合
  Widget _listItemWidget(index) {
    return InkWell(
      onTap: () {
        Application.router.navigateTo(context, '/detail?id=${index.goodsId}');
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(index),
            Column(
              children: <Widget>[
                _goodsName(index),
                _goodsPrice(index)
              ],
            )
          ],
        ),
      ),
    );
  }

}
