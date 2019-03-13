import "package:flutter/material.dart";
import 'package:file_picker/file_picker.dart';
import 'dart:io';
class NoticeBoard extends StatefulWidget {

  String teacher_right;
  NoticeBoard(this.teacher_right);
  @override
  _NoticeBoardState createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {

  File samplePdf;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Noticeboard",style: TextStyle(color: Colors.orange),),backgroundColor: Colors.black,),
      body: Container(
        child: widget.teacher_right == "0" ? NoticeStudent() : NoticeTeacher()
      ),

    );
  }

  Widget NoticeTeacher(){

    return ListView(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 10.2),),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new MaterialButton(onPressed: getFilePath, child: new Text("Select Notice"),color: Colors.indigo,),
            new MaterialButton(onPressed: ()=>{}, child: new Text("Upload Notice"),color: Colors.green,),
          ],
        ),

        Divider(),
        Card(
          child: new ListTile(
            title: new Text("Attendence Report"),
          ),
        ),
        Card(
          child: new ListTile(
            title: new Text("Placed Student"),
          ),
        ),
        Card(
          child: new ListTile(
            title: new Text("Workshop details"),
          ),
        ),
      ],
    );

  }

  Widget NoticeStudent(){
    return ListView(
      children: <Widget>[

        Card(
          child: new ListTile(
            title: new Text("Attendence Report"),
          ),
        ),
        Card(
          child: new ListTile(
            title: new Text("Placed Student"),
          ),
        ),
        Card(
          child: new ListTile(
            title: new Text("Workshop details"),
          ),
        ),
      ],
    );


  }
}
