import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'subject_page.dart';
import 'teacher_home.dart';

class HomePage extends StatefulWidget {

  var details;
  final Function callback;
  HomePage(this.details,this.callback);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<String> myList;
  var subject_data;
  @override
  void initState() {

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    myList = new List();
    ref.child("subjects").child(widget.details['sem']).child(widget.details['branch']).once().then((DataSnapshot data) {
      var keys = data.value.keys;
      var val = data.value;
      for(var key in keys){
        myList.add(key);
      }

      setState(() {
        subject_data = val;
      });

    });
  }

  void _subject(String subname) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new SubjectPage(subname,widget.details)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Welcome Home"),),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(widget.details["name"]),
              accountEmail: new Text(widget.details["email"]),

              currentAccountPicture: new CircleAvatar(backgroundColor: Colors.green,child: new Text('A'),),
            ),

            new ListTile(
              leading: Icon(Icons.account_box),
              title: new Text("Profile"),
              onTap: () =>{},
            ),

            new ListTile(
              leading: Icon(Icons.clear),
              title: new Text("Sign Out"),
              onTap: ()=>widget.callback(),
            )



          ],
        ),
      ),
      body: new ListView.builder(

        itemCount: myList==null?0:myList.length,
        itemBuilder: (context,int index) {
          return ListTile(
            title: new Text("${myList[index]}"),
            onTap: ()=>_subject(myList[index]),
          );
        }


      ),

    );
  }
}
