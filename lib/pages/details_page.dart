import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import './details_page/details_top_area.dart';
import './details_page/details_explain.dart';
import './details_page/datails_tabbar.dart';
import './details_page/details_web.dart';
import './details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {

  final String goodsId;
  const DetailsPage({Key key, this.goodsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('商品详细页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(80)),
                  child: ListView(
                    children: <Widget>[
                      DetailTopArea(),
                      DetailsExplain(),
                      DetailsTabbar(),
                      DetailsWeb(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DetailsBottom(),
                )
              ],
            );
          } else {
            return Text('加载中');
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
