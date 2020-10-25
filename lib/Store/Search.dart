import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:options_store/Models/item.dart';
import 'package:options_store/Store/storehome.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/customAppBar.dart';
import 'package:options_store/Widgets/myDrawer.dart';

///now we create a search product widget:
class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  Future<QuerySnapshot> docList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          bottom: PreferredSize(
            child: searchWidget(),
            preferredSize: Size(56.0, 56.0),
          ),
        ),
        drawer: MyDrawer(),

        ///to get if the items being searched for is present or not:
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap) {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.documents.length,
                    itemBuilder: (context, index) {
                      ItemModel model =
                          ItemModel.fromJson(snap.data.documents[index].data);

                      return sourceInfo(model, context);
                    })
                : Center(child: Text("No data yet, type something..."));
          },
        ),
      ),
    );
  }

  Widget searchWidget() {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      decoration: kScreenDecorations,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: Colors.blueGrey,
              ),
            ),
            Flexible(
                child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: TextField(
                onChanged: (value) {
                  ///call the function:

                  setState(() {
                    startSearching(value);
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Search here..."),
              ),
            ))
          ],
        ),
      ),
    );
  }

  /// creates a function when text is inputed gets the items from database:
  startSearching(String query) {
    docList = Firestore.instance
        .collection("items")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .getDocuments();
  }
}
