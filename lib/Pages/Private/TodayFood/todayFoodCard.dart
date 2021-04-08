import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:provider/provider.dart';

class TodayFoodCard extends StatefulWidget {

  final String title;
  final addFood;
  
  

  TodayFoodCard({this.title,this.addFood});
  @override
  _TodayFoodCardState createState() => _TodayFoodCardState();
}


class _TodayFoodCardState extends State<TodayFoodCard> {
  
  var MealsFood=[];
  int foodNumber=0;
 
 Function getData(){
   final user=Provider.of<DocumentSnapshot>(context);
   if(user!=null){
    if(user.data()!=null){
      if(user.data()[widget.title]!=null){
        MealsFood=user.data()[widget.title];
        foodNumber=user.data()[widget.title].length;
      }
    }
   }
 }

  @override
  Widget build(BuildContext context) {
    getData();
    return Card(
      shape:RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(4.0)
      ),
      child:Column(children: [
        ListTile(
          title:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style:TextStyle(
                  letterSpacing: 1.2,
                  color:Colors.pink,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                foodNumber.toString(),
                style:TextStyle(
                  fontSize: 25,
                ),
              ),
            ],),
          subtitle: Padding(
            padding: EdgeInsets.fromLTRB(0, 0,190,0),
            child: FlatButton.icon(
              onPressed: () async{
                widget.addFood();
              },
              icon:Icon(
                Icons.plus_one,
              ),
              label:Text(
                'ADD FOOD',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6)
                ),
              ),
            ),
          ),
        ),
        Column(
          children:MealsFood==null|| MealsFood==[] ?  [Container()] : MealsFood.map<Widget>((food) {
          return GestureDetector(
            child:Card(
              shape:RoundedRectangleBorder(
                side: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(4.0)
              ),
              child:Column(children: [
                 ListTile(
                  leading: food['img']==null ?
                  Icon(
                      Icons.fastfood_outlined,
                  )
                  :Image.network(food['img']),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(food['label']),
                    Text((food['ENERC_KCAL']*(food['numberServing']/100)).toStringAsFixed(2)+" KCAL")
                  ],),
                  subtitle: Text(
                    food['numberServing'].toString()==null ?'' : food['numberServing'].toString(),
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
              ]),
            )
          );
        }).toList(),
        )
      ]
      ),
    );
  }
}
