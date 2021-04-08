import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:diabetapp/models/userData.dart';

class SignUpPage4 extends StatefulWidget {

  @override
  _SignUpPage4State createState() => _SignUpPage4State();
}

class _SignUpPage4State extends State<SignUpPage4> {
  Map data={};
  String email='';
  String emailError='';
  String password='';
  String passwordError='';
  String username='';
  String usernameError='';
  String error='';


  handleError(FirebaseAuthException e){
    setState(() {
      error=e.message;
    });
    print(e.message);
  }

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

  void handleUsername(String str){
    setState(() {
      username=str;
      usernameError='';
    });
  }

  goToNextPage(){
      DatabaseService ds=new DatabaseService();
      String uid= Auth().getCurrentUID();
      DatabaseService(uid:uid).getData().then((UserData ud){
          data['userData']=ud;
          Navigator.pushNamedAndRemoveUntil(context, '/bloodTest',(Route<dynamic> route) => false,arguments: data);
      }).catchError((err)=>{
            print(err)
      });
  }

  void signUp() async{
    if(username!='' && password!='' && email!='')
      {
        Auth auth= Auth(
          password:password,
          email:email,
          username:username,
          userData: data,
          handleError:handleError,
          goToNextPage:goToNextPage,
        );
        auth.signUp();
      }
    else if(username=='' && password!='' && email!='')
      {
        setState(() {
          usernameError='the username must be filled';
        });
      }
    else if(username!='' && password=='' && email!='')
    {
      setState(() {
        passwordError='the password must be filled';
      });
    }
    else if(username!='' && password!='' && email=='')
    {
      setState(() {
        emailError='the email must be filled';
      });
    }
    else if(username=='' && password=='' && email=='')
    {
      setState(() {
        usernameError='the username must be filled';
        emailError='the email must be filled';
        passwordError='the password must be filled';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    String isEmailNull= emailError=='' ? null : emailError;
    String isPasswordNull= passwordError=='' ? null : passwordError;
    String isUsernameNull= usernameError=='' ? null : usernameError;

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
            maxLength: 30,
            style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color:Colors.black
            ),
            onChanged: (String str) {
              handleEmail(str);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              errorText: isEmailNull,
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
            obscureText: true,
            cursorColor: Theme.of(context).cursorColor,
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
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              errorText: isPasswordNull,
              labelText: 'Password',
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
            maxLength: 20,
            style:TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
                color:Colors.black
            ),
            onChanged: (String str) {
              handleUsername(str);
            },
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.pink),
              ),
              errorText: isUsernameNull,
              labelText: 'Username',
              labelStyle: TextStyle(
                color: Colors.pink,
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(height:20),
        Center(
          child:Container(
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
        SizedBox(height:90),
        Center(
          child: FlatButton(//there is also a FlatButton
            onPressed: () async =>{
              signUp()
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "already have an account?",
                style:TextStyle(
                  color:Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
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
