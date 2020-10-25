import 'package:flutter/foundation.dart';

class AddressChanger extends ChangeNotifier {
  int _numberOfAddress = 0;

  int get numberOfAddress => _numberOfAddress;

  displayResult(int num) {
    _numberOfAddress = num;
    notifyListeners();
  }
}
