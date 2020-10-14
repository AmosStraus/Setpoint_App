import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  final Function(DateTime d) updateFormDate;
  final DateTime currentFromParent;
  MyDatePicker(this.currentFromParent, this.updateFormDate, {Key key})
      : super(key: key);

  @override
  _MyDatePickerState createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DatePickerController _controller;

  // DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _controller = DatePickerController();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _controller.animateToDate(widget.currentFromParent));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      color: Colors.blueGrey[100],
      child: DatePicker(
        DateTime.now().subtract(Duration(days: 28)),
        width: 80,
        height: 110,
        controller: _controller,
        initialSelectedDate: widget.currentFromParent,
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        daysCount: 31,
        dateTextStyle: TextStyle(fontSize: 28),
        monthTextStyle: TextStyle(fontSize: 14),
        dayTextStyle: TextStyle(fontSize: 20),
        onDateChange: (date) {
          setState(() {
            // _currentDate = date;
            widget.updateFormDate(date);
            _controller.animateToDate(date);
          });
        },
        locale: "he",
      ),
    );
  }
}
