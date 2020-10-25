import 'package:flutter/material.dart';
import 'package:options_store/Address/address.dart';
import 'package:options_store/Authentication/authenication.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/Orders/myOrders.dart';
import 'package:options_store/Store/Search.dart';
import 'package:options_store/Store/cart.dart';
import 'package:options_store/Store/storehome.dart';
import 'package:options_store/Widgets/Constants.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kAppFirstColor,
                  kAppSecondColor,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.5),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80)),
                  elevation: 8.0,
                  child: Container(
                    height: 150,
                    width: 150,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userAvatarUrl),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userName),
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'Signatra'),
                )
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: kScreenDecorations,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => StoreHome());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 3.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.list,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => MyOrders());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 3.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => CartPage());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 3.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => SearchProduct());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 3.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => Address());
                    Navigator.push(context, route);
                  },
                ),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 3.0,
                ),
                ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      EcommerceApp.auth.signOut().then(
                        (c) {
                          Route route = MaterialPageRoute(
                              builder: (c) => AuthenticScreen());
                          Navigator.pushReplacement(context, route);
                        },
                      );
                    }),
                Divider(
                  height: 10,
                  color: Colors.white,
                  thickness: 3.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (context) => Address());
                    Navigator.push(context, route);
                  },
                ),
                SizedBox(
                  height: 200,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
