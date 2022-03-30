import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserInfoProvider extends ChangeNotifier{
  // an empty id will throw error if the
  //  user sets an appointment without logging in

  String _name = "";

  String _userID = "user_not_log_in";
  bool _isValidID = false;

  String? validationMessage;

  bool loggedIn = false;

  String get userID => _userID;
  bool get isValidID => _isValidID;
  String get name => _name;

  //
  setUserID(String uid){
    _userID = uid;
    notifyListeners();
  }
  //
  checkValidID(String inputID) async {
    final result = await FirebaseFirestore.instance
        .collection('Patients')
        .where('id', isEqualTo: inputID)
        .limit(1)
        .get().then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty){
        // print("no patient found");
        _isValidID = false;
        notifyListeners();
        return;
      }
      querySnapshot.docs.forEach((doc) {
        // print(doc["id"]);
        print("Found patient: " + doc.id);

        _userID = doc.id;
        _isValidID = true;
        notifyListeners();
      });

      // _formKey.currentState?.validate();
    });
  }
  Future<dynamic> checkPhone(number) async {
    // validationMessage = null;
    //do all sync validation
    if (number.isEmpty) {
      // print("the number is empty");
      validationMessage = "number is required";
      notifyListeners();
      return;
    }
    // do async validation
    // print("start checking");
    
    // async validation here
    await checkValidID(number);

    // print("finish checking");

    if (isValidID){
      print("Log in successfully!");
      loggedIn = true;
      validationMessage = null;
      notifyListeners();
    } else {
      print("failed to log in");
      validationMessage = "Can't find the number";
      notifyListeners();
    }

  }

  void setName(String name){
    _name = name;
    notifyListeners();
  }

  void logOut(){
    _userID = "user_not_log_in";
    _name = "";
    _isValidID = false;
    loggedIn = false;
    notifyListeners();
  }
}