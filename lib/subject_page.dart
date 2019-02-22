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
        mylist.add([val[key]['title'],val[key]['url']]);
      }

      setState(() {

      });
    });
  }

  Future <void> _launchURL(var url) async {

    var dio = Dio();
    print(url);
    var temp_dir = await getExternalStorageDirectory();

    dio.download(url, "${temp_dir.path}/helo",onReceiveProgress:(rec,total){
      print("Rec: ${rec} and Total: ${total}");
      setState(() {
        downloading = true;
        progressBar = ((rec/total)*100).toStringAsFixed(0);

        if(progressBar == "100")
          downloading = false;
      });

        if(progressBar == "100")
          {
            progressBar = "";
            Fluttertoast.showToast(msg: "Downloading Completed!");
          }


    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Subject"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: mylist.length,
          itemBuilder: (context, int index) {
            return ListTile(
              title: new Text(mylist[index][0]),
              onTap: () => _launchURL(mylist[index][1]),
              trailing: downloading == true? new Text("${progressBar}%"):new Text(""),

            );
          },
        ),
      ),
    );
  }

}


