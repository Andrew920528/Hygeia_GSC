import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/EventProvider.dart';
import '../Providers/PillsProvider.dart';
import '../Providers/UserInfoProvider.dart';
import '../main.dart';
import 'Notification.dart';

class LogOutPage extends StatelessWidget {
  const LogOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(70.0,70.0,70.0,0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome,",
                style: TextStyle(
                    fontSize: 20,),
              ),
              SizedBox(height: 20,),
              Text(
                  provider.name,
                style: TextStyle(
                  fontSize: 50,),
              ),
              SizedBox(height: 10,),
              Divider(
                color: Colors.black,
                height: 50,
                indent: 40,
                endIndent: 40,
              ),
              SizedBox(height: 20,),
              ElevatedButton.icon(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check,size: 50,),
                label: Text("Hello!",style: TextStyle(fontSize: 30),),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              TextButton.icon(
                  onPressed: (){
                    // log out
                    streamController.add(false);
                    Navigator.pop(context);
                    logOut(context);
                    logOutConfirm(context);
                  },
                  icon: Icon(Icons.logout,size: 30,),
                  label: Text("Log out",style: TextStyle(fontSize: 20),),
              )

            ],
          ),
        ),
      ),

    );
  }

  void logOut(BuildContext context) {
    final userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    final medicationProvider = Provider.of<MedicationProvider>(context,listen: false);
    final eventProvider = Provider.of<EventProvider>(context,listen: false);
    NotificationAPI.cancelAll();
    userInfoProvider.logOut();
    medicationProvider.clearList();
    eventProvider.clearList();
  }
  logOutConfirm(BuildContext context) {
    // final provider = Provider.of<UserInfoProvider>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width*0.4,
                child: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("You have signed out successfully",style: TextStyle(fontSize: 30),),
                        SizedBox(height: 50,),
                        ElevatedButton.icon(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.check,size: 50,),
                          label: Text("OK",style: TextStyle(fontSize: 30),),
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ), //ContactListPopUp(),
          );
        });
  }
}
