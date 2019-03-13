import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherHome extends StatefulWidget {
  var details;
  final Function callback;

  TeacherHome(this.details, this.callback);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  List myList;
  bool uploadStatus = false;
  File samplePdf;
  String _title_resource;
  String _subSelected;
  List<DropdownMenuItem<String>> subList = new List();
  List<DropdownMenuItem<String>> temp;
  String _semSelected;
  List<DropdownMenuItem<String>> semList = new List();

  DatabaseReference ref = FirebaseDatabase.instance.reference();
  
  @override
  void initState() {

    
    String sem;
    myList = new List();
    ref
        .child("user_details")
        .orderByChild('uid')
        .equalTo(widget.details['uid'])
        .once()
        .then((DataSnapshot ans) {
      var keys = ans.value.keys;
      var val = ans.value;
      for (var key in keys) {
                sem = val[key]['sem'];
                print(sem);

      }

      setState(() {});

      ref.child("subjects").child(sem).child(widget.details['branch']).once().then((DataSnapshot data) {
        var keys = data.value.keys;
        var val = data.value;

        for (var key in keys) {
          myList.add(key);
        }
        setState(() {

        });
      });
    });
  }
  String status ="";
  Future _addFile() async {
    var dowurl = null;

    String url = "";
    StorageReference st_ref = FirebaseStorage.instance
        .ref()
        .child(_subSelected)
        .child(_title_resource);
    StorageUploadTask task = st_ref.putFile(samplePdf);

    setState(() {
      if(url=="")
        uploadStatus = true;

    });


      dowurl = await (await task.onComplete).ref.getDownloadURL();
      url = dowurl.toString();
      //Type hard coded to pdf
      ref.child("subjects").child(_semSelected).child(widget.details['branch']).child(_subSelected).push().set({"title":_title_resource,"url":url,"type":"pdf"});
    uploadStatus =false;
Fluttertoast.showToast(msg: "File Upload Succesful!");
      setState(() {

      });

  }

  void getFilePath() async {
    try {
      String filePath = await FilePicker.getFilePath(type: FileType.ANY);
      if (filePath == '') {
        return;
      }
      setState(() {
        samplePdf = new File(filePath);
      });
    } on Exception catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  void getSub() {
    subList.clear();
    for (String subject in myList) {
      subList.add(new DropdownMenuItem(
        child: new Text(subject),
        value: subject,
      ));
    }

    semList.clear();
    for (String sem in ["1","2","3","4","5","6","7","8"] ) {
      semList.add(new DropdownMenuItem(
        child: new Text(sem),
        value: sem,
      ));
    }

  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Upload Data"),
          content: new Text("Are you sure? You want to upload data?"),
          actions: <Widget>[
            new FlatButton(onPressed: () {
              Navigator.of(context).pop();
              _addFile();
              }, child: new Text("Upload")),
            new FlatButton(onPressed: () => Navigator.of(context).pop(), child: new Text("Close"))
          ],
        );
      }

    );
  }

  @override
  Widget build(BuildContext context) {
    getSub();
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
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
                onTap: () => {},
              ),
              Divider(),
              new ListTile(
                leading: Icon(Icons.notifications),
                title: new Text("Noticeboard"),
                onTap: () => {},
              ),

              Divider(),
              new ListTile(
                leading: Icon(Icons.clear),
                title: new Text("Sign Out"),
                onTap: () => widget.callback(),
              )
            ],
          ),
        ),
        appBar: new AppBar(title: Text("Welcome Home",style: TextStyle(color: Colors.orange),),backgroundColor: Colors.black, bottom: TabBar(
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.assignment),
            ),
            Tab(
              icon: Icon(Icons.add_box),
            )
          ],
        ),),

        body: TabBarView(
          children: <Widget>[TeacherSubs(), AddItem()],
        ),
      ),
    );
  }

  Widget TeacherSubs() {

    return Container(
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: new Text("Compiler Design"),
              onTap: () => {},
            ),
          ),
          Card(
            child: ListTile(
              title: new Text("Operating Systems"),
              onTap: () => {},
            ),
          ),
        ],
      ),
    );
  }

  Widget AddItem() {
    return Container(
      padding: EdgeInsets.all(40.0),
      child: Column(
        children: <Widget>[

          DropdownButton(
            hint: new Text("Select Subject"),
            items: subList,
            value: _subSelected,
            onChanged: (value) {
              _subSelected = value;
              setState(() {});
            },
            isExpanded: true,
          ),

          DropdownButton(
            hint: new Text("Select Sem"),
            items: semList,
            value: _semSelected,
            onChanged: (value) {
              _semSelected = value;
              setState(() {});
            },
            isExpanded: true,
          ),

          TextField(
            decoration: InputDecoration(labelText: "Title to the Resource"),
            onTap: () => {},
            onChanged: (value) {
              _title_resource = value;
              setState(() {});
            },

          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          uploadStatus == true? new CircularProgressIndicator(

          ):new Text(""),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  "Select Data",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.grey,
                onPressed: getFilePath,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
              ),
              MaterialButton(
                child: Text(
                  "Upload Data",
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.grey,
                onPressed: _showDialog,
              ),

            ],
          )
        ],
      ),
    );
  }
}
