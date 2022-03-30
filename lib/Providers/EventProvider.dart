import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Model/Event.dart';

class EventProvider extends ChangeNotifier{
  bool hasFetched = false;
  List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  List<Event> get eventsOfSelectedDate => _events;

  void setDate(DateTime date) => _selectedDate = date;

  void addEvent(String docID, Event event){
    if(event.location == null || event.location.isEmpty){
      event.location = "Location Unspecified";
    }

    _events.add(event);
    pushEvent(docID, event);
    notifyListeners();
  }

  void getEvent(Event event){
    if(event.location == null || event.location.isEmpty){
      event.location = "Location Unspecified";
    }
    _events.add(event);
    notifyListeners();
  }

  Future<void>pushEvent(String docID, Event event){

    CollectionReference users = FirebaseFirestore.instance.collection('Patients');
    // convertEventToMap(event);
    Map<String,dynamic> new_appointment = convertEventToMap(event);
    var new_appointment_list = [new_appointment];
    return users
        .doc(docID)
        .update({'appointments':  FieldValue.arrayUnion(new_appointment_list)})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }

  void editEvent(Event event, Event oldEvent){
    final index = _events.indexOf(oldEvent);
    _events[index] = event;

    notifyListeners();
  }

  void deleteEvent(Event event){
    _events.remove(event);
    notifyListeners();
  }

  Map<String, dynamic> convertEventToMap(Event event) {
    Map <String,dynamic> output = {
      "title" : event.title,
      "startTime" : event.startTime.toString(),
      "endTime" : event.endTime.toString(),
      "location" : event.location,
    };
    return output;

  }
  void hasFetch(){
    this.hasFetched = true;
    notifyListeners();
  }
  void clearList(){
    _events = [];
    hasFetched = false;
    notifyListeners();
  }

}
