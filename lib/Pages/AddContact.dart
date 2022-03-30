import 'package:flutter/material.dart';
import 'package:google_grand_challenge/Model/ColorDropDown.dart';
import 'package:google_grand_challenge/Model/Contact.dart';
import 'package:provider/provider.dart';
import 'package:google_grand_challenge/Providers/ColorProvider.dart';
class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  static const Color DEF_COLOR = Colors.blue;
  late String _name;
  late Color? _iconColor = DEF_COLOR;
  late String _number;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context);
    _iconColor = colorProvider.color;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
        leading: CloseButton(),
        actions: buildSave(),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(80,30,80,30),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                // put in build function here in the desired format
                children: [
                  Icon(Icons.account_circle_rounded, color: _iconColor,size: 130,),
                  SizedBox(height: 30,),
                  buildNameField(),
                  SizedBox(height: 30,),
                  buildNumberField(),
                  SizedBox(height: 30,),
                  buildIconColorField(),
                ]),
          ),
        ),

      ),
    );
  }

  List<Widget> buildSave() {
    return [
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: saveForm,
        icon: Icon(Icons.done),
        label: Text("Save"),
      )
    ];
  }

  // building each fields
  Widget buildNameField() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Name",
      ),
      validator: (title) =>
          title != null && title.isEmpty ? "Name Cannot Be Empty" : null,
      onSaved: (String? value){
          _name=value.toString();
        },
    );
  }

  Widget buildIconColorField() {
    //String dropdownValue = 'One';
    return ColorDropDown();

  }

  Widget buildNumberField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Number",
      ),
      validator: (num) {
        const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
        final regExp = RegExp(pattern);

        if(num!=null){
          if (!regExp.hasMatch(num) || num.isEmpty) {
            return "Invalid Number";
          }
          else{
            return null;
          }
        } else{
          return "Invalid Number";
        }

      },

      onSaved: (String? value){
        _number=value.toString();
      },
    );
  }

  // saves the form
  Future saveForm() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      final Contact contact = Contact(
        iconColor: _iconColor!,
        name: _name,
        number: _number,
      );

      setState(() {
        Contact.contacts.add(contact);
      });

      Navigator.pop(context);

    }
    else{
      return;
    }

  }
}
