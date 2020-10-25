import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:options_store/Admin/adminLogin.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/DialogBox/errorDialog.dart';
import 'package:options_store/DialogBox/loadingDialog.dart';
import 'package:options_store/Store/storehome.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/customTextField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                'images/login.png',
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _emailTextController.text.isNotEmpty &&
                        _passwordTextController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: "please write email and password",
                          );
                        });
              },
              color: kAppSecondColor,
              child: Text(
                'Login',
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
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSignInPage())),
              icon: Icon(
                Icons.nature_people,
                color: kAppFirstColor,
              ),
              label: Text(
                "I'm Admin",
                style: TextStyle(
                    color: kAppSecondColor, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  /// create a loging function :
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: 'Authenticating, Please wait...',
          );
        });
    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextController.text.trim(),
      password: _passwordTextController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (context) => StoreHome());
        Navigator.push(context, route);
      });
    }
  }

  ///Function to collect data from firebase:
  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection('users')
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot.data[EcommerceApp.userUID]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot.data[EcommerceApp.userEmail]);
      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot.data[EcommerceApp.userName]);
      await EcommerceApp.sharedPreferences.setString(EcommerceApp.userAvatarUrl,
          dataSnapshot.data[EcommerceApp.userAvatarUrl]);

      //for the list of items in the cart list
      List<String> cartList =
          dataSnapshot.data[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
