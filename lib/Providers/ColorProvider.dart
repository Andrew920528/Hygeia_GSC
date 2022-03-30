import 'package:flutter/material.dart';
class ColorProvider extends ChangeNotifier{
  Color color = Colors.blue;
  void changeColor(Color other){
    color = other;
    notifyListeners();
  }
  void initializeColor(){
    color = Colors.blue;
    notifyListeners();
  }
}