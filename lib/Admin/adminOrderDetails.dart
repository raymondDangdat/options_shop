import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:options_store/Address/address.dart';
import 'package:options_store/Admin/uploadItems.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/Models/address.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/loadingWidget.dart';
import 'package:options_store/Widgets/orderCard.dart';

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({Key key, this.orderBy, this.addressID, this.orderID})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: EcommerceApp.firestore
                .collection(EcommerceApp.collectionOrders)
                .document(getOrderId)
                .get(),
            builder: (c, snapshot) {
              Map dataMap;
              if (snapshot.hasData) {
                dataMap = snapshot.data.data;
              }
              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          AdminStatusBanner(
                            status: dataMap[EcommerceApp.isSuccess],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₦ " +
                                    dataMap[EcommerceApp.totalAmount]
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Order ID: " + getOrderId),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ordered at: " +
                                  DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(dataMap["orderTime"]))),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<QuerySnapshot>(
                            future: EcommerceApp.firestore
                                .collection('items')
                                .where("shortInfo",
                                    whereIn: dataMap[EcommerceApp.productID])
                                .getDocuments(),
                            builder: (c, dataSnapshot) {
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount:
                                          dataSnapshot.data.documents.length,
                                      data: dataSnapshot.data.documents,
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          Divider(
                            height: 2.0,
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: EcommerceApp.firestore
                                .collection(EcommerceApp.collectionUser)
                                .document(orderBy)
                                .collection(EcommerceApp.subCollectionAddress)
                                .document(addressID)
                                .get(),
                            builder: (c, snap) {
                              return snap.hasData
                                  ? AdminShippingDetails(
                                      model:
                                          AddressModel.fromJson(snap.data.data),
                                    )
                                  : Center(
                                      child: circularProgress(),
                                    );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('😀', style: TextStyle(fontSize: 30)),
                          Text('Thank You', style: TextStyle(fontSize: 15))
                        ],
                      ),
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  AdminStatusBanner({this.status});
  @override
  Widget build(BuildContext context) {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successfully" : msg = " Unsuccessful";
    return Container(
      decoration: kScreenDecorations,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              SystemNavigator.pop();
              Navigator.pop(context);
            },
            child: Container(
              child: Icon(Icons.arrow_drop_down_circle),
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Order Shipped " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final AddressModel model;
  AdminShippingDetails({this.model});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 5.0),
          child: Text(
            "Shipping Details",
            style: TextStyle(),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(
                children: [
                  KeyText(
                    msg: "Name",
                  ),
                  Text(model.name),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Phone Number",
                  ),
                  Text(model.phoneNumber),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Address",
                  ),
                  Text(model.address),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "City",
                  ),
                  Text(model.city),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "State",
                  ),
                  Text(model.state),
                ],
              ),
              TableRow(
                children: [
                  KeyText(
                    msg: "Country",
                  ),
                  Text(model.country),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: InkWell(
            onTap: () {
              confirmParcelShifted(context, getOrderId);
            },
            child: Container(
              decoration: kScreenDecorations,
              width: MediaQuery.of(context).size.width - 40,
              height: 50.0,
              child: Center(
                child: Text(
                  "Confirmed || Parcel Shipped",
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          )),
        )
      ],
    );
  }

  confirmParcelShifted(BuildContext context, String mOrderID) {
    EcommerceApp.firestore
        .collection(EcommerceApp.collectionUser)
        .document(mOrderID)
        .delete();

    getOrderId = "";

    Route route = MaterialPageRoute(builder: (c) => UploadPage());
    Navigator.pushReplacement(context, route);

    Fluttertoast.showToast(msg: "Parcel has been shipped.");
  }
}

class PaymentDetailsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
