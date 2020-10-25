import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
    ),
  );
}

linearProgress() {
  return Container(
    height: 12,
    width: 100,
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: Text(
      "Item Saving...",
      style: TextStyle(fontSize: 18, color: Colors.green),
    ),
  );
}

// LinearProgressIndicator(
// valueColor: AlwaysStoppedAnimation(Colors.blue),
// ),
