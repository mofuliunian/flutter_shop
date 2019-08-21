import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (BuildContext context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailsInfoProvide>(context).isRight;

        return Container(
          margin: EdgeInsets.only(top: 8),
          child: Row(
            children: <Widget>[
              _myTabbarLeft(context, isLeft),
              _myTabbarRight(context, isRight)
            ],
          ),
        );
      },
    );
  }

  Widget _myTabbarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: isLeft ? Colors.pink : Colors.white, width: 1))
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isLeft ? Colors.pink : Colors.black87
          ),
        ),
      ),
    );
  }

  Widget _myTabbarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: isRight ? Colors.pink : Colors.white, width: 1))
        ),
        child: Text(
          '评价',
          style: TextStyle(
            color: isRight ? Colors.pink : Colors.black87
          ),
        ),
      ),
    );
  }

}
