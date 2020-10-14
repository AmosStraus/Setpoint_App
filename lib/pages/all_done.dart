import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:set_point_attender/shared/parse_names.dart';

class AllDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("נרשם בהצלחה"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "תודה ${employeesToHebrew[user.email.split('@')[0]]}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 120),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.black, width: 3)),
              height: 75.0,
              minWidth: 220.0,
              color: Colors.brown[900],
              textColor: Colors.white,
              child: Text(
                "לדיווח נוסף מאותו יום",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 25),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(color: Colors.black, width: 3)),
              height: 75.0,
              minWidth: 220.0,
              color: Colors.brown[900],
              textColor: Colors.white,
              child: Text(
                "לדיווח חדש",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
