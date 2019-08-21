import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCardInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List cartList = Provide.value<CartProvide>(context).cardList;
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, val) {
                    cartList = val.cardList;
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (BuildContext context, index) {
                        return CartItem(cartList[index]);
                      },
                      padding:
                          EdgeInsets.only(bottom: ScreenUtil().setHeight(120)),
                    );
                  },
                ),
                Positioned(
                  child: CartBottom(),
                  bottom: 0,
                  left: 0,
                )
              ],
            );
          } else {
            return Text('正在加载中');
          }
        },
      ),
    );
  }

  Future<String> _getCardInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}
