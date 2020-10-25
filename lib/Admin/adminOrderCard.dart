import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:options_store/Admin/adminOrderDetails.dart';
import 'package:options_store/Models/item.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/orderCard.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  AdminOrderCard(
      {Key key,
      this.data,
      this.orderID,
      this.itemCount,
      this.addressID,
      this.orderBy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter += 1;
          route = MaterialPageRoute(
              builder: (context) => AdminOrderDetails(
                  orderID: orderID, orderBy: orderBy, addressID: addressID));
        }
        Navigator.push(context, route);
      },
      child: Container(
        decoration: kScreenDecorations,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
            itemCount: itemCount,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (C, index) {
              ItemModel model = ItemModel.fromJson(data[index].data);
              return sourceOrderInfo(model, context);
            }),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return Container(
    child: Column(
      children: [
        Text("To be implimented "),
      ],
    ),
  );
}
