import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_grand_challenge/Pages/PillsReminder.dart';
import 'package:provider/provider.dart';

import 'Model/Medication.dart';
import 'Providers/PillsProvider.dart';
class BackendInfo extends StatefulWidget {
  const BackendInfo({Key? key}) : super(key: key);

  @override
  _BackendInfoState createState() => _BackendInfoState();
}

class _BackendInfoState extends State<BackendInfo> {
  final docId = 'y4KlXiXIs0dWpy9mUMS5';

  @override
  Widget build(BuildContext context) {
    testFireStore();
    // final provider = Provider.of<MedicationProvider>(context,listen: false);
    // CollectionReference patients = FirebaseFirestore.instance.collection('Patients');
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    PillsReminder()
            ),
          );
        },
      ),
    );
        // FutureBuilder(
        //     future: patients.doc(docId).get(),
        //     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        //       return Scaffold(
        //           body: Center(child: Text(data.toString(),))
        //       );
        //     }
        //
        // );
  }

  testFireStore() async {
    final result = await FirebaseFirestore.instance.collection('Patients').doc(docId).get();
    final provider = Provider.of<MedicationProvider>(context,listen: false);
    print(result['medications']);
    for(int i=0;i< result['medications'].length; i++){
      Map<String,dynamic> m = result['medications'][i];
      print(result['medications'][i]);
       // convertMapToMedication(m);
      Medication medication = convertMapToMedication(m);
      provider.addMedication(medication);
    }
  }

  Medication convertMapToMedication(Map<String,dynamic> m){
      String name = m['name'].toString();
      // String st = m['startTime'].toString();
      DateTime startTime = DateTime.parse(m['startTime'].toString());
      String description = m['description'].toString();
      String recurrenceRule = m['recurrenceRule'].toString();
      String amount = m['amount'].toString();
      // print(st);
      Medication medication = new Medication(
        name: name,
        startTime: startTime,
        endTime: startTime.add(Duration(minutes: 20)),
        description: description,
        recurrenceRule: recurrenceRule,
        amount: amount,
      );

      return medication;
   }
}
