import 'package:flutter/material.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/Counters/cartitemcounter.dart';
import 'package:options_store/Store/cart.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      flexibleSpace: Container(
        decoration: kScreenDecorations,
      ),
      centerTitle: true,
      title: Text(
        'Options  Store',
        style: TextStyle(
            fontSize: 35, color: Colors.white, fontFamily: "Signatra"),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => CartPage());
                Navigator.pushReplacement(context, route);
              },
              icon: Icon(
                Icons.shopping_cart,
                color: kAppFirstColor,
              ),
            ),
            Positioned(
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.red,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Text(
                          (EcommerceApp.sharedPreferences
                                      .getStringList(EcommerceApp.userCartList)
                                      .length -
                                  1)
                              .toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
