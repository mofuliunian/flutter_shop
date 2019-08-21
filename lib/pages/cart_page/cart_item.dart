import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/cartInfo.dart';

class CartItem extends StatelessWidget {
  final CartInfoModel item;

  const CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 2, 5, 2),
      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.black12, width: 1))
      ),
      child: Row(
        children: <Widget>[
          _cartCheckBt(context),
          _cartImage(context),
          _cartName(context),
          _cartPrice(context),
        ],
      ),
    );
  }

  // 复选按钮
  Widget _cartCheckBt(BuildContext context) {
    return Container(
      child: Checkbox(
        value: true,
        activeColor: Colors.pink,
        onChanged: (bool val) {},
      ),
    );
  }

  // 商品图片
  Widget _cartImage(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12)
      ),
      child: Image.network(item.image),
    );
  }

  // 商品名称
  Widget _cartName(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(
            item.goodsName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  // 商品价格
  Widget _cartPrice(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('¥${item.price}'),
          Container(
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.delete_forever,
                color: Colors.black26,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }

}
