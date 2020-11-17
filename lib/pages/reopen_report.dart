import 'package:flutter/material.dart';
import 'package:set_point_attender/menus/settings_menu.dart';
import 'package:set_point_attender/models/database.dart';
import 'package:set_point_attender/shared/parse_names.dart';

class ReopenReport extends StatefulWidget {
  @override
  _ReopenReportState createState() => _ReopenReportState();
}

class _ReopenReportState extends State<ReopenReport> {
  String employeeInHebrew = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: LogoutBurgerWidget(),
          ),
        ],
        title: Text("פתיחה מחדש של דיווח"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "פתיחה מחדש של דיווח חודשי",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            DropdownButton<String>(
              value: employeeInHebrew,
              iconSize: 22,
              style: TextStyle(color: Colors.black, fontSize: 22.0),
              underline: Container(height: 2, color: Colors.black),
              items: getItems(),
              onChanged: (String value) {
                setState(() {
                  employeeInHebrew = value;
                });
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
              child: Text("לחודש הזה",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Database.openMonth(employeesToEnglish[employeeInHebrew],
                    DateTime.now().toString().substring(0, 7));
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
                "לחודש הקודם",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Database.openMonth(
                    employeesToEnglish[employeeInHebrew],
                    DateTime.now()
                        .subtract(Duration(days: 30))
                        .toString()
                        .substring(0, 7));
              },
            ),
          ],
        ),
      ),
    );
  }

  getItems() {
    return employeesToHebrew.values.map((employee) {
      return DropdownMenuItem(
        value: employee,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(employee, textAlign: TextAlign.start),
            ),
            Divider(color: Colors.black),
          ],
        ),
      );
    }).toList();
  }
}
