import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

class ProfileUpdate extends StatefulWidget {

  var teacher_right;
  ProfileUpdate(this.teacher_right);
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {

  String _semSelected;
  List<DropdownMenuItem<String>> semList = new List();
  void getSub() {

    semList.clear();
    for (String sem in ["1","2","3","4","5","6","7","8"] ) {
      semList.add(new DropdownMenuItem(
        child: new Text(sem),
        value: sem,
      ));
    }

  }

  void _updateProfile() {
    Fluttertoast.showToast(msg: "Profile Updated!");
  }

  @override
  Widget build(BuildContext context) {
    getSub();
    return Scaffold(
      appBar: new AppBar(title: Text("Profile",style: TextStyle(color: Colors.orange),),backgroundColor: Colors.black,),
      body: Container(
        padding: EdgeInsets.all(20.0),

        child: Column(
          children: <Widget>[
            new CircleAvatar(
              child: new Text(widget.teacher_right["name"][0],style: TextStyle(
                fontSize: 25.0,
              ),),
              minRadius: 30.0,
            ),
            TextFormField(
              enabled: false,
              decoration: InputDecoration(
                hintText: widget.teacher_right["name"],
              ),
            ),
            TextFormField(
              enabled: false,
              decoration: InputDecoration(
                hintText: widget.teacher_right["branch"],
              ),
            ),
            DropdownButton(
              hint: new Text(widget.teacher_right["sem"]),
              items: semList,
              value: _semSelected,
              onChanged: (value) {
                _semSelected = value;
                setState(() {});
              },
              isExpanded: true,
            ),
            TextFormField(
              enabled: false,
              decoration: InputDecoration(
                hintText: widget.teacher_right["enrollment"],
              ),
            ),
            new Padding(padding: EdgeInsets.only(top: 10.0)),
            MaterialButton(
              onPressed: ()=> _updateProfile(),
              child: new Text("Update"),
              color: Colors.green,
            )
          ],
        ),
      ),

    );
  }


}
