import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Model/Event.dart';
import 'package:google_grand_challenge/Pages/EventEditing.dart';
import 'package:google_grand_challenge/Providers/EventProvider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_grand_challenge/Model/EventDataSource.dart';
import 'package:syncfusion_flutter_core/theme.dart';


import '../Utils/Utils.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return Center(
        child: Text(
          "No events found!",
          style: TextStyle(fontSize: 24),
        ),
      );
    }

    return SfCalendarTheme(
      data: SfCalendarThemeData(
        timeTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
      child: SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: EventDataSource(provider.events),
        initialDisplayDate: provider.selectedDate,
        //headerHeight: 0,
        appointmentBuilder: appointmentBuilder,
        selectionDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.3)),
        
        onTap: (details) {
          if (details.appointments == null) return;
          final event = details.appointments!.first;

          eventInfo(event: event);
        },
      ),
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.themeColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                event.location,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  eventInfo({required Event event}) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(event.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'From',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(Utils.toDate(event.startTime) + " "+Utils.toTime(event.startTime)),
                SizedBox(height: 8,),
                Text(
                  'To',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(Utils.toDate(event.endTime) + " "+Utils.toTime(event.endTime)),
                SizedBox(height: 8,),
                Text("Location",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),),
                Text(event.location),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Edit'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EventEditing(event: event,selectedDate: event.startTime)));
              },
            ),
            TextButton(

              child: const Text('Delete',style: TextStyle(color: Colors.red),),
              onPressed: () {
                final provider = Provider.of<EventProvider>(context,listen: false);
                provider.deleteEvent(event);
              },
            ),
          ],
        );
      });
}
