import 'package:flutter/material.dart';



class SignUpPage2 extends StatefulWidget {
  @override
  _SignUpPage2State createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {

  Map data={};
  int height;
  int weight;
  String heightError='';
  String weightError='';

  void handleHeight(String str){
    bool isNumeric=double.tryParse(str) != null;
    if(isNumeric || str==null || str==''){
      setState(() {
        height=int.tryParse(str);
        heightError='';
      });
    }
    else{
      setState(() {
        heightError='Height must only contain numbers';
      });
    }
  }

  void handleWeight(String str){
    bool isNumeric=double.tryParse(str) != null;
    if(isNumeric || str==null || str==''){
      setState(() {
        weight=int.tryParse(str);
        weightError='';
      });
    }
    else{
      setState(() {
        weightError='Weight must only contain numbers';
      });
    }
  }

  void goToNextPage()
  {
    if(height == null || heightError!='')
      setState(() {
        heightError='You must enter your height';
      });
    else if(weight == null || weightError!=''){
      setState(() {
        weightError='You must enter your weight';
      });
    }
    else
    {
      setState(() {
        heightError='';
        weightError='';
      });
      data['height']=height;
      data['weight']=weight;
      Navigator.pushNamed(context,'/signUpPage3',arguments: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    String isHeightNull= heightError=='' ? null : heightError;
    String isWeightNull= weightError=='' ? null : weightError;
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
      body:ListView(children: [
        SizedBox(height:12),
        Text(
          'HEIGHT',
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
          child: TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            maxLength: 3,
            style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color:Colors.black
            ),
            onChanged: (String str) {
              handleHeight(str);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              helperText: 'in CM',
              errorText: isHeightNull,
            ),
          ),
        ),
        SizedBox(height:20),
        Text(
          'CURRENT WEIGHT',
          style:TextStyle(
            letterSpacing: 1.2,
            color:Colors.pink,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            maxLength: 3,
            style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color:Colors.black
            ),
            onChanged: (String str) {
              handleWeight(str);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              helperText: 'in KG',
              errorText: isWeightNull,
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width:12),
            Text(
              'We use this information to calculate an \n accurate calorie goal for you .',
              style:TextStyle(
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],),
    );
  }
}
