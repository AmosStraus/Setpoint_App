import 'package:flutter/material.dart';
import 'package:set_point_attender/models/database.dart';
import 'package:set_point_attender/shared/constants.dart';
import 'package:set_point_attender/shared/parse_names.dart';

class MyDropDown extends StatefulWidget {
  final Function(String k, {bool reset}) updateParent;
  final String currentValue;
  final String client;
  final String username;
  MyDropDown(
      {this.updateParent,
      this.currentValue,
      this.client,
      this.username,
      Key key})
      : super(key: key);

  @override
  _MyDropDownState createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    if (!["קיבוץ", "פרוייקט", "אחר", "חברה"].contains(widget.client)) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${widget.client}",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20),
            buildResetButton(),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${widget.client}:",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(width: 20),
            buildResetButton(),
          ],
        ),
        Center(
          child: FutureBuilder(
            future: getItems(widget.username),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text("אין לך הרשאות לכך");
              } else if (!snapshot.hasData) {
                return SimpleLoading();
              } else
                print(widget.currentValue);
              return DropdownButton<String>(
                value: widget.currentValue,
                iconSize: 22,
                style: TextStyle(color: Colors.black, fontSize: 22.0),
                underline: Container(height: 2, color: Colors.black),
                items: snapshot.data,
                onChanged: (String value) {
                  widget.updateParent(value);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  RaisedButton buildResetButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      color: Colors.grey[300],
      label: Text("להחלפה", style: TextStyle(fontSize: 18.0)),
      icon: Icon(Icons.call_split),
      onPressed: () {
        setState(() {
          widget.updateParent("", reset: true);
        });
      },
    );
  }

  Future<List<DropdownMenuItem<String>>> getItems(username) async {
    List<String> permissions = await Database.getEmployeePermissions(
        username, clientTypeToEnglish(widget.client));

    permissions.sort((a, b) => a.compareTo(b));
    return permissions.map((String client) {
      return DropdownMenuItem(
        value: client,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(client, textAlign: TextAlign.start),
            ),
            Divider(color: Colors.black),
          ],
        ),
      );
    }).toList();
  }
}
