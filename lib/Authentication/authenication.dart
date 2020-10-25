import 'package:options_store/Authentication/login.dart';
import 'package:options_store/Authentication/register.dart';
import 'package:options_store/Widgets/Constants.dart';
import 'package:flutter/material.dart';

class AuthenticScreen extends StatefulWidget {
  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: kScreenDecorations,
          ),
          title: Text(
            'Options  Store',
            style: TextStyle(
                fontSize: 55, color: Colors.white, fontFamily: "Signatra"),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                text: 'Login',
              ),
              Tab(
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.white,
                ),
                text: 'Register',
              ),
            ],
            indicatorColor: Colors.grey,
            indicatorWeight: 5.0,
          ),
        ),
        body: Container(
          decoration: kScreenDecorations,
          child: TabBarView(
            children: [
              Login(),
              Register(),
            ],
          ),
        ),
      ),
    );
  }
}
