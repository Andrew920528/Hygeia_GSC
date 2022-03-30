import 'package:flutter/material.dart';

import 'package:google_grand_challenge/Pages/Home.dart';

import 'main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image(image: AssetImage('lib/assets/hygeia_logo.png'),width: 250,),
        ),
    );
  }

  void _navigateToHome() async{
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Home(stream: streamController.stream)
    ));
  }
}
