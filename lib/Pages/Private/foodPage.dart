import 'dart:io';
import 'package:diabetapp/Services/database.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Pages/Private/Header.dart';
import 'package:diabetapp/models/foodData.dart';
import 'package:diabetapp/Services/auth.dart';

class FoodPage extends StatefulWidget {
  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {

  Map data={};
  double numberServing=100;
  String numberServingError='';
  bool CanFoodBeEaten=true;

  void handleNumberServing(String str){
    bool isNumeric=double.tryParse(str) != null;
    if(isNumeric || str==null || str==''){
      setState(() {
        numberServing=double.tryParse(str);
        numberServingError='';
      });
    }
    else{
      setState(() {
        numberServingError='Number of Servings must only contain numbers';
      });
    }
  }

  calculateAddedSugar(){
    return 1.000;
  }

  calculateTresholdLevel(){
    return 55557.000;
  }
  addFood()async{
    double addedSugar=calculateAddedSugar();
    double threshold=calculateTresholdLevel();
    String uid= Auth().getCurrentUID();
    await DatabaseService(uid:uid).getSugarLevel().then((currentSugarLevel) => {
        if(currentSugarLevel+addedSugar>threshold) {
            this.setState(() {
              CanFoodBeEaten=false;
            })
        }
        else{
            DatabaseService(uid:uid).addToSugarLevel(addedSugar)
        }
    });
    if(CanFoodBeEaten){
      await DatabaseService(uid:uid).addFoodToUser(data['foodData'],data['meals'],numberServing);
      Navigator.pushNamedAndRemoveUntil(context, '/todayFood',(Route<dynamic> route) => false,arguments:{'userData':data['userData']});
    }
  }

  @override
  Widget build(BuildContext context) {

    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    String isNumberServingNull= numberServingError=='' ? null : numberServingError;
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:Header(argumentsData: data,isGoToSugarLevel: false),
      body:ListView(
        shrinkWrap: true,
        children: [
        SizedBox(height: 12,),
        Row(
          children: [
          SizedBox(width: 12,),
          data['foodData'].img==null ?
          Icon(
            Icons.fastfood_outlined,
            size:150,
          )
          :Image.network(
               data['foodData'].img,
              width: 150,
              height: 150,
          ),
          SizedBox(width:12),
          Container(
            width:230,
            child: Text(
                data['foodData'].label,
                style:TextStyle(
                  letterSpacing: 1.2,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
            ),
          )
        ],),
        SizedBox(height: 12,),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Text(
          "Number of servings",
          style:TextStyle(
            letterSpacing: 1.2,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
      ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(children: [
            Container(
              width:200,
              child: TextFormField(
                cursorColor: Theme.of(context).cursorColor,
                style:TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color:Colors.black
                ),
                onChanged: (String str) {
                  handleNumberServing(str);
                },
                decoration: InputDecoration(
                  labelText:'100',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  helperText: 'in g',
                  errorText: isNumberServingNull,
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(width:10),
            FlatButton(//there is also a FlatButton
              onPressed: () async{
                addFood();
              },
              child:Text(
                'ADD FOOD',
                style:TextStyle(
                  fontSize: 17,
                  color:Colors.white,
                ),
              ),
              color:Colors.pink,
            ),
          ],),
        ),
        SizedBox(height:50),
        !CanFoodBeEaten ? Container(
          width:200,
          child: Card(
                shape:RoundedRectangleBorder(
                  side: BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child:Column(children: [
                  SizedBox(height:5),
                  Text(
                      "Warning",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        ),
                  ),
                  SizedBox(height:10),
                   Center(
                     child: Text("You can't eat the "+data['foodData'].label,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          ),
                     ),
                   )
                ]),
              ),
        ): Container()
      ],)
    );
  }
}

