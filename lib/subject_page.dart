import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubjectPage extends StatefulWidget {
  var subname;
  var details;
  SubjectPage(this.subname, this.details);

  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<List<String>> mylist;

  bool downloading = false;
  var progressBar = "";




  @override
  void initState() {


    DatabaseReference ref = FirebaseDatabase.instance.reference();
    mylist = new List();
    ref
        .child("subjects")
        .child(widget.details['sem'])
        .child(widget.details['branch'])
        .child(widget.subname)
        .once()
        .then((DataSnapshot data) {
      var keys = data.value.keys;
      var val = data.value;

      for (var key in keys) {
        mylist.add([val[key]['title'],val[key]['url'],val[key]['type']]);
        print(mylist);
      }

      setState(() {

      });
    });
  }
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Downloading Data"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator()
              ],
            ),
            actions: <Widget>[
        ]
          );
        }

    );
  }

  Future <void> _launchURL(String title,var url, String type) async {

    _showDialog();
    var dio = Dio();
    title = title.replaceAll(new RegExp(r' '), '_');
    type = type.toLowerCase();
    var temp_dir = await getExternalStorageDirectory();
    print(temp_dir);
    dio.download(url, "${temp_dir.path}/${title}.${type}",onReceiveProgress:(rec,total){
      String out_url = "${temp_dir.path}/${title}.${type}";
      print("Rec: ${rec} and Total: ${total}");
      setState(() {
        downloading = true;
        progressBar = ((rec/total)*100).toStringAsFixed(0);

        if(progressBar == "100")
          downloading = false;
      });

        if(progressBar == "100")
          {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            Fluttertoast.showToast(msg: "Downloading Completed!");
          }


    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Subjects",style: TextStyle(color: Colors.orange),),backgroundColor: Colors.black,),
      body: Container(
        child: ListView.builder(
          itemCount: mylist.length,
          itemBuilder: (context, int index) {
            return Card(
              child: ListTile(
                title: new Text(mylist[index][0]),
                onTap: () => _launchURL(mylist[index][0],mylist[index][1],mylist[index][2]),

              ),
            );
          },
        ),
      ),
    );
  }

}


