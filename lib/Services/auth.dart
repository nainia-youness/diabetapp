import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth extends StatefulWidget {
  final username;
  final email;
  final password;
  final handleError;
  final goToNextPage;
  final Map userData;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Auth({Key key,this.username,this.email,this.password,this.handleError,this.goToNextPage,this.userData}) : super(key: key);



  void signIn() async{
      try {
      User user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
      goToNextPage();
    }
     on FirebaseAuthException catch (e) {
       handleError(e);
       print("Exception caught => ${e.code}");
    }
    catch(e){
      print(e);
    }
  }

  String getCurrentUID(){
      String uid= _auth.currentUser.uid;
      return uid;
  }

  void signUp() async{
    try{
      final user = (await
      _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
      ).user;
      if (user != null) {
        //now the user is signed in
        await _auth.currentUser.updateProfile(
            displayName:username
        );
        await DatabaseService(uid:user.uid).updateUserData(
          username,userData['activeLevel'],userData['isMale'],userData['postalCode'],userData['birthday'],userData['country'],userData['height'],userData['weight']
        );
        goToNextPage();
      }
    }
    catch(e){
      print(e);
      handleError();
    }
  }

  void signOut() async{
    try{
      final user = _auth.currentUser;
      if (user != null) {
        await _auth.signOut();
        goToNextPage();
      }
    }
    catch(e){
      print(e);
    }
  }

  Future<bool> isConnected() async{
    try{
      final user = _auth.currentUser;
      if (user != null) {
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      print(e);
      return false;
    }
  }

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
