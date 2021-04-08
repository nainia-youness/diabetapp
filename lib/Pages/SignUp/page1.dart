import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Pages/SignUp/datePicker.dart';


class SignUpPage1 extends StatefulWidget {
  @override
  _SignUpPage1State createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {

  bool isMale=true;
  int postalCode;
  DateTime birthday=DateTime.now();
  String _country = 'Morocco';
  String postalCodeError='';
  List <String> countryList=[
    'Morocco',
    'Italy',
    'Congo',
    'Brazil',
    'Egypt',
  ];
  void birthdayChange(newDate){
    setState(() {
      birthday=newDate;
    });
  }

  void goToNextPage()
  {
    if(postalCode == null || postalCodeError!='')
      setState(() {
        postalCodeError='You must enter your postal code';
      });
    else
    {
      setState(() {
        postalCodeError='';
      });

      Navigator.pushNamed(context,'/signUpPage2',arguments: {
        'isMale':isMale,
        'postalCode':postalCode,
        'birthday':birthday,
        'country':_country,
      });
    }
  }

  void handlePostalCode(String str){
    bool isNumeric=double.tryParse(str) != null;
    if(isNumeric || str==null || str==''){
      setState(() {
        postalCode=int.tryParse(str);
        postalCodeError='';
      });
    }
    else{
      print(str);
      setState(() {
        postalCodeError='Postal Code must only contain numbers';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String isPostalCodeNull= postalCodeError=='' ? null : postalCodeError;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        title:Text('DIABETAPP'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: FlatButton(
              onPressed:() {
                  goToNextPage();
              },
              child:Text(
                  'NEXT',
                  style:TextStyle(
                    color:Colors.white,
                    fontSize:20,
                    fontWeight: FontWeight.w300,
                  ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.pink,
      ),
      body:ListView(
        children: [
          SizedBox(height:12),
          Text(
            'GENDER',
            style:TextStyle(
              letterSpacing: 1.2,
              color:Colors.pink,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height:23),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                value:true,
                groupValue: isMale,
                activeColor: Colors.black,
                onChanged: (bool value) {
                  setState(() {
                    isMale=value;
                  });
                },
              ),
              Text(
                'MALE',
                style:TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Radio(
                value:false,
                groupValue: isMale,
                activeColor: Colors.black,
                onChanged: (bool value) {
                  setState(() {
                    isMale=value;
                  });
                },
              ),
              Text(
                'FEMALE',
                style:TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height:23),
          Text(
            'BIRTHDAY',
            style:TextStyle(
              letterSpacing: 1.2,
              color:Colors.pink,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height:20),
          DatePickerClass(
              firstDate:DateTime(1970),
              lastDate:DateTime.now(),
              customFunction:birthdayChange
          ),
          SizedBox(height:23),
          Text(
            'LOCATION',
            style:TextStyle(
              letterSpacing: 1.2,
              color:Colors.pink,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height:20),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
              ),
              child: DropdownButton(
                value: _country,
                style:TextStyle(fontWeight: FontWeight.w500,fontSize: 25, color:Colors.black),
                underline:SizedBox(),
                focusColor: Colors.red,
                isExpanded: true,
                  items: countryList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value,
                       ),
                    );
                  }).toList(),
                onChanged: (String value) {
                  setState(() {
                    _country = value;
                  });
                },
              ),
            ),
          ),
          Divider(
            color:Colors.black,
            indent:20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: TextFormField(
              cursorColor: Theme.of(context).cursorColor,
              maxLength: 5,
              style:TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                  color:Colors.black
              ),
              onChanged: (String str) {
                    handlePostalCode(str);
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
                helperText: 'Postal Code',
                errorText: isPostalCodeNull,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
