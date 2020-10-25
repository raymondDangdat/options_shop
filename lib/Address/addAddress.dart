import 'package:flutter/material.dart';
import 'package:options_store/Address/address.dart';
import 'package:options_store/Config/config.dart';
import 'package:options_store/Models/address.dart';
import 'package:options_store/Widgets/customAppBar.dart';
import 'package:options_store/Widgets/myDrawer.dart';
import 'package:random_string/random_string.dart';

class AddAddress extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cAddress = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cCountry = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                phoneNumber: cPhoneNumber.text.trim(),
                address: cAddress.text.trim(),
                city: cCity.text.trim(),
                state: cState.text.trim(),
                country: cCountry.text.trim(),
              ).toJson();

              ///add to firestore:
              EcommerceApp.firestore
                  .collection((EcommerceApp.collectionUser))
                  .document((EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID)))
                  .collection(EcommerceApp.subCollectionAddress)
                  .document("${randomAlphaNumeric(9)}")
                  .setData(model)
                  .then((value) {
                final snack = SnackBar(
                  content: Text("New Address Added Successfully"),
                );
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();

                /// then it takes you to the address page to display it
              }).then((value) {
                Route route = MaterialPageRoute(builder: (c) => Address());
                Navigator.pushReplacement(context, route);
              });
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.deepOrange,
          icon: Icon(Icons.check),
        ),
        drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Add New Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),
                    MyTextField(
                      hint: "Address",
                      controller: cAddress,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Country",
                      controller: cCountry,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  MyTextField({Key key, this.hint, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
          controller: controller,
          decoration: InputDecoration.collapsed(hintText: hint),
          validator: (val) =>
              val.isEmpty ? "This Field cannot be empty" : null),
    );
  }
}
