import 'package:flutter/material.dart';
import 'package:set_point_attender/models/auth.dart';
import 'package:set_point_attender/shared/parse_names.dart';

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
            // Navigator.of(context).pop();
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
          case 'פתיחת דיווח לעובד':
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/reOpenReport');

            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'דף ראשי',
            child: Text(
              'דף ראשי',
              style: TextStyle(fontSize: 22),
            ),
          ),
          PopupMenuItem<String>(
            value: 'דיווח חודשי',
            child: Text(
              'דיווח חודשי',
              style: TextStyle(fontSize: 22),
            ),
          ),
          PopupMenuItem<String>(
            value: 'התנתקות',
            child: Text(
              'התנתקות',
              style: TextStyle(fontSize: 22),
            ),
          ),
          if (authorized.contains(_auth.getUser?.email))
            PopupMenuItem<String>(
              value: 'פתיחת דיווח לעובד',
              child: Text(
                'פתיחת דיווח לעובד',
                style: TextStyle(fontSize: 22),
              ),
            )
        ];
      },
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("לא", style: TextStyle(fontSize: 22)),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("כן", style: TextStyle(fontSize: 22)),
      onPressed: () async {
        await _auth.signOut();
        Navigator.pop(context, true);
        Navigator.pop(context);
        Navigator.pushNamed(context, '/');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("התנתקות", style: TextStyle(fontSize: 22)),
      content: Text("?האם תרצה להתנתק", style: TextStyle(fontSize: 22)),
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
