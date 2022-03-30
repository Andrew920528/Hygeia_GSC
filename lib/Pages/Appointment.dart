import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Pages/EventEditing.dart';


import 'package:google_grand_challenge/Widgets/CalendarWidget.dart';
import 'package:google_grand_challenge/Providers/EventProvider.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10.0,60.0,0.0,60.0),
        child: CalendarWidget(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 20,
            right: 60,
            child: Container(
              height: 80,
              width: 80,
              child: FloatingActionButton(
                heroTag: "btn1",
                child: Icon(
                  Icons.add,
                  size: 60,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EventEditing(selectedDate: provider.selectedDate)),
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}

