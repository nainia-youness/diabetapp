import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/models/userData.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:diabetapp/Pages/Private/TodayFood/todayFoodCard.dart';
import 'package:provider/provider.dart';
import 'package:diabetapp/Pages/Private/Header.dart';

class TodayFood extends StatefulWidget {
  @override
  _TodayFoodState createState() => _TodayFoodState();
}

class _TodayFoodState extends State<TodayFood> {

  Map data={};
  UserData userdata=UserData();

  goToHomePage(){
    Navigator.pushNamedAndRemoveUntil(context, '/',(Route<dynamic> route) => false);
  }

  signOut() async{
    Auth auth= Auth(
      goToNextPage:goToHomePage,
    );
    auth.signOut();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      String uid= Auth().getCurrentUID();
      DatabaseService(uid:uid).getData().then((UserData data) {
        setState(() {
          userdata=data;
        });
      });
    }
    catch(e){
      print(e);
    }


  }



  AddBreakFastFood(){
    Navigator.pushNamed(context, '/searchForFood',arguments:{'userData':userdata,'meals':'Breakfast'});
  }
  AddLunchFood(){
    Navigator.pushNamed(context, '/searchForFood',arguments:{'userData':userdata,'meals':'Lunch'});
  }
  AddDinnerFood(){
    Navigator.pushNamed(context, '/searchForFood',arguments:{'userData':userdata,'meals':'Dinner'});
  }
  AddSnacksFood(){
    Navigator.pushNamed(context, '/searchForFood',arguments:{'userData':userdata,'meals':'Snacks'});
  }

  @override
  Widget build(BuildContext context) {
    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    String uid= Auth().getCurrentUID();
    return StreamProvider<DocumentSnapshot>.value(
        value:DatabaseService().getUsersStream(uid),
        child: Scaffold(
        backgroundColor: Colors.white,
        appBar:Header(argumentsData: {'userData':userdata},isGoToSugarLevel: true),
        body:ListView(children: [
          SizedBox(height: 20,),
          TodayFoodCard(
            title:'Breakfast',
            addFood: AddBreakFastFood,
          ),
          TodayFoodCard(
            title:'Lunch',
            addFood: AddLunchFood,
          ),
          TodayFoodCard(
            title:'Dinner',
            addFood: AddDinnerFood,
          ),
          TodayFoodCard(
            title:'Snacks',
            addFood: AddSnacksFood,
          ),
        ],),
      ),
    );
  }
}
