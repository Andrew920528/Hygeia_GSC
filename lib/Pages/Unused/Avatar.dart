import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter/material.dart';

class Avatar extends StatefulWidget {
  const Avatar({Key? key}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  Artboard? _artboard;
  late StateMachineController _controller;
  SMIBool? _aha;
  SMIBool? _thinking;
  SMIBool? _calling;

  @override
  void initState() {
    initRive();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(50,50,50,0),
        height: 750,
        width: 800,
        child: _artboard == null ? const SizedBox():
        Rive(alignment: Alignment.center,artboard: _artboard!)
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
}

