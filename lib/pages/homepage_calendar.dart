import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:set_point_attender/menus/client_type_menu.dart';
import 'package:set_point_attender/menus/mydropdown.dart';
import 'package:set_point_attender/menus/settings_menu.dart';
import 'package:set_point_attender/models/database.dart';
import 'package:set_point_attender/models/date_picker.dart';
import 'package:set_point_attender/settings_and_dialogs/main_settings_alert.dart';
import 'package:set_point_attender/shared/constants.dart';
import 'package:set_point_attender/shared/parse_date.dart';
import 'package:set_point_attender/shared/parse_names.dart';

class HomePageCalendar extends StatefulWidget {
  HomePageCalendar({Key key}) : super(key: key);

  @override
  _HomePageCalendarState createState() => _HomePageCalendarState();
}

class _HomePageCalendarState extends State<HomePageCalendar> {
  String client;
  bool loading;
  String currentValueFromDropdown;
  String otherValue;
  DateTime currentDate;
  TimeOfDay startTime;
  TimeOfDay finishTime;

  @override
  void initState() {
    super.initState();
    client = "";
    loading = false;
    currentValueFromDropdown = "";
    currentDate = DateTime.now();
    startTime = null;
    finishTime = null;
  }

  void resetForm() {
    Database.pushEmployeePermissions();
    // print(Database.getEmployeePermissions('arye', 'Kibbutzim'));
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return HomePageCalendar();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () => showDialog<bool>(
              context: context,
              builder: (context) => MySettingsAlertDialog(context: context),
            ),
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.red[600],
                title: Text('סט פוינט בע"מ'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: LogoutBurgerWidget(),
                  ),
                ],
              ),
              body: ListView(
                children: [
                  // HEADER //
                  formHeader(user),
                  Divider(
                    color: Colors.black,
                    height: 5,
                    thickness: 2,
                  ),
                  Column(
                    children: [
                      MyDatePicker(currentDate, dateFromPicker),
                      Divider(
                        color: Colors.black,
                        height: 5,
                        thickness: 2,
                      ),
                    ],
                  ),
                  FutureBuilder<dynamic>(
                    future: Database.getApprovalStatus(user.email.split('@')[0],
                        currentDate.toString().substring(0, 7)),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == 'approved')
                        return RedCircluarText(
                            text:
                                "   כבר דיווחת על חודש זה \nלשינוי פנה/י לגפנית או אריה",
                            size: 20,
                            fontWeight: FontWeight.bold);
                      else
                        return ListView(
                          shrinkWrap: true,
                          children: [
                            if (client == "")
                              ClientTypeMenu(updateParent: updateClientType)
                            else
                              dropDownChoose(client, user.email.split('@')[0]),
                            Divider(
                              color: Colors.black,
                              height: 5,
                              thickness: 2,
                            ),
                            if (currentValueFromDropdown == "אחר" &&
                                client == "אחר")
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 25,
                                    ),
                                    child: TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          hintText: "הכנס/י את שם הפעילות"),
                                      style: TextStyle(fontSize: 20.0),
                                      onChanged: (value) =>
                                          setState(() => otherValue = value),
                                    ),
                                  ),
                                  RaisedButton(
                                    child: Text("אשר"),
                                    onPressed: () {
                                      if (otherValue != '') {
                                        setState(() {
                                          currentValueFromDropdown = otherValue;
                                          client = otherValue;
                                        });
                                      }
                                    },
                                  )
                                ],
                              ),
                            if (currentValueFromDropdown != "" &&
                                client != "" &&
                                currentValueFromDropdown != "אחר")
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  buildHourDialButtons(context, true),
                                  buildHourDialButtons(context, false),
                                ],
                              ),
                            if (!isValidHourReport(startTime, finishTime))
                              Center(
                                child: Text(
                                  "${(startTime != null && finishTime != null) ? "יש להזין זמנים תקינים" : ""}",
                                  style: TextStyle(
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              )
                            else if (client != "" &&
                                currentValueFromDropdown != "")
                              Column(
                                children: [
                                  Divider(
                                    color: Colors.black,
                                    height: 5,
                                    thickness: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.red[200],
                                      ),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "$currentValueFromDropdown" +
                                                  " ${(currentValueFromDropdown == "אחר" ? client : "")}",
                                              style: TextStyle(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                            Text(
                                              "${parseRawDateToHebrew(currentDate)}",
                                              style: TextStyle(fontSize: 24),
                                              textAlign: TextAlign.right,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "מ ${startTime?.format(context) ?? ""}",
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                  textAlign: TextAlign.right,
                                                ),
                                                Text(
                                                  "עד  ${finishTime?.format(context) ?? ""}",
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                  textAlign: TextAlign.right,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        side: BorderSide(
                                            color: Colors.black, width: 3)),
                                    height: 75.0,
                                    minWidth: 220.0,
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
                                      setState(() {
                                        loading = true;
                                      });

                                      await Database.updateDatabase(
                                        user.email.split('@')[0],
                                        currentDate.toString(),
                                        client,
                                        currentValueFromDropdown,
                                        double.parse(
                                            workingTime(startTime, finishTime)),
                                        startTime,
                                        finishTime,
                                      );
                                      setState(
                                        () {
                                          loading = false;
                                        },
                                      );

                                      Navigator.of(context)
                                          .pushNamed('/finished');
                                    },
                                    splashColor: Colors.redAccent,
                                  ),
                                ],
                              ),
                          ],
                        );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Row buildHourDialButtons(BuildContext context, bool start) {
    return Row(
      children: [
        if (start)
          Text("התחלה:",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline))
        else
          Text("סיום:",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)),
        SizedBox(width: 5),
        RaisedButton(
          child: Text(
              "${start ? startTime?.format(context) ?? "הזן" : finishTime?.format(context) ?? "הזן"}",
              style: TextStyle(fontSize: 22)),
          onPressed: () {
            var remainder15 = TimeOfDay.now().minute % 5;
            if (start) remainder15 += 180;
            showIntervalTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(
                  DateTime.now().subtract(Duration(minutes: remainder15))),
              interval: 5,
              visibleStep: VisibleStep.Fifths,
              builder: (BuildContext context, Widget child) {
                return Localizations.override(
                    context: context,
                    locale: const Locale('he', 'IL'),
                    child: child);
              },
            ).then((value) {
              setState(() {
                if (start) {
                  startTime = value;
                } else {
                  finishTime = value;
                }
              });
            });
          },
        ),
      ],
    );
  }

  Widget dropDownChoose(String client, String username) {
    return MyDropDown(
        updateParent: valueFromDropDown,
        currentValue: currentValueFromDropdown,
        client: client,
        username: username);
  }

  Widget formHeader(User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "שלום ${employeesToHebrew[user.email.split('@')[0]]}",
            style: TextStyle(fontSize: 24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "רישום שעות",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              FlatButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide()),
                color: Colors.grey[400],
                onPressed: () {
                  setState(() {
                    resetForm();
                  });
                },
                icon: Icon(Icons.refresh),
                label: Text(
                  "איפוס טופס",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  dateFromPicker(DateTime d) {
    setState(() {
      currentDate = d;
    });
  }

  valueFromDropDown(String k, {bool reset = false}) {
    setState(() {
      currentValueFromDropdown = k;
      if (reset) {
        client = "";
        currentValueFromDropdown = "";
        startTime = null;
        finishTime = null;
      }
    });
  }

  updateClientType(String k) {
    setState(() {
      client = k;
    });
  }
}
