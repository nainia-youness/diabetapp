import 'package:flutter/material.dart';


class RadioButton extends StatefulWidget {

  final String headline;
  final String subline;
  final changeActiveLevel;
  final String activeLevel;

  RadioButton({Key key,this.activeLevel,this.headline,this.subline,this.changeActiveLevel}) : super(key: key);

  @override
  _RadioButtonState createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio(
              value:widget.headline,
              activeColor: Colors.black,
              groupValue: widget.activeLevel,
              onChanged: (String value) {
                  widget.changeActiveLevel(value);
              },
            ),
            Text(
              widget.headline,
              style:TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child:Text(
            widget.subline,
            style:TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],),
    );
  }
}