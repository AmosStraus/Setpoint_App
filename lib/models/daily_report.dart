import 'package:set_point_attender/shared/parse_names.dart';

class DailyReport {
  String date;
  List<Report> activities;

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
    return '${activityToHebrew(clientName)} - \n התחלה $startTime, סיום $finishTime';
  }
}
