import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        title:Text('DIABETAPP'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body:Center(
        child:ListView(
            children: [
              Image(
                image:AssetImage('assets/logo.jpeg'),
              ),
              SizedBox(height:200),
              Center(
                child: FlatButton(//there is also a FlatButton
                    onPressed: ()=>{
                      Navigator.pushNamed(context, '/signUpPage1')
                    },
                    child:Text(
                        'SIGN UP',
                        style:TextStyle(
                          fontSize: 25,
                          color:Colors.white,
                        ),
                    ),
                    color:Colors.pink,
            ),
              ),
                  Center(
                    child: FlatButton(//there is also a FlatButton
                    onPressed: ()=>{
                      Navigator.pushNamed(context, '/signIn')
                    },
                    child:Text(
                        'SIGN IN',
                        style:TextStyle(
                          fontSize: 25,
                          color:Colors.black,
                        ),
                    ),
                    color:Colors.white,
            ),
                  ),
            ],
        ),
        ),
    );
  }
}