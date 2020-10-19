import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:set_point_attender/menus/settings_menu.dart';
import 'package:set_point_attender/models/daily_report.dart';
import 'package:set_point_attender/models/database.dart';
import 'package:set_point_attender/settings_and_dialogs/confirm_month_report.dart';
import 'package:set_point_attender/shared/constants.dart';
import 'package:set_point_attender/shared/parse_date.dart';
import 'package:set_point_attender/shared/parse_names.dart';

class MonthlyViewPage extends StatefulWidget {
  @override
  _MonthlyViewPageState createState() => _MonthlyViewPageState();
}

class _MonthlyViewPageState extends State<MonthlyViewPage> {
  bool displayCurrent;
  var status = 'notApproved';

  @override
  void initState() {
    super.initState();
    displayCurrent = true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var rawDate = displayCurrent
        ? DateTime.now()
        : DateTime.now().subtract(Duration(days: 30));
    var currentMonthAndYear = parseRawDateToHebrew(rawDate).substring(3);
    var text = displayCurrent ? "לחודש הקודם" : "לחודש הנוכחי";
    var username = user != null ? user.email.split('@')[0] : '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red[600],
        title: Text('דיווח חודשי סט פוינט בע"מ'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: LogoutBurgerWidget(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("שלום ${employeesToHebrew[username]}",
                    style: TextStyle(fontSize: 24)),
                toggleMonthButton(text)
              ],
            ),
            Text(
              "דיווחים קיימים לחודש: $currentMonthAndYear",
              style:
                  TextStyle(fontSize: 24, decoration: TextDecoration.underline),
            ),
            SizedBox(height: 8),
            StreamBuilder(
              stream: getReportsFromMonth(
                  username, rawDate.toString().substring(0, 7)),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red[200],
                        ),
                        child: Text(
                          "אין דיווחים עבור חודש זה",
                          style: TextStyle(fontSize: 24),
                        )),
                  );
                } else if (snapshot.hasError) {
                  return Text("ERROR");
                } else {
                  var items = createMonthReportList(snapshot);
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items?.length ?? 1,
                      itemBuilder: (context, index) {
                        return Text(items[index].toString(),
                            style: TextStyle(fontSize: 20));
                      });
                }
              },
            ),
            SizedBox(height: 10),
            FutureBuilder<dynamic>(
              future: Database.getApprovalStatus(
                  username, rawDate.toString().substring(0, 7)),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == 'approved' || status == 'approved')
                  return RedCircluarText(
                      text: "תודה הדיווח התקבל",
                      size: 20,
                      fontWeight: FontWeight.bold);
                else
                  return MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.black, width: 3)),
                    height: 70.0,
                    minWidth: 180.0,
                    color: Colors.brown[900],
                    textColor: Colors.white,
                    child: Text(
                      "אישור ושליחה",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      var app = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmMonthReportAlertDialog(
                            username: username,
                            month: rawDate.toString().substring(0, 7)),
                      );
                      if (app) {
                        setState(() {
                          status = 'approved';
                        });
                      }
                    },
                  );
              },
            )
          ],
        ),
      ),
    );
  }

  MaterialButton toggleMonthButton(String text) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.black, width: 3)),
      height: 35.0,
      color: Colors.red[200],
      child: Text(text,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      onPressed: () {
        setState(() {
          displayCurrent = !displayCurrent;
          status = 'notApproved';
        });
      },
    );
  }

  getReportsFromMonth(String username, String text) async* {
    var mapFromServer = await Database.databaseReference
        .child('Employees/$username/$text')
        .once()
        .then((snapshot) {
      return snapshot.value;
    });
    yield mapFromServer;
  }

  createMonthReportList(AsyncSnapshot snapshot) {
    List<DailyReport> monthlyReports = [];
    Map.from(snapshot.data).forEach((date, value) {
      if (date != 'status') {
        List<Report> list = [];
        value.forEach((clientName, value2) {
          value2.forEach((key3, details) {
            list.add(Report.fromSnapshot(clientName, details));
          });
        });
        monthlyReports.add(DailyReport(date: date, activities: list));
      }
    });

// sort that shit
    monthlyReports.sort(DailyReport.dailyReportComparator);
    return monthlyReports;
  }
}
