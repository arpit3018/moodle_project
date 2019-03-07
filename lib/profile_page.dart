import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'student_home.dart';
import 'teacher_home.dart';

class ProfilePage extends StatefulWidget {
  Function callback;
  Map<String,String> user_details;
  ProfilePage(this.user_details,this.callback);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _EnrollmentNumber;
  List <DropdownMenuItem<int>> yearList = new List();
  List <DropdownMenuItem<String>> branchList = new List();
  List <DropdownMenuItem<int>> semList = new List();
  List <DropdownMenuItem<String>> profession = new List();

  String branch_selected = null;
  int sem_selected = null;
  int year_selected = null;
  String profession_selected = null;


  DatabaseReference ref = FirebaseDatabase.instance.reference();

  void _pushData() {
    final form = formKey.currentState;

    if(form.validate())
    {
      form.save();


      if(profession_selected == "professor")
        {
          widget.user_details['teacher_right'] = "1";
          widget.user_details["profID"] = _EnrollmentNumber;
          widget.user_details["branch"] = branch_selected;
        }
      else
        {
          widget.user_details["enrollment"] = _EnrollmentNumber;
          widget.user_details["year"] = year_selected.toString();
          widget.user_details["branch"] = branch_selected;
          widget.user_details['teacher_right'] = "0";

          if(sem_selected == 1)
          {
            widget.user_details["sem"] = (sem_selected*year_selected - 1).toString();
          }
          else
            widget.user_details["sem"] = (sem_selected*year_selected).toString();
        }


      widget.user_details['profession'] = profession_selected;
      ref.child("user_details").push().set(widget.user_details);
      if(widget.user_details['teacher_right'] == "0")
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new HomePage(widget.user_details,widget.callback)));
      else
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new TeacherHome(widget.user_details,widget.callback)));
    }

  }

  void add_year(){
    yearList.clear();
    yearList.add(new DropdownMenuItem(
        child: new Text('1st Year'),
        value: 1
    ));
    yearList.add(new DropdownMenuItem(
        child: new Text('2nd Year'),
        value: 2
    ));
    yearList.add(new DropdownMenuItem(
        child: new Text('3rd Year'),
        value: 3
    ));
    yearList.add(new DropdownMenuItem(
        child: new Text('4th Year'),
        value: 4
    ));

  }

  void add_sem(){
    semList.clear();
    semList.add(new DropdownMenuItem(
        child: new Text('Sem A'),
        value: 1
    ));
    semList.add(new DropdownMenuItem(
        child: new Text('Sem B'),
        value: 2
    ));

  }

  void add_branch(){
    branchList.clear();
    branchList.add(new DropdownMenuItem(
        child: new Text('Information Technology'),
        value: "IT"
    ));
    branchList.add(new DropdownMenuItem(
        child: new Text('Computer Science'),
        value: "CSE"
    ));

  }

  void add_profession() {

    profession.clear();
    profession.add( new DropdownMenuItem(
      child: new Text("Student"),
      value: "student",
    ));

    profession.add( new DropdownMenuItem(
      child: new Text("Professor"),
      value: "professor",
    ));
  }


  @override
  Widget build(BuildContext context) {
    add_year();
    add_branch();
    add_sem();
    add_profession();
    return Scaffold(
      key: scaffoldKey,
      body: new Container(
          padding: EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: new ListView(

              children: <Widget>[
                new Text("User Profile" ,style: new TextStyle(fontSize: 30.0,color: Colors.blue),),


                new DropdownButtonFormField(
                  items: profession,
                  hint: new Text("Select Profession"),
                  value: profession_selected,
                  onChanged: (value) {
                    profession_selected = value;
                    setState(() {
                    });
                  },
                ),
                profession_selected == "student"?StudentProfile():(profession_selected == "professor"?TeacherProfile():new Text("Please Select the Profession")),

                new MaterialButton(onPressed: widget.callback,color: Colors.red,child: new Text("Sign Out"),)

              ],
            ),
          )
      ),
    );
  }


  Widget StudentProfile(){
    return Column(

      children: <Widget>[
        new DropdownButtonFormField(
          items: branchList,
          hint: new Text("Select Branch"),
          value: branch_selected,
          onChanged: (value) {
            branch_selected = value;
            setState(() {
              print(branch_selected);
            });
          },
        ),
        new DropdownButtonFormField(
          items: yearList,
          hint: new Text("Select Year"),
          value: year_selected,
          onChanged: (value) {
            year_selected = value;
            setState(() {
              print(year_selected);
            });
          },
        ),
        new DropdownButtonFormField(
          items: semList,
          hint: new Text("Select Sem"),
          value: sem_selected,
          onChanged: (value) {
            sem_selected = value;
            setState(() {
              print(sem_selected);
            });
          },
        ),
        new TextFormField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(labelText: "Enrollment Number"),
          validator: (val) => !val.contains("IT")?"Enrollment number not valid":null,
          onSaved: (val) => _EnrollmentNumber = val,
        ),
        new MaterialButton(

          onPressed: ()=> _pushData(),
          color: Colors.green,
          child: new Text("Next"),

        )
      ],

    );
  }

  Widget TeacherProfile(){
    return Column(
      children: <Widget>[
        new DropdownButtonFormField(
          items: branchList,
          hint: new Text("Select Branch"),
          value: branch_selected,
          onChanged: (value) {
            branch_selected = value;
            setState(() {
              print(branch_selected);
            });
          },
        ),

        new TextFormField(
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(labelText: "Professor ID"),
          validator: (val) => !val.contains("IT")?"Enrollment number not valid":null,
          onSaved: (val) => _EnrollmentNumber = val,
        ),

        new MaterialButton(
          onPressed: ()=> _pushData(),
          color: Colors.green,
          child: new Text("Next"),

        )
      ],

    );
  }
}
