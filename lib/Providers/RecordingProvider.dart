import 'package:flutter/material.dart';
class RecordingProvider extends ChangeNotifier{
  bool isRecording = false;
  bool panelClosed = true;
  void startRecording(){
    isRecording = true;
    notifyListeners();
  }
  void stopRecording(){
    isRecording = false;
    notifyListeners();
  }
  void openPanel(){
    // print("panel opened");
    panelClosed = false;
    notifyListeners();
  }
  void closePanel(){
    // print("panel closed");
    panelClosed = true;
    notifyListeners();
  }

}