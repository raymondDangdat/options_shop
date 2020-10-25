import 'package:flutter/material.dart';
import 'package:options_store/Models/item.dart';
import 'package:options_store/Store/storehome.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/customAppBar.dart';
import 'package:options_store/Widgets/myDrawer.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child:
                                Image.network(widget.itemModel.thumbnailUrl)),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(widget.itemModel.longDescription),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "₦ " + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 10),
                    child: InkWell(
                      onTap: () {
                        checkItemInCart(widget.itemModel.shortInfo, context);
                      },
                      child: Container(
                        decoration: kScreenDecorations,
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Add to cart",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, left: 10),
                    child: InkWell(
                      onTap: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => StoreHome());
                        Navigator.pushReplacement(context, route);
                      },
                      child: Container(
                        decoration: kScreenDecorations,
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        child: Center(
                          child: Text(
                            "Go Home",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
