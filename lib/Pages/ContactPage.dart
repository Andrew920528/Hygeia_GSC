import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Pages/ContactListPopUp.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);
  static const buttonHeight = 460.0;
  static const buttonWeight = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // button 1
              customButton(
                onPressed: () {
                  emergencyCallPopUp(context);
                },
                text: "Emergency",
                icon: Icons.error,
                color: Colors.red[300],
              ),

              // button 2
              customButton(
                onPressed: () {
                  doctorCallPopUp(context);
                },
                text: "Doctor",
                icon: Icons.health_and_safety,
                color: Colors.lightGreen,
              ),

              // button 2
              customButton(
                onPressed: () {
                  familyCallPopUp(context);
                },
                text: "Friends and Family",
                icon: Icons.child_care,
                color: Colors.blue[300],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget customButton(
          {required onPressed, required text, required icon, required color}) =>
      SizedBox(
        height: ContactPage.buttonHeight,
        width: ContactPage.buttonWeight,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              elevation: 7,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 90,
                ),
                Icon(
                  icon,
                  size: 100,
                ),
                SizedBox(
                  height: 90,
                ),
                Text(
                  text,
                  style: TextStyle(fontSize: 40),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      );

  emergencyCallPopUp(BuildContext context) {
    final number = "911";
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: EdgeInsets.fromLTRB(110,60,110,20),
              actionsPadding: EdgeInsets.all(30),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[400],size: 150,),
                  SizedBox(height: 30,),
                  Text(
                    "Call 911?",
                    style: TextStyle(fontSize: 45, color: Colors.red),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton.icon(
                  icon: Icon(Icons.close_sharp,size: 40,),
                  label: const Text('Cancel', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton.icon(
                  icon: Icon(Icons.check_circle_outline,size: 40,),
                  label: const Text('Yes', style: TextStyle(fontSize: 30)),
                  onPressed: () async {
                    // call 911
                    // await FlutterPhoneDirectCaller.callNumber(number);
                    launch('tel://$number');
                  },
                ),
              ]);
        });
  }

  doctorCallPopUp(BuildContext context) {
    final number = "4047237196";
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              titlePadding: EdgeInsets.all(40),
              actionsPadding: EdgeInsets.all(40),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Text(
                "Call the doctor?",
                style: TextStyle(fontSize: 45),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel', style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Yes', style: TextStyle(fontSize: 30)),
                  onPressed: () async {
                    // call doctor number
                    await FlutterPhoneDirectCaller.callNumber(number);
                  },
                ),
              ]);
        });
  }

  familyCallPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return ContactListPopUp();
          return Dialog(
            child: ContactListPopUp(),
          );
        });
  }
}
