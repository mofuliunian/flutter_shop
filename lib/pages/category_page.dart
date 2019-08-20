import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';

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
    // TODO: implement initState
    _getCategory();
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
        Provide.value<ChildCategory>(context).getChildCategory(childList);
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

  void _getCategory() async {
    await getCategory().then((res) {
      var data = json.decode(res);
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto);
    });
  }
}

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
              return _rightInkWell(childCategory.childCategoryList[index]);
            },
            itemCount: childCategory.childCategoryList.length,
          ),
        );
      },
    );
  }

  Widget _rightInkWell(BxMallSubDto item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 15, 8, 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(32)),
        ),
      ),
    );
  }
}

// 商品列表， 上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  List list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMallGoods();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(570),
      height: ScreenUtil().setHeight(1000),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _listItemWidget(index);
        },
      ),
    );
  }

  void _getMallGoods() async {
    var data = {
      'categoryId': '4',
      'categorySubId': "",
      'page': 1
    };
    await getMallGoods(data).then((res) {
      var data = json.decode(res);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      setState(() {
        list = goodsList.data;
      });
    });
  }

  Widget _goodsImage(index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodsName(index) {
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(349),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28)
        ),
      ),
    );
  }

  Widget _goodsPrice(index) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(349),
      child: Row(
        children: <Widget>[
          Text(
            '价格：¥${list[index].presentPrice}',
            style: TextStyle(
              color: Colors.pink, fontSize: ScreenUtil().setSp(30)
            ),
          ),
          Text(
            '¥${list[index].oriPrice}',
            style: TextStyle(
              color: Colors.black26,
              decoration: TextDecoration.lineThrough
            ),
          ),
        ],
      ),
    );
  }

  Widget _listItemWidget(index) {
    return InkWell(
      onTap: () {},
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
