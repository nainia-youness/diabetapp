import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/models/userData.dart';
import 'package:diabetapp/Services/database.dart';
import 'package:provider/provider.dart';
import 'package:diabetapp/Pages/Private/Header.dart';

class BloodTest extends StatefulWidget {
  @override
  _BloodTestState createState() => _BloodTestState();
}

class _BloodTestState extends State<BloodTest> {

  double sugarLevel=0;
  String sugarLevelError;
  double originalSugarLevel;
  Map data={};

  goToNextPage(){
     Navigator.pushNamedAndRemoveUntil(context, '/',(Route<dynamic> route) => false);
  }


   goToTodayFoodPage() async{
    if(sugarLevel!=0.0 && sugarLevelError=='' && sugarLevel!=null){
      String uid= Auth().getCurrentUID();
      await DatabaseService(uid:uid).addSugarLevelToUser(sugarLevel);
      Navigator.pushNamedAndRemoveUntil(context, '/todayFood',(Route<dynamic> route) => false,arguments: data);
    }
    else if(sugarLevelError=='' && (sugarLevel==0.0 || sugarLevel==null)){
      setState(() {
        sugarLevelError='Blood level must be filled';
      });
    }
    else{
      setState(() {
        sugarLevelError='Blood level must only contain numbers';
      });
    }
   }


  void handleSugarLevel(String str) async{
    bool isNumeric=double.tryParse(str) != null;
    if(isNumeric || str==null || str==''){
      await setState(() {
        sugarLevel=double.tryParse(str) ?? 0.0;
        sugarLevelError='';
      });
    }
    else{
      setState(() {
        sugarLevel=0.0;
        sugarLevelError='Blood level must only contain numbers';
      });
    }
  }

  signOut() async{
    Auth auth= Auth(
      goToNextPage:goToNextPage,
    );
    auth.signOut();
  }


  @override
  Widget build(BuildContext context) {
    data= data.isNotEmpty? data : ModalRoute.of(context).settings.arguments;
    String isSugarLevelNull= sugarLevelError=='' ? null : sugarLevelError;
    originalSugarLevel= data['userData'].sugarLevel== null ? 0.0 : data['userData'].sugarLevel;
    final user=Provider.of<DocumentSnapshot>(context);
    return
          Scaffold(
          backgroundColor: Colors.white,
          appBar:AppBar(
            title:Text('DIABETAPP'),
            centerTitle: true,
            backgroundColor: Colors.pink,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:10),
                child: PopupMenuButton(
                  onSelected: (newValue) {
                      if(newValue=='SignOut')
                        {
                          signOut();
                        }
                      else if(newValue=='BloodTest' && ModalRoute.of(context).settings.name!='/bloodTest'){
                        Navigator.pushNamed(context, '/bloodTest',arguments:data==null ? {} : data);
                      }
                  },
                  itemBuilder:(context) =>[
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Text(
                              "Blood test",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      value:'BloodTest',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 10.0,
                            ),
                            child: Text(
                              "Sign Out",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      value:'SignOut',
                    ),
                    ],
                  child: Icon(
                    Icons.more_vert,
                    size: 28.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body:ListView(children: [
            SizedBox(height:12),
            Padding(
              padding: EdgeInsets.all(15),
              child:Text(
                'PLEASE ENTER THE QUANTITY OF SUGAR IN YOUR BLOOD',
                textAlign: TextAlign.center,
                style:TextStyle(
                  letterSpacing: 1.2,
                  color:Colors.pink,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Divider(
              color: Colors.pink,
              indent:20,
              endIndent: 20,
            ),
            SizedBox(height: 15,),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: TextFormField(
                cursorColor: Theme.of(context).cursorColor,
                maxLength: 10,
                style:TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color:Colors.black
                ),
                onChanged: (String str) {
                  handleSugarLevel(str);
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  border: OutlineInputBorder(),
                  helperText: 'in mg/dL',
                  suffixIcon: FlatButton(
                    onPressed:() async{
                      goToTodayFoodPage();
                    },
                    child:Text(
                        'confirm',
                        style:TextStyle(
                          color:Colors.pink,
                        ),
                    ),
                  ),
                  labelText:user.data()['sugarLevel'].toString(),//originalSugarLevel.toString(),
                  labelStyle: TextStyle(
                      color: Colors.grey,
                  ),
                  errorText: isSugarLevelNull,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Image(
              image:AssetImage('assets/bloodTest.jpg'),
              height:250,
              width: 250,
            ),
          ],
          ),
    );
  }
}
