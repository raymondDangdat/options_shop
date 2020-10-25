import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmount = 0.0;

  double get totalAmount => _totalAmount;

  display(double tA) async {
    _totalAmount = tA;

    await Future.delayed(Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
