import 'package:flutter/material.dart';

Color kAppFirsColor = Color(0xFF16234b);
Color kAppFirstColor = Color(0xFFfc3903);
Color kAppFirColor = Color(0xFF273c67);

Color kAppSeconColor = Color(0xFF221460);
Color kAppSecondColor = Color(0xFFFFD591);
Color kAppTestingColor = Color(0xFFfc3903);

Color kAppPurpleColr = Color(0xFF221460);

Widget kSpecialCircle = Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.orange,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0),
        BoxShadow(
            color: Colors.white,
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0),
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.grey[200],
          Colors.grey[300],
          Colors.grey[400],
          kAppFirstColor,
        ],
        stops: [0.1, 0.3, 0.8, 1.0],
      ),
    ),
    child: Icon(Icons.favorite),
  ),
);

var kScreenDecorations = BoxDecoration(
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
);

Widget kBuyButton = Container(
  alignment: Alignment.center,
  height: 25,
  width: 57,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Colors.orange,
    shape: BoxShape.rectangle,
    boxShadow: [
      BoxShadow(
          color: Colors.grey,
          offset: Offset(4.0, 4.0),
          blurRadius: 15.0,
          spreadRadius: 1.0),
      BoxShadow(
          color: Colors.white,
          offset: Offset(-4.0, -4.0),
          blurRadius: 15.0,
          spreadRadius: 1.0),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.orange[200],
        Colors.orange[300],
        Colors.orange[600],
        kAppFirstColor,
      ],
      stops: [0.1, 0.3, 0.8, 1.5],
    ),
  ),
  child: Text(
    "Buy Now",
    style: TextStyle(color: Colors.white, fontSize: 12),
    textAlign: TextAlign.center,
  ),
);

Widget kDeleteButton = Container(
  alignment: Alignment.center,
  height: 25,
  width: 57,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    color: Colors.orange,
    shape: BoxShape.rectangle,
    boxShadow: [
      BoxShadow(
          color: Colors.grey,
          offset: Offset(4.0, 4.0),
          blurRadius: 15.0,
          spreadRadius: 1.0),
      BoxShadow(
          color: Colors.white,
          offset: Offset(-4.0, -4.0),
          blurRadius: 15.0,
          spreadRadius: 1.0),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.orange[200],
        Colors.orange[300],
        Colors.orange[600],
        kAppFirstColor,
      ],
      stops: [0.1, 0.3, 0.8, 1.5],
    ),
  ),
  child: Text(
    "Delete",
    style: TextStyle(color: Colors.white, fontSize: 12),
    textAlign: TextAlign.center,
  ),
);
