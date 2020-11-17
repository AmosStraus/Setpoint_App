import 'package:flutter/material.dart';

class MySettingsAlertDialog extends StatelessWidget {
  const MySettingsAlertDialog({Key key, BuildContext context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('יציאה', style: TextStyle(fontSize: 22)),
      content: Text("?האם תרצה לצאת", style: TextStyle(fontSize: 22)),
      actions: [
        FlatButton(
          child: Text('כן', style: TextStyle(fontSize: 22)),
          onPressed: () => Navigator.pop(context, true),
        ),
        FlatButton(
          child: Text('לא', style: TextStyle(fontSize: 22)),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
