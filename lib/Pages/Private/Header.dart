import 'package:flutter/material.dart';
import 'package:diabetapp/Services/auth.dart';
import 'package:diabetapp/models/userData.dart';
import 'package:diabetapp/Services/database.dart';





class Header extends StatelessWidget implements PreferredSizeWidget {

  final argumentsData;
  final isGoToSugarLevel;
  const Header({Key key, this.argumentsData,this.isGoToSugarLevel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    goToHomePage(){
      Navigator.pushNamedAndRemoveUntil(context, '/',(Route<dynamic> route) => false);
    }

    signOut() async{
      Auth auth= Auth(
        goToNextPage:goToHomePage,
      );
      auth.signOut();
    }
    return AppBar(
      title:Text('DIABETAPP'),
      centerTitle: true,
      backgroundColor: Colors.pink,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right:10),
          child: PopupMenuButton(
            onSelected: (newValue) {
              print(ModalRoute.of(context).settings.name);
              if(newValue=='SignOut')
              {
                signOut();
              }
              else if(newValue=='BloodTest' && ModalRoute.of(context).settings.name!='/bloodTest'){
                Navigator.pushNamed(context, '/bloodTest',arguments:argumentsData);
              }
            },
            itemBuilder:(context) =>[
              isGoToSugarLevel ? PopupMenuItem(
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
              ): PopupMenuItem(child:Container()),
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
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}




/*

class Header extends StatefulWidget {

  final argumentsData;

  Header({this.argumentsData});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  goToHomePage(){
    Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
  }

  signOut() async{
    Auth auth= Auth(
      goToNextPage:goToHomePage,
    );
    auth.signOut();
  }



  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:Text('DIABETAPP'),
      centerTitle: true,
      backgroundColor: Colors.pink,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right:10),
          child: PopupMenuButton(
            onSelected: (newValue) {
              print(ModalRoute.of(context).settings.name);
              if(newValue=='SignOut')
              {
                signOut();
              }
              else if(newValue=='BloodTest' && ModalRoute.of(context).settings.name!='/bloodTest'){
                Navigator.pushNamed(context, '/bloodTest',arguments:widget.argumentsData);
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
    );
  }

}
*/