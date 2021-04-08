import 'package:flutter/material.dart';


class DatePickerClass extends StatefulWidget {

  final customFunction;
  final firstDate;
  final lastDate;

  DatePickerClass({Key key,this.firstDate,this.lastDate,this.customFunction}) : super(key: key);

  @override
  _DatePickerClassState createState() => _DatePickerClassState();
}

class _DatePickerClassState extends State<DatePickerClass> {

  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink,
              onPrimary: Colors.white,
              surface: Colors.pink,
            ),
          ),
          child: child,
        );
      },
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    widget.customFunction(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width:12),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
                  style:
                  TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          Divider(
            color:Colors.black,
            indent:20,
          ),
          Row(
            children: [
              SizedBox(width:12),
              Text(
                'We use this information to calculate \nan accurate calorie goal for you .',
                style:TextStyle(
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


