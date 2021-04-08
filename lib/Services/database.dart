import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetapp/models/userData.dart';
import 'package:diabetapp/models/foodData.dart';
import 'package:diabetapp/Services/auth.dart';

class DatabaseService{

  final String uid;

  DatabaseService({this.uid});

  final firestoreInstance = FirebaseFirestore.instance;
  UserData u;

  updateUserData(String username,String activeLevel,bool isMale,int postalCode,DateTime birthday,String country,int height,int weight) async
  {
    try{
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      await firestoreInstance.collection("users").doc(firebaseUser.uid).set(
          {
            "lastConnectedDay":DateTime.now(),
            'username':username,
            'activeLevel':activeLevel,
            'isMale':isMale,
            'postalCode':postalCode,
            'birthday':birthday,
            'country':country,
            'height':height,
            'weight':weight,
          }
      );
    }
    catch(e){
      print('error = '+e);
    }
  }


  Stream<DocumentSnapshot> getUsersStream(myUid){
    return firestoreInstance.collection("users").doc(myUid).snapshots();
  }

  deleteAllMealFoods() async{
    try{
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      await firestoreInstance.collection("users").doc(firebaseUser.uid).update(
          {
            "Breakfast":[],
            "Dinner":[],
            "Lunch":[],
            "Snacks":[]
          }
      );
    }
    catch(e){
      print('error = '+e);
    }
  }

  changeLastConnectedDayToNow() async{
    try{
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      await firestoreInstance.collection("users").doc(firebaseUser.uid).update(
          {
            "lastConnectedDay":DateTime.now(),
          }
      );
    }
    catch(e){
      print('error = '+e);
    }
  }

  addSugarLevelToUser(double sugarLevel) async{
    try{
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      await firestoreInstance.collection("users").doc(firebaseUser.uid).update(
        {
          'sugarLevel':sugarLevel,
        }
      );
    }
    catch(e){
      print('error = '+e);
    }
  }
    Future<double> getSugarLevel() async {
      return firestoreInstance.collection('users').doc(uid).get().then((DocumentSnapshot doc)  {
          return doc.data()['sugarLevel'];
      });
    }

    addToSugarLevel(double addedSugar) async{
    try{
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      return firestoreInstance.collection('users').doc(uid).get().then((DocumentSnapshot doc) {
      firestoreInstance.collection("users").doc(firebaseUser.uid).update(
        {
          'sugarLevel':doc.data()["sugarLevel"]+addedSugar,
        }
      );
    });
    }
    catch(e){
      print('error = '+e);
    }
  }

  addFoodToUser(FoodData food,String meals,double numberServing) async{
    try{
      var firebaseUser =  FirebaseAuth.instance.currentUser;
      firestoreInstance.collection('users').doc(uid).get().then((DocumentSnapshot doc) {
      firestoreInstance.collection("users").doc(firebaseUser.uid).update(
        {
          meals:FieldValue.arrayUnion([{
            "numberServing":numberServing,
            "label":food.label,
            "ENERC_KCAL":food.ENERC_KCAL,
            "category":food.category,
            "img":food.img,
            "CHOCDF":food.CHOCDF
          }]),
        }
      );
    });
    }
    catch(e){
      print('error = '+e);
    }
  }

  Future<List<dynamic>> getMealsFoods(String meal){
    return firestoreInstance.collection('users').doc(uid).get().then((DocumentSnapshot doc) {
      if(doc.data()[meal]==null){
        return [];
      }
      else{
        return doc.data()[meal];
      }
    });
  }

  Future<bool> isSugarLevelSetInUser() async{
      return firestoreInstance.collection('users').doc(uid).get().then((DocumentSnapshot doc) {
      if(doc.data()['sugarLevel']==null){
        return false;
      }
      else{
        return true;
      }
    });
  }


  Future<UserData> getData(){
    return firestoreInstance.collection('users').doc(uid).get().then((DocumentSnapshot doc){
      return UserData(
        username:doc.data()['username'] ?? '',
        sugarLevel:doc.data()['sugarLevel'] ?? 0.0,
        activeLevel:doc.data()['activeLevel']?? '',
        isMale:doc.data()['isMale'] ?? true,
        postalCode:doc.data()['postalCode'] ?? 0,
        birthday:(doc.data()['birthday']==null) ? DateTime.now() : doc.data()['birthday'].toDate(),
        country:doc.data()['country'] ?? '',
        height:doc.data()['height'] ?? 0,
        weight:doc.data()['weight'] ?? 0,
      );
    });
  }
}