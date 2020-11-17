import 'package:flutter/material.dart';
import 'package:set_point_attender/models/database.dart';

class ConfirmMonthReportAlertDialog extends StatelessWidget {
  final username;
  final month;
  const ConfirmMonthReportAlertDialog({this.username, this.month, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('לאחר אישור הדיווח החודשי לא ניתן לשנותו',
          style: TextStyle(fontSize: 25)),
      content: Text("האם לאשר?", style: TextStyle(fontSize: 25)),
      actions: [
        FlatButton(
            child: Text('כן', style: TextStyle(fontSize: 22)),
            onPressed: () async {
              await Database.confirmMonthly(username, month);
              Navigator.pop(context, true);
            }),
        FlatButton(
          child: Text('לא', style: TextStyle(fontSize: 22)),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
