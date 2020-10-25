//import 'package:options_store/shop/Config/config.dart';
import 'package:flutter/foundation.dart';
import 'package:options_store/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .length -
      1;
  //create a getter for the private counter:
  int get count => _counter;

  Future<void> displayResult() async {
    int _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .length -
        1;
    await Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
    return _counter;
  }
}
