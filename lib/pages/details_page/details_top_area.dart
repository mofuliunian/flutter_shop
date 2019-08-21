import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;
        if (goodsInfo != null) {
          return Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                _goodsImage(context, goodsInfo.image1),
                _goodsName(context, goodsInfo.goodsName),
                _goodsNum(context, goodsInfo.goodsSerialNumber),
                _goodsPrice(context, goodsInfo.presentPrice, goodsInfo.oriPrice),
              ],
            ),
          );
        } else {
          return Text('正在加载');
        }
      },
    );
  }

  // 商品图片
  Widget _goodsImage(context, url) {
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
    );
  }

  // 商品名称
  Widget _goodsName(context, name) {
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left: 15),
      child: Text(
        name,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
    );
  }

  // 商品编号
  Widget _goodsNum(context, num) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(top: 8),
      child: Text(
        '编号：$num',
        style: TextStyle(color: Colors.black38),
      ),
    );
  }

  //商品价格方法
  Widget _goodsPrice(context, presentPrice, oriPrice) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(top: 8),
      child: Row(
        children: <Widget>[
          Text(
            '￥$presentPrice',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: ScreenUtil().setSp(40),
            ),
          ),
          Text(
            '市场价:￥$oriPrice',
            style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }
}
