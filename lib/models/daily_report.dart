import 'package:set_point_attender/shared/parse_names.dart';

class DailyReport {
  String date;
  List<Report> activities;

  static int dailyReportComparator(a, b) {
    int first = 0;
    int second = 0;
    if (a.date[8] == '0') {
      first = int.parse(a.date.substring(9, 10));
    } else {
      first = int.parse(a.date.substring(8, 10));
    }
    if (b.date[8] == '0') {
      second = int.parse(b.date.substring(9, 10));
    } else {
      second = int.parse(b.date.substring(8, 10));
    }
    return first - second;
  }

  DailyReport({this.activities, this.date}) {
    activities.sort((a, b) {
      return num.parse(a.startTime.split(':')[0]) -
          int.parse(b.startTime.split(':')[0]);
    });
  }

  @override
  String toString() {
    String activitiesToStr = "";
    for (var activity in activities) {
      activitiesToStr += '\n' + '    ' + activity.toString();
    }
    return '\nתאריך:     $date\nדיווחים: $activitiesToStr';
  }
}

class Report {
  String clientName;
  String workingTime;
  String startTime;
  String finishTime;
  Report({this.clientName, this.startTime, this.finishTime, this.workingTime});

  Report.fromSnapshot(clientName, details) {
    this.clientName = clientName.toString();
    this.workingTime = details['worked'].toString();
    this.startTime = details['start'].toString();
    this.finishTime = details['finish'].toString();
  }

  @override
  String toString() {
    return '${clientAndTypeToHebrew(clientName)[0]} - \n התחלה $startTime, סיום $finishTime';
  }
}
