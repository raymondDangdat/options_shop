import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/DialogBox/errorDialog.dart';
import 'package:options_store/DialogBox/loadingDialog.dart';
import 'package:options_store/Store/storehome.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/customTextField.dart';
//import 'package:random_string/random_string.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _cPasswordTextController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userImageUrl = "";
  File _imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    // Future<void> _selectAndPickImage() async {
    //   _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    // }

    Future<void> _selectAndPickImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _imageFile = File(pickedFile.path);
        } else {
          print('no file was picked');
        }
      });
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  _selectAndPickImage();
                },
                child: _imageFile != null
                    ? Container(
                        width: _screenWidth * 0.29,
                        height: _screenWidth * 0.29,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.file(
                            _imageFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: _screenWidth * 0.15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: _screenWidth * 0.15,
                          color: Colors.grey,
                        ),
                      )),
            SizedBox(
              height: 8,
            ),

            ///then we add our Forms :
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextController,
                    data: Icons.person,
                    hintText: "Name ",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextController,
                    data: Icons.email,
                    hintText: "Email  ",
                    isObscure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextController,
                    data: Icons.remove_red_eye,
                    hintText: "Password ",
                    isObscure: true,
                  ),
                  CustomTextField(
                    controller: _cPasswordTextController,
                    data: Icons.remove_red_eye,
                    hintText: "Confirm Password ",
                    isObscure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () => _uploadAndSaveImage(),
              color: kAppSecondColor,
              child: Text(
                'Sign Up',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: kAppSecondColor,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadAndSaveImage() {
    if (_imageFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: "Please Select an image file. ",
            );
          });
    } else {
      _passwordTextController.text == _cPasswordTextController.text
          ? _emailTextController.text.isNotEmpty &&
                  _nameTextController.text.isNotEmpty &&
                  _passwordTextController.text.isNotEmpty &&
                  _cPasswordTextController.text.isNotEmpty
              ? uploadToStorage()
              : displayDialog('Please fill all fields')
          : displayDialog('Passwords do not match ');
    }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return ErrorAlertDialog();
        });
  }

  /// create the function to upload image to cloud storage:
  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: 'Registering, Please wait.....');
        });

    //to give our image a unique filename:
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    //uploading image to firebase storage:
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(imageFileName);
    //lets create a task to upload our image:
    StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;

    //connect the url to the user who uploaded it
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      userImageUrl = urlImage;

      //after sending and getting the url we now send to Firestore:
      _registerUser();
    });
  }

  ///save and retrieve documents to firestore;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    FirebaseUser firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextController.text.trim(),
      password: _cPasswordTextController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => StoreHome());
        Navigator.push(context, route);
      });
    }
  }

  /// Now to save all the information to Firestore:
  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection('users').document(fUser.uid).setData({
      'uid': fUser.uid,
      "email": fUser.email,
      "name": _nameTextController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"]
    });

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTextController.text.trim());
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
