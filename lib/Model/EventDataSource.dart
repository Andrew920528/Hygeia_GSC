import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_grand_challenge/Model/Event.dart';

class EventDataSource extends CalendarDataSource{
  EventDataSource(List<Event>appointments){
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) => getEvent(index).startTime;

  @override
  DateTime getEndTime(int index) => getEvent(index).endTime;

  @override
  String getSubject(int index) => getEvent(index).title;

  @override
  String getLocation(int index) => getEvent(index).location;
}