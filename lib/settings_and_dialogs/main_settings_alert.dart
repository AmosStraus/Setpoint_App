import 'package:flutter/material.dart';

class MySettingsAlertDialog extends StatelessWidget {
  const MySettingsAlertDialog({Key key, BuildContext context})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('יציאה'),
      content: Text("?האם תרצה לצאת"),
      actions: [
        FlatButton(
          child: Text('כן'),
          onPressed: () => Navigator.pop(context, true),
        ),
        FlatButton(
          child: Text('לא'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}