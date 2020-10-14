import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:set_point_attender/pages/homepage_calendar.dart';
import 'package:set_point_attender/pages/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return LoginPage();
    } else {
      return HomePageCalendar();
    }
  }
}
