import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/PillsProvider.dart';
import '../Widgets/MedicationInfo.dart';
import '../Widgets/PillsScheduleWidget.dart';

class PillsReminder extends StatelessWidget {
  const PillsReminder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Medication Reminder"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      body: Row(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 3,

                  child: PillsSchedule()

          ),
          Expanded(
            flex: 2,
              child:Container(
                padding: EdgeInsets.fromLTRB(30,10,0,10),
                  child: MedicationInfo(medication:provider.selectedMedication)
              ),
          ),
        ],
      ),

    );
  }


}
