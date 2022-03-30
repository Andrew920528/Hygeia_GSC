import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_grand_challenge/Providers/ColorProvider.dart';
class ColorDropDown extends StatefulWidget {

  ColorDropDown({Key? key,}) : super(key: key);

  @override
  State<ColorDropDown> createState() => ColorDropDownState();

}

class ColorDropDownState extends State<ColorDropDown> {

  Color colorValue = Colors.blue;

  @override
  Widget build(BuildContext context) {
    final colorProvider = Provider.of<ColorProvider>(context, listen: false);
    return DropdownButtonFormField<Color>(
      value: colorValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,


      onChanged: (Color? newValue) {
        colorProvider.changeColor(newValue!);

      },
      items: <Color>[Colors.amber, Colors.blue, Colors.lightGreen,]
          .map<DropdownMenuItem<Color>>((Color value) {
        return DropdownMenuItem<Color>(
          value: value,
          child: Icon(Icons.circle, color: value,),
        );
      }).toList(),

    );
  }
}

