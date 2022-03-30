import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Pages/EventEditing.dart';
import 'package:google_grand_challenge/Providers/EventProvider.dart';
import 'package:provider/provider.dart';

// import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_grand_challenge/Model/EventDataSource.dart';
import 'package:google_grand_challenge/Widgets/TasksWidget.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
      dataSource: EventDataSource(events),
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(),
        );
      },
      onTap: (CalendarTapDetails details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
      },
      monthViewSettings: MonthViewSettings(
        showAgenda: true,
        agendaViewHeight: 200,
        numberOfWeeksInView: 5,
      ),
    );
  }
}
