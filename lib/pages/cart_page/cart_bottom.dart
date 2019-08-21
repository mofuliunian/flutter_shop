import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _selectAllBtn(context),
          _allPriceArea(context),
          _goButton(context)
        ],
      ),
    );
  }

  // 全选按钮
  Widget _selectAllBtn(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: true,
            activeColor: Colors.pink,
            onChanged: (bool val) {

            },
          ),
          Text('全选')
        ],
      ),
    );
  }

  // 合计
  Widget _allPriceArea(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(430),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(280),
                child: Text(
                  '合计：',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36)
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(150),
                child: Text(
                  '¥ 1992',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                    color: Colors.red
                  ),
                ),
              )
            ],
          ),
          Container(
            width: ScreenUtil().setWidth(430),
            alignment: Alignment.centerRight,
            child: Text(
              '满10元免配送费，预购免配送费',
              style: TextStyle(
                fontSize: ScreenUtil().setWidth(22),
                color: Colors.black38
              ),
            ),
          )
        ],
      ),
    );
  }

  // 结算按钮
  Widget _goButton(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {

        },
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(3)
          ),
          child: Text(
            '结算(6)',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }

}
