import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Model/MedicationDataSource.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Providers/PillsProvider.dart';
class PillsSchedule extends StatefulWidget {
  const PillsSchedule({Key? key}) : super(key: key);

  @override
  State<PillsSchedule> createState() => _PillsScheduleState();
}

class _PillsScheduleState extends State<PillsSchedule> {
  @override

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicationProvider>(context,listen: false);
    //provider.getNextMedication();

    return SfCalendar(
      // backgroundColor: Colors.transparent,

      view: CalendarView.day,
      dataSource: MedicationDataSource(provider.medications),//medications),
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeIntervalHeight: 100,
      ),
      appointmentTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.white,
          letterSpacing: 5,
          fontWeight: FontWeight.bold
      ),
      onTap: (CalendarTapDetails details) async{
        if (details.appointments == null) return;

        final medication = details.appointments!.first;
        provider.setAnim();
        await Future.delayed(provider.duration, (){});
        provider.selectNewMedicationInfo(medication);

       },

    );
  }


}
