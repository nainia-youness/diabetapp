import 'package:diabetapp/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:flutter/services.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email='';
  String emailError='';
  String password='';
  String passwordError='';
  String error='';
  Map data={};

  void handleEmail(String str){
    setState(() {
      email=str;
      emailError='';
    });
  }

  void handlePassword(String str){
    setState(() {
      password=str;
      passwordError='';
    });
  }
  handleError(FirebaseAuthException e){
    setState(() {
      error=e.message;
    });
  }



  goToNextPage(){
      String uid= Auth().getCurrentUID();
      DatabaseService(uid:uid).isSugarLevelSetInUser().then((bool isSugarLevelSet) {
        if(isSugarLevelSet){
          Navigator.pushNamedAndRemoveUntil(context, '/todayFood',(Route<dynamic> route) => false,arguments: data);
        }
        else{
          DatabaseService ds=new DatabaseService();
          DatabaseService(uid:uid).getData().then((UserData ud){
            data['userData']=ud;
            Navigator.pushNamedAndRemoveUntil(context,'/bloodTest',(Route<dynamic> route) => false,arguments: data);
          }).catchError((err)=>{
            print(err)
          });
        }
      });
      ;
  }

  void signIn() async{
    if(email!='' && password!='')
      {
        try{
        Auth auth= Auth(
          password:password,
          email:email,
          handleError:handleError,
          goToNextPage:goToNextPage,
        );
         auth.signIn();
        }
        catch(e){
          print(e.message);
        }
      }
    else if(email!='' && password=='')
      {
        setState(() {
          passwordError='the password must be filled';
        });
      }
    else if(email=='' && password!=''){
      setState(() {
        emailError='the email must be filled';
      });
    }
    else{
      setState(() {
        emailError='the email must be filled';
        passwordError='the password must be filled';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String isEmailNull= emailError=='' ? null : emailError;
    String isPasswordNull= passwordError=='' ? null : passwordError;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        title:Text('DIABETAPP'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body:ListView(children: [
        SizedBox(height:12),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            maxLength: 20,
            style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color:Colors.black
            ),
            onChanged: (String str) {
              handleEmail(str);
            },
            decoration: InputDecoration(
              errorText: isEmailNull,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.pink,
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height:12),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: TextFormField(
            cursorColor: Theme.of(context).cursorColor,
            obscureText: true,
            maxLength: 20,
            style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color:Colors.black
            ),
            onChanged: (String str) {
              handlePassword(str);
            },
            decoration: InputDecoration(
              errorText: isPasswordNull,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.pink,
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height:30),
        Center(
          child:Container(
              width:350,
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: error =='' ? null : Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0) //                 <--- border radius here
                ),
              ),
              child:Text(
                error,
                style:TextStyle(
                  fontSize:18,
                  color:Colors.red,
                ),
              )
          ),
        ),
        SizedBox(height:80),
        Center(
          child: FlatButton(//there is also a FlatButton
            onPressed: ()=>{
              signIn()
            },
            child:Text(
              'SIGN IN',
              style:TextStyle(
                fontSize: 25,
                color:Colors.white,
              ),
            ),
            color:Colors.pink,
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                "don't have an account?",
                style:TextStyle(
                  color:Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Center(
                child: FlatButton(//there is also a FlatButton
                  onPressed: ()=>{
                    Navigator.pushNamed(context, '/signUpPage1')
                  },
                  child:Text(
                    'SIGN UP',
                    style:TextStyle(
                      fontSize: 15,
                      color:Colors.pink,
                    ),
                  ),
                  color:Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}
