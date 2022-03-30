import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Model/Medication.dart';
import '../Pages/Notification.dart';
class MedicationProvider extends ChangeNotifier{

  Duration duration = Duration(milliseconds: 300);
  double panelPosition = 0;
  bool hasFetched = false;
  List<Medication> _medications = [];
  bool showNext = true;
  List<Medication> get medications => _medications;
  Medication selectedMedication = Medication(
      name: "Keep Track of your Medication Here",
      startTime:DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: 30)),
      description: "",
      recurrenceRule: "",
      amount: "",
  );

  void addMedication(Medication medication){
    _medications.add(medication);
    notifyListeners();
  }
  void selectNewMedicationInfo(Medication medication){
    selectedMedication = medication;
    showNext = false;
    notifyListeners();
  }
  void getNextMedication(){
    // TODO check recurrence rule too
    Medication temp = Medication(
      name: "Keep Track of your Medication Here",
      startTime:DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: 30)),
      description: "",
      recurrenceRule: "",
      amount: "",
    );
    DateTime now = DateTime.now();
    Duration minDur = now.difference(DateTime.utc(2020, 1, 5));//DateTime.utc(2020, 1, 5).difference(now);
    for(Medication m in _medications){
      if(m.endTime.isAfter(now)){
        Duration duration;
        // late.difference(early) => positive value
        if(m.startTime.isAfter(now)){
          duration = m.startTime.difference(now);
        } else{
          duration = now.difference(m.startTime);
        }
        // if minDur is longer than duration
        if (minDur > duration){
          minDur = duration;
          temp = m;
        }
      }
    }
    selectedMedication = temp;
    showNext = true;
    notifyListeners();
  }
  void setAnim()async{
      panelPosition =-520;
      notifyListeners();
      await Future.delayed(duration, (){});
      panelPosition = 0;
      notifyListeners();
  }

  void hasFetch(){
    this.hasFetched = true;
    notifyListeners();
  }

  void clearList(){
    _medications = [];
    hasFetched = false;
    notifyListeners();
  }

  void setNotification(){
    NotificationAPI.showNotification(
      id: 66,
      title: "Next Medication",
      body: "Your new Medication reminder",
      payload: "payload"
    );
    for(int i=0; i<_medications.length; i++){

      Medication m = _medications[i];
      if(m.recurrenceRule!=null){
        RecurrenceProperties recurrenceProperties =
        SfCalendar.parseRRule(m.recurrenceRule!, m.startTime);
        int id = i;
        String? title = m.name;
        String? body = "New Medication reminder";
        String? payload = id.toString();
        DateTime scheduledDate = m.startTime;
        int hour = scheduledDate.hour;
        int minute = scheduledDate.minute;
        Duration interval = Duration(days: 1);

        switch(recurrenceProperties.recurrenceType){
          case RecurrenceType.daily:
            interval = Duration(days: recurrenceProperties.interval);
            break;
          case RecurrenceType.weekly:
            interval = Duration(days: 7*recurrenceProperties.interval);
            break;
        }

        NotificationAPI.showScheduledNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
          hour: hour,
          minute: minute,
          interval: interval,
        );
      }
    }

  }

}