import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Model/Contact.dart';
import 'package:google_grand_challenge/Pages/AddContact.dart';
import 'package:provider/provider.dart';

import '../Providers/ColorProvider.dart';


// pop up page for a list of contact
class ContactListPopUp extends StatefulWidget {
  const ContactListPopUp({Key? key}) : super(key: key);

  @override
  State<ContactListPopUp> createState() => _ContactListPopUpState();
}

class _ContactListPopUpState extends State<ContactListPopUp> {

  @override
  Widget build(BuildContext context) {
    List<Contact> contacts = Contact.contacts;
    final colorProvider = Provider.of<ColorProvider>(context);
    // final Contact contact1 =
    //     Contact(iconColor: Colors.amber, name: "Dr. H", number: "4047237196");
    return Container(
        padding: EdgeInsets.fromLTRB(60, 30, 60, 30),
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.8,

        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children:
                    // loop through all the items in contacts
                    contacts.map((contact) => contact.toListTile()).toList(),
              ),
            ),
            // contact1.toListTile(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async{
                  colorProvider.initializeColor();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContact()),
                  );
                  // update the view
                  setState(() {
                    Contact.contacts;
                  });
                },
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    minimumSize: Size(60, 60),
                    primary: Colors.blue[300]),
              ),
            ),
          ],
        ));
  }
}
