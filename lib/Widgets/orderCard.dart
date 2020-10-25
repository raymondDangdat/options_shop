import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:options_store/Models/item.dart';
import 'package:options_store/Orders/OrderDetailsPage.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:flutter/material.dart';

import '../Store/storehome.dart';

int counter = 0;

class OrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;

  OrderCard({this.itemCount, this.orderID, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;
        if (counter == 0) {
          counter += 1;
          route = MaterialPageRoute(
              builder: (context) => OrderDetails(orderID: orderID));
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

Widget sourceOrderInfo(ItemModel model, BuildContext context,
    {Color background}) {
  width = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
      height: 140.0,
      width: width,
      child: Row(
        children: [
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              model.thumbnailUrl,
              width: 140,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.title,
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.shortInfo,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text(
                                r"Total Price: ",
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                "₦",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              Text(
                                (model.price).toString(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[90]),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Container(),
                ),
                Divider(
                  height: 5.0,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
