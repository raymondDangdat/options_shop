import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:options_store/Admin/adminShiftOrders.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/loadingWidget.dart';
import 'package:options_store/main.dart';
import 'package:random_string/random_string.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;

  File file;

  final TextEditingController _descriptionTextController =
      TextEditingController();
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _shortInfoTextController =
      TextEditingController();
  final TextEditingController _priceTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String productId = '${randomAlphaNumeric(9)}';
  bool uploading = false;

  @override
  Widget build(BuildContext context) {
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kScreenDecorations,
        ),
        title: Text(
          'Options  Store',
          style: TextStyle(
              fontSize: 39, color: Colors.white, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.border_color,
            color: Colors.white,
          ),
          onPressed: () {
            Route route =
                MaterialPageRoute(builder: (context) => AdminShiftOrders());
            Navigator.push(context, route);
          },
        ),
        actions: [
          FlatButton(
            child: Text(
              "LogOut",
              style: TextStyle(
                  color: kAppFirstColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (context) => SplashScreen());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: kScreenDecorations,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)),
                child: Text(
                  'Add New Item',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                color: Colors.teal,
                onPressed: () {
                  takeImage(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Function to either select from gallery or snap with camera:
  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
                onPressed: selectPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  selectPhotoFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });
  }

  /// create the AdminForm Screen :
  displayAdminUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: kScreenDecorations,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: clearFormInfo,
        ),
        title: Text(
          "New Product",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            child: Text("Add",
                style: TextStyle(
                    color: kAppFirstColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(file), fit: BoxFit.cover)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: kAppFirstColor,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextController,
                decoration: InputDecoration(
                    hintText: "Short Info",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: kAppFirstColor,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: kAppFirstColor,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextController,
                decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none),
              ),
            ),
          ),
          Divider(
            color: kAppFirstColor,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: kAppFirstColor,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextController,
                decoration: InputDecoration(
                  hintText: "Complete description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: kAppFirstColor,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: kAppFirstColor,
            ),
            title: Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextController,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: kAppFirstColor,
          )
        ],
      ),
    );
  }

  ///to clear all the fields when back button is clicked:
  clearFormInfo() {
    setState(() {
      file = null;
      _priceTextController.clear();
      _descriptionTextController.clear();
      _titleTextController.clear();
      _shortInfoTextController.clear();
    });
  }

  /// upload and save image to database and Storage
  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  ///to upload images to Storage
  Future<String> uploadItemImage(mFileImage) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Items');
    StorageUploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  ///to save item information to firebase:
  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("items");
    itemsRef.document(productId).setData({
      "shortInfo": _shortInfoTextController.text.trim(),
      "longDescription": _descriptionTextController.text.trim(),
      "publishedDate": DateTime.now(),
      "price": int.parse(_priceTextController.text),
      "status": "Available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextController.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = '${randomAlphaNumeric(9)}';
      _priceTextController.clear();
      _descriptionTextController.clear();
      _titleTextController.clear();
      _shortInfoTextController.clear();
    });
  }
}
