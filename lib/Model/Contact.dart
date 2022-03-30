import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// single contact information object
class Contact{
  final Color iconColor;
  final String name;
  final String number;
  Contact({required this.iconColor, required this.name, required this.number});

  static List<Contact> contacts = [
    Contact(iconColor: Colors.amber, name: "Lara", number: "4047237196"),
    Contact(iconColor: Colors.amber, name: "Bob", number: "4041001001"),
    Contact(iconColor: Colors.amber, name: "Joe", number: "4047832923"),
  ];

  ListTile toListTile(){
    return ListTile(
      leading: Icon(Icons.account_circle_rounded, color: this.iconColor,size: 40),
      title: Text(this.name),
      subtitle: Text(this.number),
      trailing: TextButton.icon(onPressed: () async {await FlutterPhoneDirectCaller.callNumber(this.number);}, icon: Icon(Icons.call), label: Text("call")),
    );
  }
}