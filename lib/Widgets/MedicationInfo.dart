import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Model/Medication.dart';
import '../Providers/PillsProvider.dart';
import '../Utils/Utils.dart';

class MedicationInfo extends StatefulWidget {
  final Medication medication;

  // final Medication medication;
  const MedicationInfo({Key? key, required this.medication}) : super(key: key);

  @override
  State<MedicationInfo> createState() => _MedicationInfoState();
}

class _MedicationInfoState extends State<MedicationInfo> {

  //double _right = -550;

  @override
  Widget build(BuildContext context) {
    String header = "Next Medication:";
    final provider = Provider.of<MedicationProvider>(context, listen: false);
    final medication = widget.medication;
    final duration = Duration(milliseconds: 500);
    double _right = provider.panelPosition;

    if (provider.showNext) {
      setState(() {
        header = "Next Medication:";
      });
    } else {
      setState(() {
        header = "Medication:";
      });
    }
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: duration,
            curve: Curves.fastOutSlowIn,
            right: _right,
            //bottom: 10,
            child: Container(
              height: MediaQuery.of(context).size.height -100,
              width: 480,
              padding: EdgeInsets.fromLTRB(60,60,0,60),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(0)),
                boxShadow: [
                  BoxShadow(
                    color: (Colors.grey[300])!,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(-7, 0), // changes position of shadow
                  ),
                ],
              ),
              // Content here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[700],
                    ),
                    overflow: TextOverflow.fade,
                    softWrap: false,

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    medication.name,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    endIndent: 40,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount to take: ",
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            medication.amount,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 80,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "When to take: ",
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            medication.name == "Keep Track of your Medication Here" ?  "":Utils.toTime(medication.startTime),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            medication.name == "Keep Track of your Medication Here" ?  "":Utils.toDate(medication.startTime).substring(0,11),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    endIndent: 40,
                    height: 50,
                  ),
                  SizedBox(height: 20,),
                  Text(
                    "Description: ",
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue[700],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,40,0),
                    child: Text(
                      medication.description == null || medication.description.isEmpty ? "The best preparation for tomorrow is doing your best today.":medication.description,
                      overflow: TextOverflow.fade,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          height: 1.5
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async{
          // Use setState to rebuild the widget with new values.
          provider.setAnim();
          await Future.delayed(duration, (){});
          provider.getNextMedication();
        },
        label: const Text(
          'Next Medication',
          style: TextStyle(fontSize: 30),
        ),
        icon: const Icon(
          Icons.medication,
          size: 40,
        ),
        backgroundColor: Colors.blue[300],
        extendedPadding: EdgeInsets.all(50),
      ),
    );
  }
}
