import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_grand_challenge/main.dart';
import 'package:provider/provider.dart';

import '../Model/Event.dart';
import '../Model/Medication.dart';
import '../Providers/EventProvider.dart';
import '../Providers/PillsProvider.dart';
import '../Providers/UserInfoProvider.dart';
import '../Utils/Utils.dart';
import 'logOutPage.dart';
class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final inputPhoneNumber = TextEditingController();

  bool isChecking = false;
  @override
  Widget build(BuildContext context) {
    final userInfoProvider = Provider.of<UserInfoProvider>(
        context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Log In"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        leading: CloseButton(),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,

            child: TextFormField(
                controller: inputPhoneNumber,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Enter Phone Number",
                  suffixIcon: isChecking ? Transform.scale(
                      scale: 0.5, child: CircularProgressIndicator()) : null,
                ),
                validator: (number) {
                  // print("validating: " + userInfoProvider.validationMessage.toString());
                  return userInfoProvider.validationMessage;

                }
            ),
          ),
      ),

      floatingActionButton: FloatingActionButton.extended(

        onPressed: () {
          saveForm();
        },
        icon: Icon(Icons.check,size: 50,),
        label: Text("Log in",style: TextStyle(fontSize: 30),),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  // saves the form
  Future saveForm() async {
    final userInfoProvider = Provider.of<UserInfoProvider>(
        context, listen: false);
    // print("submit form");
    setState(() {
      isChecking = true;
    });
    await userInfoProvider.checkPhone(inputPhoneNumber.text);
    setState(() {
      isChecking = false;
    });
    if (_formKey.currentState!.validate()) {
      // showWelcome();
      await getUserInfo(userInfoProvider);
      streamController.add(true);
      Navigator.pop(context);
      logOutPagePopUp(context);

    }
    else {
      return;
    }
  }
  Future<void> getUserInfo(UserInfoProvider userInfoProvider) async {
    final docID = userInfoProvider.userID;
    final result = await FirebaseFirestore.instance.collection('Patients').doc(docID).get();
    getName(result);
    getMedications(result);
    getAppointments(result);
  }

  getName(DocumentSnapshot<Map<String, dynamic>> result) async {
    final provider = Provider.of<UserInfoProvider>(context,listen: false);
    final String name = result['patient_info']['name'];
    provider.setName(name);
  }

  getMedications(DocumentSnapshot<Map<String, dynamic>> result) async {
    final provider = Provider.of<MedicationProvider>(context,listen: false);

    if(!provider.hasFetched) {
      for(int i=0;i< result['medications'].length; i++){
        Map<String,dynamic> m = result['medications'][i];
        // print(result['medications'][i]);
        Medication medication = Utils.convertMapToMedication(m);
        provider.addMedication(medication);
        // set up notification
        provider.setNotification();
      }
      provider.hasFetch();
    }
  }
  getAppointments(DocumentSnapshot<Map<String, dynamic>> result) async {
    final provider = Provider.of<EventProvider>(context,listen: false);

    if(!provider.hasFetched) {
      for(int i=0;i< result['appointments'].length; i++){
        Map<String,dynamic> a = result['appointments'][i];
        // print(result['medications'][i]);
        Event event = Utils.convertMapToAppointment(a);
        provider.getEvent(event);
      }
      provider.hasFetch();
    }
  }

  logOutPagePopUp(BuildContext context) {
    // final provider = Provider.of<UserInfoProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                height: MediaQuery.of(context).size.height*0.6,
                width: MediaQuery.of(context).size.width*0.6,
                child: LogOutPage()
            ), //ContactListPopUp(),
          );
        });
  }


}