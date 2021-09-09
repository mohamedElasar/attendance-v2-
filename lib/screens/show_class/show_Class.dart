import 'dart:ui';

import 'package:attendance/constants.dart';
import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/show_class/components/Class_top_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Show_Group_Class extends StatefulWidget {
  final String? mygroup_id;
  final GroupModelSimple? mygroup;
  static MaterialPage page(
      {required String groupid, required GroupModelSimple group}) {
    return MaterialPage(
      name: Attendance_Screens.groupclasses,
      key: ValueKey(Attendance_Screens.groupclasses),
      child: Show_Group_Class(
        mygroup_id: groupid,
        mygroup: group,
      ),
    );
  }

  Show_Group_Class({
    Key? key,
    this.mygroup_id,
    this.mygroup,
  }) : super(key: key);

  @override
  _Show_Group_ClassState createState() => _Show_Group_ClassState();
}

class _Show_Group_ClassState extends State<Show_Group_Class> {
  List<String> items = [
    'حصة الأحد',
    'حصة الثلاثاء',
    'حصة الخميس',
    'حصة الأحد',
    'حصة الثلاثاء',
    'حصة الخميس',
  ];
  var colors = [
    kbackgroundColor5.withOpacity(.5),
    kbackgroundColor5.withOpacity(.5),
  ];
  var text_colors = [Colors.white, Colors.black];
  String text = '';

  Map<String, dynamic> _add_data = {
    'year': null,
  };

  bool _isLoading = true;

  @override
  void initState() {
    // print('asdasdasd');
    super.initState();
    Future.delayed(Duration.zero, () async {
      try {
        await Provider.of<AppointmentManager>(context, listen: false)
            .get_appointmentsshow(widget.mygroup_id!)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        print(e);
      }
    });


     
  }

   
  var yearController = TextEditingController();

  String text_value = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Consumer<AppointmentManager>(
                  builder: (builder, appointementmgr, child) =>
                      Show_Class_Top_Page(
                    group: widget.mygroup,
                    size: size,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 20,
                    end: 20,
                    top: 20,
                  ),
                  child:
                      Wrap(spacing: 10.0, runSpacing: 10.0, children: <Widget>[
                    buildChip(widget.mygroup!.name!),
                    buildChip(widget.mygroup!.subject!.name!),
                    // buildChip('مجموعة الياسمين 2'),
                    widget.mygroup!.teacher == null
                        ? Container()
                        : buildChip(widget.mygroup!.teacher!.name!),
                  ]),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'حصص المجموعه',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'GE-Bold', fontSize: 25),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20,
                        end: 20,
                        top: 20,
                      ),
                      child: Container(
                          child: Consumer<AppointmentManager>(
                        builder: (builder, appointmgr, child) => appointmgr
                                .appointmentsshow!.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'لا يوجد حصص فى المجموعه',
                                  style: TextStyle(fontFamily: 'GE-Bold'),
                                ),
                              )
                            : ListView.builder(
                                itemCount: appointmgr.appointmentsshow!.length,
                                itemBuilder: (BuildContext ctxt, int Index) =>
                                    Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  color: colors[Index % colors.length],
                                  child: Dismissible(
                                    direction: DismissDirection.startToEnd,
                                    background: Container(color: Colors.red),
                                    // key: Key(Index.toString()),
                                    key: UniqueKey(),

                                    onDismissed: (dirction) {
                                      if (dirction ==
                                          DismissDirection.startToEnd) {
                                        _showErrorDialogappoint(
                                            'تاكيد مسح الحصة',
                                            'تاكيد',
                                            appointmgr
                                                .appointmentsshow![Index].id!,
                                            widget.mygroup_id!);
                                      }
                                    },
                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: () {
                                          Provider.of<AppStateManager>(context,
                                                  listen: false)
                                              .gotosinglelessonabs(
                                                  true,
                                                  appointmgr
                                                      .appointmentsshow![Index]
                                                      .id!
                                                      .toString(),
                                                  appointmgr.appointmentsshow![
                                                      Index]);
                                        },
                                        child: Text(
                                          'الغياب',
                                          style: TextStyle(
                                              fontFamily: 'GE-light',
                                              color: kbuttonColor1),
                                        ),
                                      ),
                                      subtitle: Text(
                                        ' الساعه :   ${appointmgr.appointmentsshow![Index].time!}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            // color: text_colors[Index % colors.length],
                                            fontFamily: 'GE-light'),
                                      ),
                                      onTap: () {
                                        Provider.of<AppStateManager>(context,
                                                listen: false)
                                            .goToSinglelessonattend(
                                                true,
                                                appointmgr
                                                    .appointmentsshow![Index].id
                                                    .toString(),
                                                appointmgr
                                                    .appointmentsshow![Index]);
                                      },
                                      title: Text(
                                        'تاريخ الحصه :   ${appointmgr.appointmentsshow![Index].date!}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            // color: text_colors[Index % colors.length],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE-medium'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
    ));
  }

  void _showErrorDialogappoint(
      String message, String title, int id, String group_id) {
    showDialog(
      barrierDismissible: false,
      context: this.context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
        ),
        actions: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.red.withOpacity(.6))),
                    // color: kbackgroundColor1,
                    child: Text(
                      'نعم',
                      style: TextStyle(
                          fontFamily: 'GE-medium', color: Colors.black),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      Navigator.of(ctx).pop();

                      await Provider.of<AppointmentManager>(this.context,
                              listen: false)
                          .delete_appointment(id)
                          .then((value) => Provider.of<AppointmentManager>(
                                  this.context,
                                  listen: false)
                              .get_appointmentsshow(group_id))
                          .then((_) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(.6))),
                    // color: kbackgroundColor1,
                    child: Text(
                      'لا',
                      style: TextStyle(
                          fontFamily: 'GE-medium', color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
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
        backgroundColor: kbackgroundColor5,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      );
}
