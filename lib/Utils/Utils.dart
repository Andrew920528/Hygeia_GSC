import 'package:intl/intl.dart';

import '../Model/Event.dart';
import '../Model/Medication.dart';

class Utils{
  static toDate(DateTime dateTime){
    final date = DateFormat.yMMMEd().format(dateTime);
    return "$date";
  }

  static toTime(DateTime dateTime){
    final time = DateFormat.Hm().format(dateTime);
    return "$time";
  }

  static Medication convertMapToMedication(Map<String,dynamic> m){
    String name = m['name'].toString();
    // String st = m['startTime'].toString();
    DateTime startTime = DateTime.parse(m['startTime'].toString());
    String description = m['description'].toString();
    String recurrenceRule = m['recurrenceRule'].toString();
    String amount = m['amount'].toString();
    // print(st);
    Medication medication = new Medication(
      name: name,
      startTime: startTime,
      endTime: startTime.add(Duration(minutes: 20)),
      description: description,
      recurrenceRule: recurrenceRule,
      amount: amount,
    );

    return medication;
  }


  static Event convertMapToAppointment(Map<String,dynamic> a){
    String title = a['title'].toString();
    DateTime startTime = DateTime.parse(a['startTime'].toString());
    DateTime endTime = DateTime.parse(a['endTime'].toString());
    String location = a['location'].toString();

    Event event = new Event(
      title: title,
      startTime: startTime,
      endTime: endTime,
      location: location,
    );

    return event;
  }
}
