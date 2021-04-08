import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:provider/provider.dart';

class BloodTestCurrentValue extends StatelessWidget {
  const BloodTestCurrentValue({key }) : super(key: key);
  
  //static const double adddd;

  String get currentValue {  
    //final user=Provider.of<DocumentSnapshot>(context);
    //getData();
    //return user.data()["bloodTest"].toString();
    return "hi";
  }

  @override
  Widget build(BuildContext context) {
    //final user=Provider.of<DocumentSnapshot>(context);
    return Container(color: const Color(0xFF2DBD3A));
  }
}
/*class BloodTestCurrentValue extends StatefulWidget {

  final myContext;
  double bloodTestCurrentValue;
  final user=Provider.of<DocumentSnapshot>(myContext);
  String get currentValue {  
    return bloodTestCurrentValue.toString();
  }

  BloodTestCurrentValue({this.myContext});

  @override
  _BloodTestCurrentValueState createState() => _BloodTestCurrentValueState();
}


class _BloodTestCurrentValueState extends State<BloodTestCurrentValue> {
  
  double bloodTestCurrentValue;
  
  getData(){
   final user=Provider.of<DocumentSnapshot>(context);
    this.setState(() {
      bloodTestCurrentValue=user.data()["bloodTest"];
    });
    widget.bloodTestCurrentValue=user.data()["bloodTest"];
    print("99999999999999999999999999999999999999999999999999999999999999999");
    print(bloodTestCurrentValue);
 }
  /*String get currentValue {
    print("geteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeer");
    final user=Provider.of<DocumentSnapshot>(context);
    bloodTestCurrentValue=user.data()["bloodTest"];
    return bloodTestCurrentValue.toString();
  }*/
  @override
  Widget build(BuildContext context) {
    print("9999999999999999999999999999999999999999999999999999999999999999999999");
    getData();
    return Text(bloodTestCurrentValue.toString());
  }
}*/
