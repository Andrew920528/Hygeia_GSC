import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_grand_challenge/Providers/EventProvider.dart';
import 'package:google_grand_challenge/Splash.dart';
import 'package:provider/provider.dart';
import 'package:google_grand_challenge/Providers/ColorProvider.dart';

import 'Providers/PillsProvider.dart';
import 'Providers/RecordingProvider.dart';
import 'Providers/UserInfoProvider.dart';

StreamController<bool> streamController = StreamController<bool>();

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ColorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MedicationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecordingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserInfoProvider(),
        )
      ],
      child: MaterialApp(
        home: FutureBuilder(
          future: _fbApp,
          builder: (context,snapshot) {
            if(snapshot.hasError){
              print("You have an error! ${snapshot.error.toString()}");
              return Text("Something went wrong");
            } else if(snapshot.hasData) {
              return Splash();//LocalNotification();//Home(stream: streamController.stream);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
        //Home(),
      ),
    );
  }
}

