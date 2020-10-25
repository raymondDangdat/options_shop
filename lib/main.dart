import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:options_store/Authentication/authenication.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/Counters/ItemQuantity.dart';
import 'package:options_store/Counters/cartitemcounter.dart';
import 'package:options_store/Counters/changeAddresss.dart';
import 'package:options_store/Counters/totalMoney.dart';
import 'package:options_store/Store/storehome.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// to make our users authenticated first
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = Firestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartItemCounter(),
        ),
        ChangeNotifierProvider(
          create: (context) => ItemQuantity(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressChanger(),
        ),
        ChangeNotifierProvider(
          create: (context) => TotalAmount(),
        ),
      ],
      child: MaterialApp(
          title: 'OptionsStore',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xFF273c67),
          ),
          home: SplashScreen()),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  ///make user route to the required page:
  displaySplash() {
    Timer(Duration(seconds: 6), () async {
      if (await EcommerceApp.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: kScreenDecorations,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/welcome.png'),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "World's Largest Online Shop..",
                style:
                    TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
