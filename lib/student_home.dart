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
      appBar: new AppBar(title: Text("Welcome Home",style: TextStyle(color: Colors.orange),),backgroundColor: Colors.black,),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(

              accountName: new Text(widget.details["name"]),
              accountEmail: new Text(widget.details["email"]),
              decoration: BoxDecoration(color: Colors.black87),
              currentAccountPicture: new CircleAvatar(backgroundColor: Colors.indigo,child: new Text(widget.details['name'][0]),),
            ),

            new ListTile(
              leading: Icon(Icons.account_box),
              title: new Text("Profile"),
              onTap: () =>{},
            ),
            new Divider(),
            new ListTile(
              leading: Icon(Icons.notifications),
              title: new Text("Noticeboard"),
              onTap: () => {},
            ),
            new Divider(),
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
          return Card(child:
          ListTile(
            title: new Text("${myList[index]}"),
            onTap: ()=>_subject(myList[index]),
          ),);
        }


      ),

    );
  }


}
