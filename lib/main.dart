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

  void _signOut() {

    _message.getToken().then((token) {
      print(token);
    });
    _googleSignIn.signOut();
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
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => new ProfilePage(user_detail,_signOut)));
        }
        else {
          String key = data.value.keys.toString();

          var full_details = data.value[key.substring(1,key.length-1)];
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
            appBar: new AppBar(title: new Text("Moodle"),
            automaticallyImplyLeading: false,),
            body: new Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new MaterialButton(
                    onPressed: () => _signIn(),
                    child: new Text("Sign in"),
                    color: Colors.green,
                  ),

                ],
              ),
            )
        );
  }
}

