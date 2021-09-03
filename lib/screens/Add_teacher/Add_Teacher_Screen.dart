import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/subject_manager.dart';
import 'package:attendance/models/teacher.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/Add_teacher/components/Teacher_Form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Add_Teacher_Screeen extends StatelessWidget {
  final bool? edit;
  final TeacherModel? myTeacher;

  static MaterialPage page({bool? medit, TeacherModel? editTeacher}) {
    return MaterialPage(
      name: Attendance_Screens.teacher_registerpath,
      key: ValueKey(Attendance_Screens.teacher_registerpath),
      child: Add_Teacher_Screeen(
        edit: medit,
        myTeacher: editTeacher,
      ),
    );
  }

  const Add_Teacher_Screeen({Key? key, this.edit, this.myTeacher})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final GlobalKey<ScaffoldState> _scaffoldKey =
    //     new GlobalKey<ScaffoldState>();

    return SafeArea(
      child: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          title: Center(
            child: Text(
              edit! ? 'تعديل معلم' : 'تسجيل معلم',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'AraHamah1964B-Bold'),
            ),
          ),
          actions: [
            SizedBox(width: 10),
            CircleAvatar(
              minRadius: 25,
              backgroundImage: AssetImage('assets/images/pic2.png'),
            ),
            SizedBox(
              width: 30,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  // Provider.of<SubjectManager>(context, listen: false)
                  //     .resetlist();
                  Provider.of<AppStateManager>(context, listen: false)
                      .registerTeacher(false);
                  Provider.of<AppStateManager>(context, listen: false)
                      .teacherTapped('id', false, TeacherModel());
                },
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            )
            // SizedBox(
            //   width: 70,
            // ),
            // Icon(
            //   Icons.save_rounded,
            //   color: Colors.orange[200],
            //   size: 40,
            // ),
            // SizedBox(
            //   width: 20,
            // )
          ],
          elevation: 0,
          // leading: Icon(
          //   Icons.menu,
          //   color: Colors.black,
          // ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
            child: Teacher_Form(size: size, edit: edit, eteacher: myTeacher)),
      ),
    );
  }
}
