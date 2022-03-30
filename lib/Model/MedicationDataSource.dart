import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:google_grand_challenge/Model/Medication.dart';

class MedicationDataSource extends CalendarDataSource<Medication>{
  MedicationDataSource(List<Medication>appointments){
    this.appointments = appointments;
  }

  Medication getMedication(int index) => appointments![index] as Medication;

  @override
  DateTime getStartTime(int index) => getMedication(index).startTime;

  @override
  DateTime getEndTime(int index) => getMedication(index).endTime;

  @override
  String getSubject(int index) => getMedication(index).name;// + getMedication(index).amount;

  @override
  String? getRecurrenceRule(int index) => getMedication(index).recurrenceRule;
  // appointments![index].recurrenceRule;
  @override
  Medication convertAppointmentToObject(Medication customData, Appointment appointment) {
    return Medication(
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        name: appointment.subject,
        amount: customData.amount,
    );
  }


}