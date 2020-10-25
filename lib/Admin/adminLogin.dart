import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:options_store/Admin/uploadItems.dart';
import 'package:options_store/Authentication/authenication.dart';
import 'package:options_store/DialogBox/errorDialog.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:options_store/Widgets/customTextField.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ),
      body: AdminSignInScreen(),
    );
  }
}

///create the adminsignin screen here:
class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        decoration: kScreenDecorations,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Image.asset(
                'images/admin.png',
                height: 240,
                width: 240,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Admin',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _adminIDTextController,
                    data: Icons.person,
                    hintText: "Admin ID  ",
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
                _adminIDTextController.text.isNotEmpty &&
                        _passwordTextController.text.isNotEmpty
                    ? loginAdmin()
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
              height: 20,
            ),
            FlatButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AuthenticScreen())),
              icon: Icon(
                Icons.nature_people,
                color: kAppFirstColor,
              ),
              label: Text(
                "I'm Not Admin",
                style: TextStyle(
                    color: kAppSecondColor, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  //create the admin login function:
  loginAdmin() {
    Firestore.instance.collection('admins').getDocuments().then((snapshot) {
      snapshot.documents.forEach((result) {
        if (result.data['id'] != _adminIDTextController.text.trim()) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text('Your id is not correct')));
        } else if (result.data['password'] !=
            _passwordTextController.text.trim()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Your password is not correct'),
          ));
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Welcome Dear Admin,' + result.data['name'])));

          setState(() {
            _adminIDTextController.text = "";
            _passwordTextController.text = "";
          });

          Route route = MaterialPageRoute(builder: (context) => UploadPage());
          Navigator.push(context, route);
        }
      });
    });
  }
}
