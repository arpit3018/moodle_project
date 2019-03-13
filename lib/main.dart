import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'profile_page.dart';
import 'student_home.dart';
import 'teacher_home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moodle',
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  DatabaseReference ref = FirebaseDatabase.instance.reference();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  FirebaseMessaging _message = new FirebaseMessaging();

  @override
  void initState(){
    super.initState();
    checkMy();

  }

  int flag = 0;
  Future<void> checkMy() async {

    FirebaseUser user = await _auth.currentUser();

    if(user != null)
    {
      flag = 1;
      setState(() {

      });
      //123456789876w2q23456789876543
      ref.child('user_details').orderByChild("uid").equalTo(user.uid)
          .once()
          .then((DataSnapshot data) {
        Map<String,String> user_detail = {'uid':user.uid,"name":user.displayName,"email":user.email};

        if (data.value == null) {

          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new ProfilePage(user_detail,_signOut)));
        }
        else {
          String key = data.value.keys.toString();

          var full_details = data.value[key.substring(1, key.length - 1)];
          if (full_details['teacher_right'] == "0") {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                new HomePage(
                    full_details, _signOut)));
          }
          else {
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                new TeacherHome(full_details, _signOut)));
          }
        }

      });



    }

    else
      {
        flag = 0;
        setState(() {

        });
      }
  }

  void _signOut() {

    _googleSignIn.signOut();
    _auth.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
  }

  Future <void> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;


    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: gSA.idToken, accessToken: gSA.accessToken).catchError((onError){print(onError);});



    setState(() {
      ref.child('user_details').orderByChild("uid").equalTo(user.uid)
          .once()
          .then((DataSnapshot data) {
        Map<String,String> user_detail = {'uid':user.uid,"name":user.displayName,"email":user.email};


        if (data.value == null) {
          _message.getToken().then((token) {
            ref.child("tokens").push().set({"token":token});
          });

          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new ProfilePage(user_detail,_signOut)));
        }
        else {
          String key = data.value.keys.toString();

          var full_details = data.value[key.substring(1,key.length-1)];

          print(full_details);
          if(full_details['teacher_right'] == "0")
            {
              Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => new HomePage(
                      full_details, _signOut)));
            }
            else
              {
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) => new TeacherHome(full_details, _signOut)));
              }

        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(

//        appBar: new AppBar(title: new Text("Moodle",style: TextStyle(color: Colors.orangeAccent),),centerTitle: true,backgroundColor: Colors.black.withOpacity(0.8)),

        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          padding: EdgeInsets.all(50.0),
          child: new Column(


            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 20)),
              new FlutterLogo(size: 100.0,),
              new Padding(padding: EdgeInsets.only(top: 50)),
              new Text("Moodle App",style: TextStyle(color: Colors.orangeAccent,fontSize: 40.0),textAlign: TextAlign.center,),
              Padding(padding: EdgeInsets.only(top: 20)),
              new Text("Get the things done at single click",style: TextStyle(color: Colors.deepOrange,fontSize: 20.0,letterSpacing: 5.0),textAlign: TextAlign.center,),
              Padding(padding: EdgeInsets.only(top: 60)),
              flag == 1 ? CircularProgressIndicator() : new Column(
                children: <Widget>[RaisedButton(onPressed: ()=>_signIn(),color: Colors.teal,child: new Text("Get Started",style: TextStyle(fontSize: 18.0),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  padding: EdgeInsets.all(10.0),

                )],
                crossAxisAlignment: CrossAxisAlignment.stretch,

              ),
              new Padding(padding: EdgeInsets.only(top: 40)),
              new Text("Version 1.0",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,)

            ],
          ),
        )
    );
  }
}

