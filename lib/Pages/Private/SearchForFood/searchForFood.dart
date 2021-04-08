import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/models/userData.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:diabetapp/Pages/Private/Header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:diabetapp/models/foodData.dart';

class SearchForFood extends StatefulWidget {
  @override
  _SearchForFoodState createState() => _SearchForFoodState();
}

class _SearchForFoodState extends State<SearchForFood> {
  @override

  Map data={};
  bool isIconPressed=false;
  String searchedFood='';
  String searchedFoodError='';
  final String APP_ID='19dc4099';
  final String APP_KEY='e3945c272004bb938b49c0e279a9d50c';
  List foodData=[];
  bool isLoading=false;


  goToHomePage(){
    Navigator.pushNamedAndRemoveUntil(context, '/',(Route<dynamic> route) => false);
  }

  signOut() async{
    Auth auth= Auth(
      goToNextPage:goToHomePage,
    );
    auth.signOut();
  }


  void handleSearchedFood(String str){
    setState(() {
      searchedFood=str;
    });
    if(str!='' && str!=null)
      {
        setState(() {
          isIconPressed=true;
        });
      }
    else{
      setState(() {
        isIconPressed=false;
      });
    }
  }

  Future<void> sendToAPI() async{
    FocusScope.of(context).unfocus();
    if(searchedFood!='' && searchedFood!=null)
      {
        try{
          setState(() {
            isLoading=true;
          });
          String apiPath='https://api.edamam.com/api/food-database/v2/parser?app_id='+APP_ID+'&app_key='+APP_KEY+'&ingr='+searchedFood;
          Response response=await get(apiPath,
              headers:{'Content-Type': 'application/json'},
          );
          //body:json.encode(dat)
          print('.....................request sent......................');
          String jsonsDataString =response.body.toString();
          Map data=jsonDecode(jsonsDataString);
          int i;
          int j;
          bool isFoodExist=false;

          if(data['parsed'].isNotEmpty && data['hints']!=[].isNotEmpty){
            setState(() {
              foodData=[];
              searchedFoodError='';
            });
            for(i=0;i<data['hints'].length;i++){
              isFoodExist=false;
              for(j=0;j<foodData.length;j++){
                if(data['hints'][i]['food']['label']!=null){
                  if(data['hints'][i]['food']['label'].toLowerCase()==foodData[j].label.toLowerCase())
                    {
                      isFoodExist=true;
                    }
                }
              }
              if(data['hints'][i]['food']['label']!=null && data['hints'][i]['food']['nutrients']['ENERC_KCAL']!=null)
                {
                  if(isFoodExist==false){
                    setState(() {
                      foodData.add(
                          FoodData(
                            label:data['hints'][i]['food']['label'],
                            ENERC_KCAL:data['hints'][i]['food']['nutrients']['ENERC_KCAL'],
                            category:data['hints'][i]['food']['category'],
                            img:data['hints'][i]['food']['image'],
                            CHOCDF:data['hints'][i]['food']['nutrients']['CHOCDF'],
                          )
                      );
                    });
                  }
                }
            }
          }
          else{
            setState(() {
              searchedFoodError='item not found in database';
            });
          }
        }
        catch(e){
          setState(() {
            searchedFoodError='an error has occur';
          });
          print(e);
        }
        setState(() {
          isLoading=false;
        });
      }
  }

  goToFoodPage(FoodData food){
    Navigator.pushNamed(context, '/foodPage',arguments:{'userData':data['userData'],'foodData':food,'meals':data['meals']});
  }

  Widget build(BuildContext context) {
    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    String isSearchedFoodNull= searchedFoodError=='' ? null : searchedFoodError;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:Header(argumentsData: data,isGoToSugarLevel: false),
      body:
      ListView(children: [
        ListView(
          shrinkWrap: true,
          children: [
            Container(
              color:Colors.grey[200],
              child:Padding(
                padding:EdgeInsets.fromLTRB(30, 15, 30 , 15),
                child: TextFormField(
                  cursorColor: Theme.of(context).cursorColor,
                  style:TextStyle(
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color:Colors.black,
                  ),
                  onChanged: (String str) {
                    handleSearchedFood(str);
                  },
                  onEditingComplete: () async{
                    sendToAPI();
                  },
                  decoration: InputDecoration(
                    icon: IconButton(
                      icon:Icon(Icons.search),
                      color: (isIconPressed) ? Colors.pink
                          : Colors.grey,
                      onPressed: () async{
                        sendToAPI();
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    errorText: isSearchedFoodNull,
                  ),
                ),
              ),
            ),
          ],
        ),
        isLoading ?
          Column(children: [
            SizedBox(height: 80,),
            SpinKitFadingCube(
              color: Colors.pink,
              size: 50.0,
            )
          ],)
        : Container(),
        Column(
          children: foodData.isEmpty ?  [Container()] : foodData.map((food) {
          return GestureDetector(
            onTap: () => {
              goToFoodPage(food)
            },
            child: Card(
              child:Column(
                children: [
                  ListTile(
                    title:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:230,
                          child: Text(
                            food.label,
                            style:TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                            double.parse((food.ENERC_KCAL).toStringAsFixed(2)).toString() +' KCAL',
                          style:TextStyle(
                            color:Colors.pink,
                            fontSize: 15,
                          ),
                        ),
                      ],),
                    subtitle: Text(
                        '100g('+food.category+')',
                        style:TextStyle(
                          fontSize: 13,
                        ),
                    ),
                  ),
                ],),
            ),
          );
        }).toList(),
        ),
      ],),
      );
  }
}
