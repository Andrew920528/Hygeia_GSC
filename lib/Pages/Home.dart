import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_grand_challenge/Pages/ContactPage.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import '../Providers/RecordingProvider.dart';
import 'Appointment.dart';
import 'LogInPage.dart';
import 'Notification.dart';
import 'PillsReminder.dart';
import 'dialogFlowTest.dart';
import 'logOutPage.dart';
import 'dart:async';
import 'package:rive/rive.dart';


class Home extends StatefulWidget {
  const Home({Key? key, required this.stream}) : super(key: key);

  final Stream<bool> stream;
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {
  // for animation
  Artboard? _artboard;
  late StateMachineController _controller;
  SMIBool? _aha;
  SMIBool? _thinking;
  SMIBool? _calling;

  // final docId = 'y4KlXiXIs0dWpy9mUMS5';
  double _right = -500;
  bool isRecording = true;
  bool loggedIn = false;
  void rebuildHome(bool log){
    loggedIn = log;
  }

  @override
  void initState() {
    initRive();
    super.initState();
    widget.stream.listen((log) {
      rebuildHome(log);
    });
    NotificationAPI.init(initSchedule: true);
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationAPI.onNotifications.stream.listen(onClickedNotification);

  // when clicked on notification, what happens?
  void onClickedNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PillsReminder()
    ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        automaticallyImplyLeading: false,
      ),
      body: KeyboardDismissOnTap(
        dismissOnCapturedTaps: true,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: (){

                          ahaAnim();
                          activateChat();
                        },
                        child: Container(
                            padding: EdgeInsets.fromLTRB(50,50,50,0),
                            height: 750,
                            width: 800,
                            child: _artboard == null ? const SizedBox():
                            Rive(alignment: Alignment.center,artboard: _artboard!)
                        ),
                      )
                  ),
                  Positioned(
                    top: 30,
                    left: 30,
                    child: IconButton(
                      iconSize: 90,
                      icon: Icon(
                        loggedIn? Icons.logout : Icons.login,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        logInPagePopUp(context);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    child: IconButton(
                      iconSize: 90,
                      icon: const Icon(
                        Icons.mic_rounded,
                        color: Colors.blue,
                      ),
                      onPressed: () {

                        thinkAnim();
                        micOn();
                      },
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(width: 40,),

            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue[50],
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: threeBtn(),
                    ),

                    AnimatedPositioned(
                        right: _right,
                        curve: Curves.fastOutSlowIn,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        child: Container(
                          color: Colors.blue[50],
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width/3,
                            //padding: EdgeInsets.fromLTRB(80,80,0,80),
                            child: Stack(
                              children: [
                                Chat(),
                                Positioned(
                                  top: 100,
                                  left: 10,
                                  child: Material(

                                    shape: CircleBorder(),
                                    color: Colors.white,
                                    elevation: 5.0,
                                    child: IconButton(
                                      iconSize: 30,
                                      icon: const Icon(
                                        Icons.arrow_forward,
                                        color: Colors.blue,
                                      ),
                                      splashRadius: 50,
                                      onPressed: () {
                                        activateChat();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        duration: Duration(milliseconds: 300),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customButton(
          {required onPressed, required text, required icon, required color}) =>
      SizedBox(
        height: 220,
        width: 360,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              elevation: 7,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  icon,
                  size: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 35),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            )),
      );



  threeBtn(){
    return(
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // button 1
            customButton(
                onPressed: () {

                  callAnim();
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ContactPage()
                      ),
                    );
                  });

                },
                text: "Call",
                icon: Icons.call,
                color: Colors.blue[300]),
            // Button 2
            customButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            Calendar()
                    ),
                  );
                },
                text: "Appointment",
                icon: Icons.calendar_today,
                color: Colors.blue[300]),
            // Button 3
            customButton(
                onPressed: () {
                  // getMedications();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            PillsReminder()
                    ),
                  );
                },
                text: "Medication Reminder",
                icon: Icons.medical_services_outlined,
                color: Colors.blue[300]),
          ],
        )
    );
  }

  void activateChat() {

      final provider = Provider.of<RecordingProvider>(context, listen: false);
      if(_right == 0){
        provider.closePanel();
        setState(() {
          _right= -1*MediaQuery.of(context).size.width/3;
        });

      } else {
        // provider.openPanel();
        setState(() {
          _right = 0;
        });

      }


  }

  void micOn(){
    final provider = Provider.of<RecordingProvider>(context, listen: false);
    provider.startRecording();

    setState(() {
      if(_right!=0){
        provider.openPanel();
        _right = 0;
      }
    });
  }



  logInPagePopUp(BuildContext context) {
    // final provider = Provider.of<UserInfoProvider>(context, listen: false);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
             child: Container(
               height: MediaQuery.of(context).size.height*0.6,
               width: MediaQuery.of(context).size.width*0.6,
               child: loggedIn? LogOutPage() : LogInPage(),
             )
          );
        });
  }

  // RIVE animation helper functions
  void initRive(){
    rootBundle.load('lib/assets/avatarAnimation.riv').then(
            (data)async{
          final file = RiveFile.import(data);
          final artboard = file.mainArtboard;
          var controller = StateMachineController.fromArtboard(artboard,'avatar3');
          if (controller!=null){
            artboard.addController(controller);
            _aha = controller.findInput<bool>('aha') as SMIBool;
            _thinking = controller.findInput<bool>('thinking') as SMIBool;
            _calling = controller.findInput<bool>('phone') as SMIBool;
            setState(() {
              _artboard = artboard;
              _controller = controller;
            });
          }
        }
    );
  }

  ahaAnim(){
    if (animIsPlaying()){
      return;
    } else {
      setState(() {
        _aha?.value = true;
        Future.delayed(Duration(seconds: 1), () {
          _aha?.value = false;
        });
      });
    }
  }

  thinkAnim(){
    if (animIsPlaying()){
      return;
    } else {
      setState(() {
        _thinking?.value = true;
        Future.delayed(Duration(seconds: 1), () {
          _thinking?.value = false;
        });
      });
    }
  }

  callAnim(){
    if (animIsPlaying()){
      return;
    } else {
      setState(() {
        _calling?.value = true;
        Future.delayed(Duration(seconds: 1), () {
          _calling?.value = false;
        });
      });
    }
  }

  bool animIsPlaying(){
    return _aha?.value == true || _thinking?.value == true || _calling?.value == true;
  }


}

