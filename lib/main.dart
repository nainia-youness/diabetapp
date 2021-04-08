import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:diabetapp/Pages/home.dart';
import 'package:diabetapp/Pages/SignUp/page1.dart';
import 'package:diabetapp/Pages/SignUp/page2.dart';
import 'package:diabetapp/Pages/SignUp/page3.dart';
import 'package:diabetapp/Pages/SignUp/page4.dart';
import 'package:diabetapp/Pages/signin.dart';
import 'package:diabetapp/Pages/Private/BloodTest/bloodTestWrapper.dart';
import 'package:diabetapp/Pages/Private/TodayFood/todayFood.dart';
import 'package:diabetapp/Pages/Private/SearchForFood/searchForFood.dart';
import 'package:diabetapp/Pages/Private/foodPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SeeIfDayHasPassed(){
    DateTime now = DateTime.now();
    Auth auth= Auth();
    String uidd;
    try{
      auth.isConnected().then((isConnected)=>{
        if(isConnected){
          uidd= Auth().getCurrentUID(),
          FirebaseFirestore.instance.collection('users').doc(uidd).get().then((DocumentSnapshot doc)  {
            DateTime lastConnectedDay=doc.data()["lastConnectedDay"].toDate();
            if(now.month>lastConnectedDay.month || now.year>lastConnectedDay.year){
            DatabaseService(uid:uidd).deleteAllMealFoods();
            DatabaseService(uid:uidd).changeLastConnectedDayToNow();
          }
          else if(now.day>lastConnectedDay.day){
            DatabaseService(uid:uidd).deleteAllMealFoods();
            DatabaseService(uid:uidd).changeLastConnectedDayToNow();
          }
          })
        }
      });
    }
    catch(e){
      print(e);
    }

  }

  const oneMinute = const Duration(seconds: 60);

  Timer.periodic(oneMinute, (Timer timer) {
    SeeIfDayHasPassed();
  });

  Auth auth= Auth();
  auth.isConnected().then((isConnected)=>{
    if(isConnected){
        auth.signOut()
    }
  });

  runApp(MaterialApp(
    initialRoute: '/',
    routes:{
          '/':(context)=> Home(),
          '/signUpPage1':(context)=> SignUpPage1(),
          '/signUpPage2':(context)=> SignUpPage2(),
          '/signUpPage3':(context)=> SignUpPage3(),
          '/signUpPage4':(context)=> SignUpPage4(),
          '/signIn':(context)=> SignIn(),
          '/todayFood':(context)=> TodayFood(),
          '/bloodTest':(context)=> BloodTestWrapper(),
          '/searchForFood':(context)=> SearchForFood(),
          '/foodPage':(context)=> FoodPage(),
        },
  ));
}