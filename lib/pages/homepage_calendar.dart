import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  String clientType;
  bool changedFormField;
  bool loading;
  String currentValueFromDropdown;
  DateTime currentDate;
  TimeOfDay startTime;
  TimeOfDay finishTime;

  @override
  void initState() {
    super.initState();
    clientType = "";
    changedFormField = false;
    loading = false;
    currentValueFromDropdown = "";
    currentDate = DateTime.now();
    startTime = null;
    finishTime = null;
  }

  void resetForm() {
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
  Widget build(BuildContext contextMain) {
    final user = Provider.of<User>(contextMain);
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () => showDialog<bool>(
              context: contextMain,
              builder: (contextMain) =>
                  MySettingsAlertDialog(context: contextMain),
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
                  if (currentValueFromDropdown == "אחר" && clientType == "אחר")
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 25,
                          ),
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                                style: TextStyle(fontSize: 24),
                                autofocus: true,
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'שם לקוח')),
                            suggestionsCallback: (pattern) {
                              return getSuggestions(pattern);
                            },
                            itemBuilder: (_, suggestion) {
                              return Text(suggestion,
                                  style: TextStyle(fontSize: 24));
                            },
                            noItemsFoundBuilder: (_) {
                              return Text('אנא מלא שם תקין',
                                  style: TextStyle(fontSize: 18));
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                currentValueFromDropdown = suggestion;
                                clientType =
                                    clientAndTypeToEnglish(suggestion)[1];
                                changedFormField = true;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  else
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
                    future: Database.getApprovalStatus(
                        user?.email?.split('@')?.elementAt(0),
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
                            if (clientType == "")
                              ClientTypeMenu(updateParent: updateClientType)
                            else
                              dropDownChoose(clientType,
                                  user?.email?.split('@')?.elementAt(0)),
                            Divider(
                              color: Colors.black,
                              height: 5,
                              thickness: 2,
                            ),
                            if (currentValueFromDropdown != "" &&
                                clientType != "" &&
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
                            else if (clientType != "" &&
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
                                                  " ${(currentValueFromDropdown == "אחר" ? clientType : "")}",
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
                                      print(clientType);

                                      await Database.updateDatabase(
                                        user?.email?.split('@')?.elementAt(0),
                                        currentDate.toString(),
                                        clientType,
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

                                      Navigator.of(contextMain)
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

  Widget dropDownChoose(String clientType, String username) {
    if (!changedFormField)
      return MyDropDown(
          updateParent: valueFromDropDown,
          currentValue: currentValueFromDropdown,
          client: clientType,
          username: username);
    else
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "$currentValueFromDropdown:",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(width: 20),
          RaisedButton.icon(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            color: Colors.grey[300],
            label: Text("להחלפה", style: TextStyle(fontSize: 18.0)),
            icon: Icon(Icons.call_split),
            onPressed: () {
              setState(() {
                valueFromDropDown("", reset: true);
              });
            },
          ),
        ],
      );
  }

  Widget formHeader(User user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "שלום ${employeesToHebrew[user?.email?.split('@')?.elementAt(0)]}",
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
        clientType = "";
        currentValueFromDropdown = "";
        startTime = null;
        finishTime = null;
      }
    });
  }

  updateClientType(String k) {
    setState(() {
      clientType = k;
    });
  }
}
