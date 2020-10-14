import 'package:flutter/material.dart';
import 'package:set_point_attender/models/auth.dart';

class LogoutBurgerWidget extends StatelessWidget {
  final AuthService _auth = AuthService();
  LogoutBurgerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, size: 35.0),
      color: Colors.red[100],
      onSelected: (String value) {
        switch (value) {
          case 'התנתקות':
            showAlertDialog(context);
            break;
          case 'דיווח חודשי':
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/monthlyReports');
            break;
          case 'דף ראשי':
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'דף ראשי',
            child: Text(
              'דף ראשי',
              style: TextStyle(fontSize: 18),
            ),
          ),
          PopupMenuItem<String>(
            value: 'דיווח חודשי',
            child: Text(
              'דיווח חודשי',
              style: TextStyle(fontSize: 18),
            ),
          ),
          PopupMenuItem<String>(
            value: 'התנתקות',
            child: Text(
              'התנתקות',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ];
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("לא"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("כן"),
      onPressed: () async {
        await _auth.signOut();
        Navigator.pushNamed(context, '/');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("התנתקות"),
      content: Text("?האם תרצה להתנתק"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}



