import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/models/appointment.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'components/AbsTopPage.dart';
import 'components/Students_page_title.dart';

import 'components/table/Row_builder.dart';
import 'components/table/table_head.dart';

class Absence_Show extends StatelessWidget {
  final String? lessonid;
  final AppointmentModel? mylesson;
  static MaterialPage page({
    required String less_id,
    required AppointmentModel lesson,
  }) {
    return MaterialPage(
      name: Attendance_Screens.abscence_show,
      key: ValueKey(Attendance_Screens.abscence_show),
      child: Absence_Show(
        lessonid: less_id,
        mylesson: lesson,
      ),
    );
  }

  const Absence_Show({
    Key? key,
    this.lessonid,
    this.mylesson,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // print(groupid);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kbackgroundColor2,
        body: (Column(
          children: [
            AbsTopPage(size: size, lessonid: lessonid),
            // Consumer<AppStateManager>(
            //   builder: (builder, appstatemanager, child) => Students_Page_Title(
            //       title: appstatemanager.getGroupSelected.name),
            // ),

            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20, end: 20, top: 20, bottom: 20),
              child: Wrap(spacing: 10.0, runSpacing: 10.0, children: <Widget>[
                buildChip(mylesson!.name!),
                // buildChip(mylesson!.time!),
                // buildChip('مجموعة الياسمين 2'),
                // widget.mygroup!.teacher == null
                //     ? Container()
                //     : buildChip(widget.mygroup!.teacher!.name!),
              ]),
            ),
            Expanded(
              child: Column(
                children: [
                  TABLE_HEAD(size: size),
                  Rows_Builder(lessonid: lessonid, size: size),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget buildChip(text) => Chip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE-medium'),
        ),
        backgroundColor: kbackgroundColor2,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      );
}
