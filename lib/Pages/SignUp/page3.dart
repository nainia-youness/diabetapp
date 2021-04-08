import 'package:flutter/material.dart';
import 'package:diabetapp/Pages/SignUp/radioButton.dart';

class SignUpPage3 extends StatefulWidget {
  @override
  _SignUpPage3State createState() => _SignUpPage3State();
}

class _SignUpPage3State extends State<SignUpPage3> {

  Map data={};
  String activeLevel='';
  String activeLevelError='';

  void changeActiveLevel(String str){
    setState(() {
      activeLevel=str;
    });
  }

  void goToNextPage()
  {
    print(activeLevel);
    if(activeLevel == null || activeLevel=='')
      {
        print('hey');
        setState(() {
          activeLevelError='You must choose how active you are';
        });
      }
    else
    {
      setState(() {
        activeLevelError='';
      });
      data['activeLevel']=activeLevel;
      Navigator.pushNamed(context,'/signUpPage4',arguments: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
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
          'HOW ACTIVE ARE YOU?',
          style:TextStyle(
            letterSpacing: 1.2,
            color:Colors.pink,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height:20),
        RadioButton(
          activeLevel: activeLevel,
          headline:'NOT VERY ACTIVE',
          subline:'SPEND MOST OF DAY SITTING(E.G BANK TELLER, DESK JOB)',
          changeActiveLevel:changeActiveLevel,
        ),
        SizedBox(height:12),
        RadioButton(
          activeLevel: activeLevel,
          headline:'LIGHTLY ACTIVE',
          subline:'SPEND A GOOD PART OF OF THE DAY ON YOUR FEET(E.G BANK TELLER,TEACHER,SALESPERSON)',
          changeActiveLevel:changeActiveLevel,
        ),
        SizedBox(height:12),
        RadioButton(
          activeLevel: activeLevel,
          headline:'ACTIVE',
          subline:'SPEND A GOOD PART OF THE DAY DOING SOME PHYSICAL ACTIVITY(E.G FOOD SERVER,POSTAL CARRIER)',
          changeActiveLevel:changeActiveLevel,
        ),
        SizedBox(height:12),
        RadioButton(
          activeLevel: activeLevel,
          headline:'VERY ACTIVE',
          subline:'SPEND MOST OF THE DAY DOING PHYSICAL ACTIVITY(E.G BIKE MESSENGER,CARPENTER)',
          changeActiveLevel:changeActiveLevel,
        ),
        SizedBox(height:29),
        Center(
          child:Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: activeLevelError =='' ? null : Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
            child:Text(
              activeLevelError,
              style:TextStyle(
                fontSize:18,
                color:Colors.red,
              ),
            )
          ),
        ),
      ],),
    );
  }
}
