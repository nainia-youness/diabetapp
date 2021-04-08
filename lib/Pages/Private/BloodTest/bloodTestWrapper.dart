import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/models/userData.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:diabetapp/Pages/Private/Header.dart';
import 'package:diabetapp/Pages/Private/BloodTest/bloodTest.dart';

class BloodTestWrapper extends StatelessWidget {
  const BloodTestWrapper ({key }) : super(key: key);
  
  //static const double adddd;

  @override
  Widget build(BuildContext context) {
    String uid= Auth().getCurrentUID();
    return StreamProvider<DocumentSnapshot>.value(
      value:DatabaseService().getUsersStream(uid),
      child: BloodTest(),
      );
  }
}