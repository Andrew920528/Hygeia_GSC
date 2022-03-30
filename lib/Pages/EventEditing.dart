import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Model/Event.dart';
import 'package:google_grand_challenge/Utils/Utils.dart';
import 'package:provider/provider.dart';
import 'package:google_grand_challenge/Providers/EventProvider.dart';

import '../Providers/UserInfoProvider.dart';
import 'Appointment.dart';

// This page is for setting time for appointment
class EventEditing extends StatefulWidget {
  final Event? event;
  final DateTime selectedDate;
  const EventEditing({
    Key? key,
    this.event,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _EventEditingState createState() => _EventEditingState();
}

class _EventEditingState extends State<EventEditing> {

  late DateTime startDate;
  late DateTime endDate;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final locationController = TextEditingController();


  @override
  void initState() {

    super.initState();
    // the initial state of start/end time field
    if (widget.event == null) {

      startDate = widget.selectedDate.add(Duration(hours: 13));//DateTime.now();
      endDate = widget.selectedDate.add(Duration(hours: 15));

    }
    else{
      final event = widget.event!;
      titleController.text = event.title;
      startDate = event.startTime;
      endDate = event.endTime;
      locationController.text = event.location;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // title of Appointment
              buildTitle(),
              SizedBox(height: 20),
              // pick time
              buildDateTimePicker(),
              SizedBox(height: 20),
              // choose location
              buildLocation(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: saveForm,
          icon: Icon(Icons.done),
          label: Text("Save"),
        )
      ];


  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "Add Appointment",
        ),
        onFieldSubmitted: (_) => saveForm(),
        validator: (title) =>
            title != null && title.isEmpty ? "Title Cannot Be Empty" : null,
        controller: titleController,
      );
  // builds both start and end date
  Widget buildDateTimePicker() => Column(
        children: [
          buildFrom(),
          buildTo(),
        ],
      );

  Widget buildFrom() => buildHeader(
        header: "FROM",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              // buildDropDownField is a template that shows selected date/time
              child: buildDropDownField(
                text: Utils.toDate(startDate),
                // allows pick date
                onClicked: () => pickStartDate(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropDownField(
                text: Utils.toTime(startDate),
                // allows pick time
                onClicked: () => pickStartDate(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: "To",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: Utils.toDate(endDate),
                onClicked: () => pickEndDate(pickDate: true),
              ),
            ),
            Expanded(
              child: buildDropDownField(
                text: Utils.toTime(endDate),
                onClicked: () => pickEndDate(pickDate: false),
              ),
            ),
          ],
        ),
      );

  Widget buildDropDownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          child,
        ],
      );

  // returns the start picked date/time
  Future pickStartDate({required bool pickDate}) async {
    final date = await pickDateTime(startDate, pickDate: pickDate);
    if(date == null) return;
    
    if(date.isAfter(endDate)) {

      endDate = DateTime(date.year,date.month,date.day, endDate.hour,endDate.minute);
      if (date.isAfter(endDate)){
        endDate = date.add(Duration(hours: 2));
      }
    }
    setState(() {
      startDate = date;
    });
  }

  // returns the picked end date/time
  Future pickEndDate({required bool pickDate}) async {
    final date = await pickDateTime(
      endDate,
      pickDate: pickDate,
      firstDate: pickDate ? startDate : null,
    );
    if(date == null) return;
    if (!date.isAfter(startDate)){
      startDate = date.subtract(Duration(hours: 2));
    }
    setState(() {
      endDate = date;
    });
  }

  // does the picking
  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2020, 1, 1),
        lastDate: DateTime(2120),
      );

      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Future saveForm() async{
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final event = Event(
        title: titleController.text,
        startTime: startDate,
        endTime: endDate,
        location: locationController.text,
      );

      final isEditing = widget.event != null;

      final provider = Provider.of<EventProvider>(context,listen: false);
      final userInfoProvider = Provider.of<UserInfoProvider>(context,listen: false);

      if(isEditing){
        provider.editEvent(event,widget.event!);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
               Calendar()));

      }
      else{
        provider.addEvent(userInfoProvider.userID,event);
      }


      Navigator.of(context).pop();
    }
  }

  Widget buildLocation() => TextFormField(
    maxLines: 5,
    style: TextStyle(fontSize: 18),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      hintText: "Add Location",
    ),
    onFieldSubmitted: (_) => saveForm(),
    controller: locationController,



  );
}

