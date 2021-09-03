// import 'dart:html';
import 'dart:io';

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:attendance/constants.dart';
import 'package:attendance/helper/httpexception.dart';
import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/managers/subject_manager.dart';
import 'package:attendance/managers/teacher_manager.dart';
import 'package:attendance/managers/year_manager.dart';
import 'package:attendance/models/Student4SearchModel.dart';
import 'package:attendance/models/StudentSearchModel.dart';
import 'package:attendance/models/teacher.dart';
import 'package:attendance/screens/Home/Home_Screen.dart';
import 'package:attendance/screens/Home/components/code_data.dart';
import 'package:attendance/screens/Home/components/home_data.dart';
import 'package:attendance/screens/Home/components/home_repository.dart';
import 'package:attendance/screens/Home/components/init.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:moor/moor.dart' as prefix;
// import 'package:sqflite_common/sqlite_api.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// part 'example.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'dart:io';
// import 'package:sqlite3/sqlite3.dart' as prefix;
// import 'package:path/path.dart';
import 'package:provider/provider.dart';
//  import 'package:sqflite/sqflite.dart';

// import 'package:sqflite_common/sqlite_api.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
// import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sembast/utils/sembast_import_export.dart';

import '../../../constants.dart';
import '../Home_Screen.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';

// import '../../../constants.dart';
// import '../Home_Screen.dart';
// import 'code_data.dart';
// import 'home_data.dart';
bool record_attend = false;
List attended_code = [];
bool is_ok = false;
List<HomeData> home_data = [];
List<CodeData> code_data = [];
List teacher_no_dublicate = [];
List group_codes = [];
List<String> group_id_list = [];
List<String> class_id_list = [];
List group_code_no_dublicate = [];
List class_no_dublicate = [];
List home_no_dublicate = [];
List group_no_dublicate = [];
List subject_no_dublicate = [];
bool no_internet = false;
List my_year_list = [];
List my_appointment_list = [];
List my_teacher_list = [];
List my_group_list = [];
List my_subject_list = [];
String mygroup_id = '';
List myclass_id = [];
String path = '';
late String year_id_selected;
String yearname = 'السنه الدراسيه';
late String subjectId_selected;
String subjectname = 'الماده الدراسيه';
late String teacher_id_selected;
String teachername = 'المدرس';
late String group_id_selected;
String group_name = 'المجموعه';
int group_id = 0;
String? app_id_selected;
String app_name = 'اختر حصه';

class Choices extends StatefulWidget {
  // static String groupr = group_name;
  // String get name => group_name;

  Choices({
    Key? key,
    required this.size,
    this.usser,
    this.teacher,
  }) : super(key: key);

  final Size size;
  // static int my_group = group_id;
  String mygroup_name = group_name;
  int my_group = group_id;

  final user? usser;
  final TeacherModel? teacher;
  @override
  _ChoicesState createState() => _ChoicesState();
}

// late String year_id_selected;
// String yearname = 'السنه الدراسيه';
// late String subjectId_selected;
// String subjectname = 'الماده الدراسيه';
// late String teacher_id_selected;
// String teachername = 'المدرس';
// late String group_id_selected;
// String group_name = 'المجموعه';
// late String app_id_selected;
// String app_name = 'اختر حصه';

late String scanResult_code;

class _ChoicesState extends State<Choices> {
  final Future _init = Init.initialize();
  HomeDataRepository _dataRepository = GetIt.I.get();
  // CodeDataRepository _codeRepository = GetIt.I.get();
  List<HomeData> _homedata = [];
  List<CodeData> _codedata = [];
  // static late ConnectivityResult _connectionStatus;
  // Connectivity? connectivity;
  // StreamSubscription<ConnectivityResult>? subscription;
  bool check_connectivity(context) {
    setState(() {
      Provider.of<InternetConnectionStatus>(context);
    });
    if (Provider.of<InternetConnectionStatus>(context) ==
        InternetConnectionStatus.disconnected) {
      return false;
      //print('no interrrnet');
    } else {
      // print('yes interrrnet');
      return true;
    }

    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.wifi) {
    //   return true;
    // } else {
    //   setState(() {
    //     no_internet = true;
    //   });
    //   return false;
    // }
  }

  ScrollController _sc1 = new ScrollController();
  ScrollController _sc2 = new ScrollController();
  ScrollController _sc3 = new ScrollController();
  ScrollController _sc4 = new ScrollController();
  void dispose() {
    _sc1.dispose();
    _sc2.dispose();
    _sc3.dispose();

    super.dispose();
  }

  bool _isloadingyears = true;
  bool _isloadingsubjects = false;
  bool _isloadingteachers = false;
  bool _isloadinggroups = false;
  bool _isloadingappointment = false;
  bool _scanloading = false;
  bool _isinit = true;

  _loadData() async {
    //    for (var i = 0; i < home_data.length;i++) {
    //   _deleteData(home_data[i].id!);
    // }
    home_data = await _dataRepository.getAllHomeData();
    setState(() => _homedata = home_data);
    print('hooooooooooooooooooome');
    print(home_data);
  }

  _loadCodeData() async {
    code_data = await _dataRepository.getAllCodeData();
    setState(() => _codedata = code_data);

    // for (var i = 0; i < code_data.length; i++) {
    //   _deleteCode(code_data[i].id!);
    //   // print('coooooooode');
    //   // print(code_data[i].groupid);
    //   // print(code_data[i].code);
    // }
  }

  _addCodeData(String _code, String _groupid) async {
    //  for (var i = 0; i < code_data.length; i++) {
    //   _deleteCode(code_data[i].id!);
    //   // print('coooooooode');
    //   // print(code_data[i].groupid);
    //   // print(code_data[i].code);
    // }
    final code = "$_code";
    final groupid = "$_groupid";

    final newCodeData = CodeData(code: code, groupid: groupid);
    // for (var i = 0; i < code_data.length; i++) {
    // if(code_data[i].code==code)
    await _dataRepository.insert(newCodeData);
  }

  _addData(String _year, String _subject, String _teacher, String _groupname,
      String _classname, String _groupid, String _classid) async {
    //        for (var i = 0; i < home_data.length;i++) {
    //   _deleteData(home_data[i].id!);
    // }
    final year = "$_year";
    final subject = "$_subject";
    final teacher = "$_teacher";
    final groupname = "$_groupname";
    final classname = "$_classname";
    final groupid = "$_groupid";
    final classid = "$_classid";
    final newHomeData = HomeData(
        year: year,
        subject: subject,
        teacher: teacher,
        groupname: groupname,
        classname: classname,
        groupid: groupid,
        classid: classid);
    await _dataRepository.insertHomeData(newHomeData);
  }

  _deleteData(int id) async {
    await _dataRepository.deleteHomeData(id);
    _loadData();
  }

  _deleteCode(int id) async {
    await _dataRepository.deleteCodeData(id);
    _loadCodeData();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      yearname = 'السنه الدراسيه';
      subjectname = 'الماده الدراسيه';
      teachername =
          widget.usser != user.teacher ? 'المدرس' : widget.teacher!.name!;
      if (widget.usser == user.teacher) {
        teacher_id_selected = widget.teacher!.id!.toString();
      }
      group_name = 'المجموعه';
      app_name = 'الحصه';
      Provider.of<GroupManager>(this.context, listen: false).resetlist();
      Provider.of<TeacherManager>(this.context, listen: false).resetlist();
      // Provider.of<YearManager>(context, listen: false).resetlist();
      Provider.of<SubjectManager>(this.context, listen: false).resetlist();
      Provider.of<YearManager>(this.context, listen: false).resetlist();
      try {
        await Provider.of<YearManager>(this.context, listen: false)
            .getMoreData()
            .then((value) {
          setState(() {
            _isloadingyears = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;
    });

    _sc1.addListener(
      () {
        if (_sc1.position.pixels == _sc1.position.maxScrollExtent) {
          Provider.of<YearManager>(this.context, listen: false).getMoreData();
        }
      },
    );
    _sc2.addListener(
      () {
        if (_sc2.position.pixels == _sc2.position.maxScrollExtent) {
          Provider.of<SubjectManager>(this.context, listen: false)
              .getMoreDatafiltered(year_id_selected.toString());
        }
      },
    );
    _sc3.addListener(
      () {
        if (_sc3.position.pixels == _sc3.position.maxScrollExtent) {
          Provider.of<TeacherManager>(this.context, listen: false)
              .getMoreDatafiltered(year_id_selected, subjectId_selected);
        }
      },
    );
    _sc4.addListener(
      () {
        if (_sc4.position.pixels == _sc4.position.maxScrollExtent) {
          Provider.of<GroupManager>(this.context, listen: false)
              .getMoreDatafiltered(
                  year_id_selected, subjectId_selected, teacher_id_selected);
        }
      },
    );
    Future.delayed(Duration.zero, () async {
      Provider.of<GroupManager>(this.context, listen: false).resetlist();
      try {
        await Provider.of<GroupManager>(this.context, listen: false)
            .getMoreGroupsOffline()
            // .getMoreGroupOffline(55)
            .then((_) {
          setState(() {
            // _isloading = false
          });

          print('WHATTTTTT THIS GROUP ');
          for (var i = 0; i < GroupManager.all_groups_offline.length; i++) {
            //for (var i = 0; i < GroupManager.onegroupoffline.length; i++) {
            print(GroupManager.all_groups_offline);
          }
          for (var i = 0; i < GroupManager.all_groups_offline.length; i++) {
            //for (var i = 0; i < GroupManager.onegroupoffline.length; i++) {
            //print(GroupManager.all_groups_offline);
            // }
            //for (var i = 0; i < GroupManager.groupsoffline.length; i++) {
            print('group nameee');
            // print(GroupManager.groupsoffline[i].id);
            Future.delayed(Duration.zero, () async {
              try {
                // GroupManager group_manager = new GroupManager();
                await Provider.of<GroupManager>(this.context, listen: false)
                    .get_all_students_offline(
                        GroupManager.all_groups_offline[i].id!)
                    .then((value) {
                  // print('group name');
                  print('group nametttttttttttttt');
                  print(GroupManager.stagesList);
                  print(GroupManager.stagesList[0]['code']['code']);
                  print('${GroupManager.all_groups_offline[0].id}');
                  //print(group_manager.groups);
                  setState(() {
                    _isloadingyears = false;
                  });
                  print('my coooode');
                  //print(GroupManager.groupsoffline[i].id!);
                  for (var k = 0; k < GroupManager.stagesList.length; k++) {
                    _addCodeData(GroupManager.stagesList[k]['code']['code'],
                        '${GroupManager.all_groups_offline[i].id}');
                    // GroupManager.all_groups_offline[k].id

                  }
                });
              } catch (e) {}
            });
            ////

            ///
            Future.delayed(Duration.zero, () async {
              try {
                //GroupManager group_manager = new GroupManager();
                await Provider.of<GroupManager>(this.context, listen: false)
                    .get_group_offline(GroupManager.all_groups_offline[i].id!)
                    .then((value) {
                  print('group data  counttttttt');
                  // print(GroupManager.group_info['appointments'].length);
                  setState(() {
                    _isloadingyears = false;
                  });
                  if (GroupManager.group_info.isNotEmpty) {
                    for (var j = 0; j < GroupManager.group_info.length; j++) {
                      //   // add_record(
                      //   //   GroupManager.groupsoffline[i].year!.name!,
                      //   //   GroupManager.groupsoffline[i].subject!.name!,
                      //   //   GroupManager.groupsoffline[i].teacher!.name!,
                      //   //   GroupManager.groupsoffline[i].name!,
                      //   //   GroupManager.group_info['appointments'][j]['name'],
                      //   // );

                      print('ggggggggggg');
                      // print(GroupManager.group_info[i].appointments![0].name);
                      // print(GroupManager.group_info[9].appointments![0]['id']);
                      _addData(
                        GroupManager.all_groups_offline[i].year!.name!,
                        GroupManager.all_groups_offline[i].subject!.name!,
                        GroupManager.all_groups_offline[i].teacher!.name!,
                        GroupManager.all_groups_offline[i].name!,

                        GroupManager.group_info[j]['name'],
                        ' ${GroupManager.all_groups_offline[i].id}',
                        '${GroupManager.group_info[j]['id']}',
                        //   'fwhat','ii','tt','rrt',
                        //   'uu','rr'
                        //  ,'jj'
                      );
                    }
                  }
                });
                print('NO OF CLASSES');
                // print(GroupManager.group_info[0]['appointments'].length);
                print('whatttty');
                // print(GroupManager.groupsoffline[0].year!.name!);
                // print(GroupManager.groupsoffline[0].subject!.name!);
                // print(GroupManager.groupsoffline[0].teacher!.name!);
                // print(GroupManager.groupsoffline[0].name!);
                // print(GroupManager.group_info);
                // print(' ${GroupManager.groupsoffline[0].id}');
                // print(GroupManager.group_info[0]['appointments'][0]['id']);

                // for (var j = 0;
                //     j < GroupManager.group_info['appointments'].length;
                //     j++) {
                // add_record(
                //   GroupManager.group_info['year']['name'],
                //   GroupManager.group_info['subject']['name'],
                //   GroupManager.group_info['teacher']['name'],
                //   GroupManager.group_info['name'],
                //   GroupManager.group_info['appointments'][0]['name'],
                // );
                // }

                // print('group name');
                // print(await GroupManager.groupsoffline);
              } catch (e) {}
            });
          }
          print('_homedataaaaaaaaaaaa');
          print(home_data);
          print('_homedataaaaaaaaaaaa');
          ////
          // }
        });
      } catch (e) {}
      if (!mounted) return;
    });

    print('WHATTTTTT THIS GROUP ');
    print(GroupManager.all_groups_offline);

    super.initState();
  }

  FocusNode focusNode = FocusNode();

  bool _loadingscann = false;
  List<String> formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('hh:mm'); //"6:00 AM"
    final dateformate = DateFormat('y-M-d');
    return [format.format(dt), dateformate.format(dt)];
  }

  String code_from_windows = '';
  String newLessonTime = '';
  String newLessonDate = '';
  // GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  void _modalBottomSheetMenuyearOffline(BuildContext context) {
    // _loadCodeData();
    print('kkkkkkkkkkkkkkkkkkkkkk');
    _loadData();
    for (var i = 0; i < home_data.length; i++) {
      if (!home_no_dublicate.contains(home_data[i].year)) {
        home_no_dublicate.add(home_data[i].year!);

        print('sqflite codeeeeeeeeeee');
        print(home_no_dublicate);
      }
    }

    //  _loadCodeData();
    // for (var i = 0; i < home_data.length; i++) {
    //   if (!home_no_dublicate.contains(home_data[i].year)) {
    //home_no_dublicate.add(home_data[i].year!);
    print('sqflite subject');
    // print(code_data);
    //   }
    // }
    print('sqflite subject');
    print('_homedata[0].classname');
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Column(children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbuttonColor3,
                  ),
                  child: Center(
                    child: Text(
                      'السنه الدراسيه',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: ListView.separated(
                          separatorBuilder: (BuildContext ctxt, int index) =>
                              Divider(
                                color: Colors.grey,
                                height: 2,
                              ),
                          itemCount: home_no_dublicate.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    Provider.of<SubjectManager>(context,
                                            listen: false)
                                        .resetlist();
                                    setState(() {
                                      //year_id_selected =
                                      yearname = home_no_dublicate[index]!;
                                      year_level = true;
                                      subject_level = false;
                                      teacher_level = false;
                                      group_level = false;
                                      _isloadingsubjects = true;
                                      subjectname = 'الماده الدراسيه';
                                      teachername = widget.usser != user.teacher
                                          ? 'المدرس'
                                          : widget.teacher!.name!;
                                      group_name = 'المجموعه';
                                      app_name = 'الحصه';
                                    });
                                    Navigator.pop(context);
                                    Provider.of<AppStateManager>(context,
                                            listen: false)
                                        .setHomeOptions(false);

                                    print('sqflite subject');
                                    print('_homedata[0].classname');
                                    // print(subject_list);
                                  },
                                  child: Text(home_no_dublicate[index]!)),
                            );
                          })),
                ),
              ]));
        });
  }

  void _modalBottomSheetMenuSubjectOffline(BuildContext context) {
    print('yearname');
    print(yearname);
    _loadData();
    subject_no_dublicate = [];
    for (var i = 0; i < home_data.length; i++) {
      if (!subject_no_dublicate.contains(home_data[i].subject) &&
          home_data[i].year == '${yearname}') {
        subject_no_dublicate.add(home_data[i].subject!);
        print('sqflite subject');
        print(home_no_dublicate);
      }
    }
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Column(children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor1,
                  ),
                  child: Center(
                    child: Text(
                      'المادة الدراسية',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext ctxt, int index) =>
                          Divider(
                            color: Colors.grey,
                            height: 2,
                          ),
                      itemCount: subject_no_dublicate.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                              onTap: () async {
                                Provider.of<TeacherManager>(context,
                                        listen: false)
                                    .resetlist();
                                setState(() {
                                  subjectname = subject_no_dublicate[index];
                                  year_level = true;
                                  subject_level = true;
                                  teacher_level = false;
                                  group_level = false;
                                  _isloadingsubjects = false;
                                  _isloadingteachers = true;
                                  teachername = 'المدرس';

                                  group_name = 'المجموعه';
                                  app_name = 'الحصه';
                                });
                                Navigator.pop(context);
                                Provider.of<AppStateManager>(context,
                                        listen: false)
                                    .setHomeOptions(false);
                              },
                              child: Text(subject_no_dublicate[index])),
                        );
                      }),
                ))
              ]));
        });
  }

  void _modalBottomSheetMenuteacherOffline(BuildContext context) {
    _loadData();
    teacher_no_dublicate = [];
    for (var i = 0; i < home_data.length; i++) {
      if (!teacher_no_dublicate.contains(home_data[i].teacher) &&
          home_data[i].subject == '${subjectname}') {
        teacher_no_dublicate.add(home_data[i].teacher!);
        print('sqflite subject');
        print(home_no_dublicate);
      }
    }
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Column(children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor1,
                  ),
                  child: Center(
                    child: Text(
                      'المدرس',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext ctxt, int index) =>
                          Divider(
                            color: Colors.grey,
                            height: 2,
                          ),
                      itemCount: teacher_no_dublicate.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                              onTap: () async {
                                Provider.of<GroupManager>(context,
                                        listen: false)
                                    .resetlist();
                                setState(() {
                                  //year_id_selected =
                                  teachername = teacher_no_dublicate[index];
                                  year_level = true;
                                  subject_level = true;
                                  teacher_level = true;
                                  group_level = false;
                                  _isloadingsubjects = false;
                                  _isloadingteachers = false;
                                  _isloadinggroups = true;

                                  // group_name = widget.usser != user.
                                  //     ? 'المدرس'
                                  //     : widget.teacher!.name!;
                                  group_name = 'المجموعه';
                                  app_name = 'الحصه';
                                });
                                Navigator.pop(context);
                                Provider.of<AppStateManager>(context,
                                        listen: false)
                                    .setHomeOptions(false);
                              },
                              child: Text(teacher_no_dublicate[index])),
                        );
                      }),
                ))
              ]));
        });
  }

  void _modalBottomSheetMenugroupOffline(BuildContext context) {
    _loadData();
    group_no_dublicate = [];
    group_id_list = [];
    for (var i = 0; i < home_data.length; i++) {
      if (!group_no_dublicate.contains(home_data[i].groupname) &&
          home_data[i].teacher == '${teachername}') {
        group_no_dublicate.add(home_data[i].groupname!);
        group_id_list.add(home_data[i].groupid!);
        print('sqflite subject');
        print(group_id_list);
      }
    }
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Column(children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor3,
                  ),
                  child: Center(
                    child: Text(
                      'المجموعات',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext ctxt, int index) =>
                          Divider(
                            color: Colors.grey,
                            height: 2,
                          ),
                      itemCount: group_no_dublicate.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  group_name = group_no_dublicate[index];
                                  mygroup_id = group_id_list[index].trim();
                                  year_level = true;
                                  subject_level = true;
                                  teacher_level = true;
                                  group_level = true;
                                  _isloadingappointment = true;
                                  _isloadingsubjects = false;
                                  _isloadingteachers = false;
                                  _isloadinggroups = false;

                                  app_name = 'الحصه';
                                });
                                Navigator.pop(context);
                                Provider.of<AppStateManager>(context,
                                        listen: false)
                                    .setHomeOptions(false);
                              },
                              child: Text(group_no_dublicate[index])),
                        );
                      }),
                ))
              ]));
        });
  }

  void _modalBottomSheetMenuappointOffline(BuildContext context) {
    _loadData();
    class_no_dublicate = [];
    for (var i = 0; i < home_data.length; i++) {
      if (!class_no_dublicate.contains(home_data[i].classname) &&
          home_data[i].groupname == '${group_name}') {
        class_no_dublicate.add(home_data[i].classname!);
        class_id_list.add(home_data[i].classid!);
        print('sqflite subject');
        print(home_no_dublicate);
      }
    }
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 250.0,
              color: Colors.transparent,
              child: Column(children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbuttonColor3,
                  ),
                  child: Center(
                    child: Text(
                      'اختار حصة',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: ListView.separated(
                      separatorBuilder: (BuildContext ctxt, int index) =>
                          Divider(
                            color: Colors.grey,
                            height: 2,
                          ),
                      itemCount: group_no_dublicate.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                              onTap: () async {
                                _loadCodeData();
                                print('isqflite subjecttttttttttttttttttt');
                                print('kk' + code_data[0].groupid + 'kk');
                                print('kk' + mygroup_id + 'kk');
                                // String? h = '';
                                for (var i = 0; i < code_data.length; i++) {
                                  // h = code_data[0].groupid;
                                  // String a = '60';
                                  // String b = '60';
                                  // print(a);
                                  if (code_data[i].groupid == mygroup_id) {
                                    print('hrrrrrrrrrr');
                                    print(code_data[i].code);
                                    group_codes.add(code_data[i].code);
                                  }
                                }
                                print(group_codes);

                                // for (var i = 0; i < code_data.length; i++) {
                                //   // group_codes = [];

                                //   if (!group_codes
                                //           .contains(code_data[i].code) &&
                                //       code_data[i].groupid == mygroup_id) {
                                //     group_codes.add(code_data[i].code!);
                                //     print('usqflite subjecttttttttttttttttttt');
                                //     print(group_codes);
                                //   }
                                // }
                                // print('osqflite subjecttttttttttttttttttt');
                                // print(group_codes);
                                setState(() {
                                  app_name = class_no_dublicate[index];
                                  if (record_attend = true) {
                                    myclass_id.add(class_id_list[index].trim());
                                  }

                                  year_level = true;
                                  subject_level = true;
                                  teacher_level = true;
                                  group_level = true;
                                  _isloadingappointment = false;
                                  _isloadingsubjects = false;
                                  _isloadingteachers = false;
                                  _isloadinggroups = false;
                                });
                                Navigator.pop(context);
                                Provider.of<AppStateManager>(context,
                                        listen: false)
                                    .setHomeOptions(false);
                              },
                              child: Text(class_no_dublicate[index])),
                        );
                      }),
                ))
              ]));
        });
  }

  void _modalBottomSheetMenusubject(BuildContext context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor1,
                  ),
                  child: Center(
                    child: Text(
                      'الماده الدراسيه',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Consumer<SubjectManager>(
                      builder: (_, subjectmanager, child) {
                        if (subjectmanager.subjects!.isEmpty) {
                          if (subjectmanager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (subjectmanager.error) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                subjectmanager.setloading(true);
                                subjectmanager.seterror(false);
                                Provider.of<SubjectManager>(context,
                                        listen: false)
                                    .getMoreDatafiltered(
                                        year_id_selected.toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("error please tap to try again"),
                              ),
                            ));
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc2,
                            itemCount: subjectmanager.subjects!.length +
                                (subjectmanager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (index == subjectmanager.subjects!.length) {
                                if (subjectmanager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      subjectmanager.setloading(true);
                                      subjectmanager.seterror(false);
                                      Provider.of<SubjectManager>(context,
                                              listen: false)
                                          .getMoreDatafiltered(
                                              year_id_selected.toString());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<TeacherManager>(context,
                                          listen: false)
                                      .resetlist();
                                  setState(() {
                                    subjectId_selected = subjectmanager
                                        .subjects![index].id
                                        .toString();
                                    subjectname =
                                        subjectmanager.subjects![index].name!;
                                    subject_level = true;
                                    teacher_level = widget.usser != user.teacher
                                        ? false
                                        : true;
                                    group_level = false;
                                    _isloadingteachers =
                                        widget.usser != user.teacher
                                            ? true
                                            : false;
                                    if (widget.usser == user.teacher) {
                                      _isloadinggroups = true;
                                    }
                                    teachername = widget.usser != user.teacher
                                        ? 'المدرس'
                                        : widget.teacher!.name!;
                                    group_name = 'المجموعه';
                                    app_name = 'الحصه';
                                    code_from_windows = '';
                                  });
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .setHomeOptions(false);
                                  Navigator.pop(context);

                                  widget.usser != user.teacher
                                      ? await Provider.of<TeacherManager>(
                                              context,
                                              listen: false)
                                          .getMoreDatafiltered(year_id_selected,
                                              subjectId_selected)
                                          .then((value) {
                                          setState(() {
                                            _isloadingteachers = false;
                                          });
                                        })
                                      : await Provider.of<GroupManager>(context,
                                              listen: false)
                                          .getMoreDatafiltered(
                                              year_id_selected,
                                              subjectId_selected,
                                              teacher_id_selected)
                                          .then((value) {
                                          setState(() {
                                            _isloadinggroups = false;
                                          });
                                        });
                                },
                                child: ListTile(
                                  title: Text(
                                      subjectmanager.subjects![index].name!),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenuyear(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (record_attend = true) {
      //dynamic resp =
      for (var i = 0; i < attended_code.length; i++) {
        await Provider.of<AppointmentManager>(context, listen: false)
            .attendlesson(attended_code[i], myclass_id[i]);
      }
    }
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbuttonColor3,
                  ),
                  child: Center(
                    child: Text(
                      'السنه الدراسيه',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Consumer<YearManager>(
                      builder: (_, yearmanager, child) {
                        if (yearmanager.years.isEmpty) {
                          if (yearmanager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (yearmanager.error) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                yearmanager.setloading(true);
                                yearmanager.seterror(false);
                                Provider.of<YearManager>(context, listen: false)
                                    .getMoreData();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("error please tap to try again"),
                              ),
                            ));
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc1,
                            itemCount: yearmanager.years.length +
                                (yearmanager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (index == yearmanager.years.length) {
                                if (yearmanager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      yearmanager.setloading(true);
                                      yearmanager.seterror(false);
                                      Provider.of<YearManager>(context,
                                              listen: false)
                                          .getMoreData();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<SubjectManager>(context,
                                          listen: false)
                                      .resetlist();
                                  setState(() {
                                    year_id_selected =
                                        yearmanager.years[index].id.toString();
                                    yearname = yearmanager.years[index].name!;
                                    year_level = true;
                                    subject_level = false;
                                    teacher_level = false;
                                    group_level = false;
                                    _isloadingsubjects = true;
                                    subjectname = 'الماده الدراسيه';
                                    teachername = widget.usser != user.teacher
                                        ? 'المدرس'
                                        : widget.teacher!.name!;
                                    group_name = 'المجموعه';
                                    app_name = 'الحصه';
                                    code_from_windows = '';
                                  });
                                  Navigator.pop(context);
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .setHomeOptions(false);

                                  await Provider.of<SubjectManager>(context,
                                          listen: false)
                                      .getMoreDatafiltered(
                                          year_id_selected.toString())
                                      .then((value) {
                                    setState(() {
                                      _isloadingsubjects = false;
                                    });
                                  });
                                },
                                child: ListTile(
                                  title: Text(yearmanager.years[index].name!),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenuteacher(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor1,
                  ),
                  child: Center(
                    child: Text(
                      'المدرس',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Consumer<TeacherManager>(
                      builder: (_, teachermanager, child) {
                        if (teachermanager.teachers.isEmpty) {
                          if (teachermanager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (teachermanager.error) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                teachermanager.setloading(true);
                                teachermanager.seterror(false);
                                Provider.of<TeacherManager>(context,
                                        listen: false)
                                    .getMoreDatafiltered(
                                        year_id_selected, subjectId_selected);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("error please tap to try again"),
                              ),
                            ));
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc3,
                            itemCount: teachermanager.teachers.length +
                                (teachermanager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (index == teachermanager.teachers.length) {
                                if (teachermanager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      teachermanager.setloading(true);
                                      teachermanager.seterror(false);
                                      Provider.of<TeacherManager>(context,
                                              listen: false)
                                          .getMoreDatafiltered(year_id_selected,
                                              subjectId_selected);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<GroupManager>(context,
                                          listen: false)
                                      .resetlist();
                                  setState(() {
                                    teacher_id_selected = teachermanager
                                        .teachers[index].id
                                        .toString();
                                    teachername =
                                        teachermanager.teachers[index].name!;
                                    teacher_level = true;
                                    group_level = false;
                                    _isloadinggroups = true;

                                    group_name = 'المجموعه';
                                    app_name = 'الحصه';
                                    code_from_windows = '';
                                  });
                                  Navigator.pop(context);
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .setHomeOptions(false);
                                  await Provider.of<GroupManager>(context,
                                          listen: false)
                                      .getMoreDatafiltered(
                                          year_id_selected,
                                          subjectId_selected,
                                          teacher_id_selected)
                                      .then((value) {
                                    // print('valueeeeeeeeeeeeeeeeee');
                                    // //print(value);
                                    setState(() {
                                      _isloadinggroups = false;
                                    });
                                  });
                                },
                                child: ListTile(
                                  title: Text(
                                      teachermanager.teachers[index].name!),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenugroup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kbackgroundColor3,
                ),
                child: Center(
                  child: Text(
                    'المجموعات',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GE-bold',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Consumer<GroupManager>(
                    builder: (_, groupmanager, child) {
                      if (groupmanager.groups.isEmpty) {
                        if (groupmanager.loading) {
                          print(groupmanager.loading);
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ));
                        } else if (groupmanager.error) {
                          return Center(
                              child: InkWell(
                            onTap: () {
                              groupmanager.setloading(true);
                              groupmanager.seterror(false);
                              Provider.of<GroupManager>(context, listen: false)
                                  .getMoreDatafiltered(year_id_selected,
                                      subjectId_selected, teacher_id_selected);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("error please tap to try again"),
                            ),
                          ));
                        }
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _sc4,
                                itemCount: groupmanager.groups.length +
                                    (groupmanager.hasmore ? 1 : 0),
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if (index == groupmanager.groups.length) {
                                    if (groupmanager.error) {
                                      return Center(
                                          child: InkWell(
                                        onTap: () {
                                          groupmanager.setloading(true);
                                          groupmanager.seterror(false);
                                          Provider.of<GroupManager>(context,
                                                  listen: false)
                                              .getMoreDatafiltered(
                                                  year_id_selected,
                                                  subjectId_selected,
                                                  teacher_id_selected);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                              "error please tap to try again"),
                                        ),
                                      ));
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    }
                                  }

                                  return GestureDetector(
                                    onTap: () async {
                                      Provider.of<AppStateManager>(context,
                                              listen: false)
                                          .setgroupID(
                                              groupmanager.groups[index].id
                                                  .toString(),
                                              groupmanager.groups[index]);
                                      setState(() {
                                        group_id_selected = groupmanager
                                            .groups[index].id
                                            .toString();
                                        group_id =
                                            groupmanager.groups[index].id!;
                                        group_name =
                                            groupmanager.groups[index].name!;
                                        group_level = true;
                                        _isloadingappointment = true;
                                        app_name = 'الحصه';
                                        code_from_windows = '';
                                      });
                                      Provider.of<AppStateManager>(context,
                                              listen: false)
                                          .setHomeOptions(true);
                                      Navigator.pop(context);
                                      await Provider.of<AppointmentManager>(
                                              context,
                                              listen: false)
                                          .get_appointments(group_id_selected)
                                          .then((value) => setState(() {
                                                _isloadingappointment = false;
                                              }));
                                    },
                                    child: ListTile(
                                      title: Text(
                                          groupmanager.groups[index].name!),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _modalBottomSheetMenuappoint(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 300.0,
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kbackgroundColor1,
                ),
                child: Center(
                  child: Text(
                    'اختار حصه',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GE-bold',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Consumer<AppointmentManager>(
                    builder: (_, appointmentmanager, child) {
                      if (appointmentmanager.appointments!.isEmpty) {
                        if (!appointmentmanager.loading) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'لا توجد حصص',
                                style: TextStyle(
                                    fontFamily: 'GE-medium',
                                    color: Colors.black),
                              ),
                            ),
                          );
                        } else if (appointmentmanager.error) {
                          return Center(
                              child: InkWell(
                            onTap: () {
                              appointmentmanager.setloading(true);
                              appointmentmanager.seterror(false);
                              Provider.of<AppointmentManager>(context,
                                      listen: false)
                                  .get_appointments(group_id_selected);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("error please tap to try again"),
                            ),
                          ));
                        }
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    appointmentmanager.appointments!.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if (index ==
                                      appointmentmanager.appointments!.length) {
                                    if (appointmentmanager.error) {
                                      return Center(
                                          child: InkWell(
                                        onTap: () {
                                          appointmentmanager.setloading(true);
                                          appointmentmanager.seterror(false);
                                          Provider.of<AppointmentManager>(
                                                  context,
                                                  listen: false)
                                              .get_appointments(
                                                  group_id_selected);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                              "error please tap to try again"),
                                        ),
                                      ));
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    }
                                  }

                                  return Column(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              app_id_selected =
                                                  appointmentmanager
                                                      .appointments![index].id
                                                      .toString();
                                              app_name = appointmentmanager
                                                  .appointments![index].name
                                                  .toString();
                                              code_from_windows = '';
                                            });
                                            Navigator.pop(context);
                                            focusNode.requestFocus();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            width: double.infinity,
                                            height: 30,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                appointmentmanager
                                                    .appointments![index].name!,
                                                style: TextStyle(
                                                    fontFamily: 'GE-light'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: false,
                                              ),
                                            ),
                                          )),
                                      Divider(),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool? lessonadd = false;

  void _showErrorDialog(String message, String title) {
    showDialog(
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
          Center(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kbuttonColor2)),
              // color: kbackgroundColor1,
              child: Text(
                'حسنا',
                style: TextStyle(fontFamily: 'GE-medium', color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  void _showAttendConfirmDialog(String code, String lessonid) {
    showDialog(
      barrierDismissible: false,
      context: this.context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'تاكيد',
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Text(
          'الطالب لم يحضر الحصه السابقه لتسجيل الحضور اضغط تاكيد',
          style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
        ),
        actions: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(kbuttonColor2)),
                  // color: kbackgroundColor1,
                  child: Text(
                    'تاكيد',
                    style:
                        TextStyle(fontFamily: 'GE-medium', color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[200])),
                  // color: kbackgroundColor1,
                  child: Text(
                    'الغاء',
                    style:
                        TextStyle(fontFamily: 'GE-medium', color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    try {
                      Provider.of<AppointmentManager>(this.context,
                              listen: false)
                          .unattendlesson(code, lessonid);
                    } catch (e) {
                      _showErrorDialog('تم تسجيل الطالب حضور', 'حدث خطأ');
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  FocusNode fn2 = FocusNode();
  TextEditingController nameController = TextEditingController();
  var key = GlobalKey<AutoCompleteTextFieldState<StudentModelSearch>>();

  StudentModelSearch? studentattendbyname;
  // void _showAttendByNameDialogue() {
  //   // setState(() {
  //   //   _loadingscann == true;
  //   // });
  //   focusNode.unfocus();
  //   fn2.requestFocus();
  //   code_from_windows = '';
  //   nameController.text = '';
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (ctx) =>
  //           Consumer<StudentManager>(builder: (context, stumgr, child) {
  //             var aa = stumgr.students;
  //             return StatefulBuilder(builder: (context, setState) {
  //               return AlertDialog(
  //                 title: Text(
  //                   'تسجيل الحضور بالاسم',
  //                   style: TextStyle(fontFamily: 'GE-Bold'),
  //                 ),
  //                 content: AutoCompleteTextField<StudentModelSearch>(
  //                   textChanged: (text) async {
  //                     await stumgr.searchStudentforattend(text);
  //                     setState(() {});
  //                   },
  //                   controller: nameController,
  //                   decoration: InputDecoration(
  //                       hintText: "اسم الطالب", suffixIcon: Icon(Icons.search)),
  //                   itemSubmitted: (item) =>
  //                       setState(() => studentattendbyname = item),
  //                   key: key,
  //                   suggestions: aa,
  //                   itemBuilder: (context, suggestion) {
  //                     return Padding(
  //                         child: ListTile(
  //                           title: Text(suggestion.name!),
  //                         ),
  //                         padding: EdgeInsets.all(8.0));
  //                   },
  //                   itemSorter: (a, b) => a.name == b.name
  //                       ? 0
  //                       : a.name! == b.name!
  //                           ? -1
  //                           : 1,
  //                   itemFilter: (suggestion, input) => suggestion.name!
  //                       .toLowerCase()
  //                       .startsWith(input.toLowerCase()),
  //                 ),
  //                 // }),
  //                 actions: <Widget>[
  //                   Center(
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                       children: [
  //                         TextButton(
  //                           style: ButtonStyle(
  //                               backgroundColor:
  //                                   MaterialStateProperty.all(kbuttonColor2)),
  //                           // color: kbackgroundColor1,
  //                           child: Text(
  //                             'تاكيد',
  //                             style: TextStyle(
  //                                 fontFamily: 'GE-medium', color: Colors.black),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             print(nameController.text);
  //                           },
  //                         ),
  //                         TextButton(
  //                           style: ButtonStyle(
  //                               backgroundColor:
  //                                   MaterialStateProperty.all(Colors.red[200])),
  //                           // color: kbackgroundColor1,
  //                           child: Text(
  //                             'الغاء',
  //                             style: TextStyle(
  //                                 fontFamily: 'GE-medium', color: Colors.black),
  //                           ),
  //                           onPressed: () {
  //                             Navigator.of(context).pop();
  //                             // try {
  //                             //   Provider.of<AppointmentManager>(context, listen: false)
  //                             //       .unattendlesson(code, lessonid);
  //                             // } catch (e) {
  //                             //   _showErrorDialog('تم تسجيل الطالب حضور', 'حدث خطأ');
  //                             // }
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 ],
  //               );
  //             });
  //           }));
  // }

  void _add_lesson(String message, String title) {
    // final format = TimeOfDayFormat('hh:mm'); //"6:00 AM"
    final dateformate = DateFormat('y-M-d');

    showDialog(
        barrierDismissible: false,
        context: this.context,
        builder: (ctx) => StatefulBuilder(
            builder: (context, setState) => (AlertDialog(
                  title: Text(
                    'اضافه حصه',
                    style: TextStyle(fontFamily: 'GE-Bold'),
                  ),
                  content: !lessonadd!
                      ? Container(
                          height: 80,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () async {
                                  final TimeOfDay? newTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (newTime != null) {
                                    setState(() {
                                      // _isloadingappointment = true;
                                      // group_level = false;
                                      newLessonTime =
                                          formatTimeOfDay(newTime)[0]
                                              .toString();
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      color: kbuttonColor3.withOpacity(.8),
                                      child: Row(
                                        children: [
                                          Icon(Icons.add),
                                          Text('Time'),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(newLessonTime)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: () async {
                                  final newDate = await showDatePicker(
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2030),
                                    context: context,
                                    initialDate: DateTime.now(),
                                  );
                                  if (newDate != null) {
                                    setState(() {
                                      // _isloadingappointment = true;
                                      // group_level = false;
                                      newLessonDate = dateformate
                                          .format(newDate)
                                          .toString();
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      color: kbuttonColor3.withOpacity(.8),
                                      child: Row(
                                        children: [
                                          Icon(Icons.add),
                                          Text('Date'),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text(newLessonDate)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 80,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                  actions: <Widget>[
                    !lessonadd!
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kbackgroundColor1)),
                                    onPressed: !lessonadd!
                                        ? () {
                                            Navigator.of(context).pop();
                                          }
                                        : () {},
                                    child: Text(
                                      'لا',
                                      style: TextStyle(
                                          fontFamily: 'GE-medium',
                                          color: Colors.black),
                                    )),
                                TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kbackgroundColor1)),
                                    // color: kbackgroundColor1,
                                    child: Text(
                                      'نعم',
                                      style: TextStyle(
                                          fontFamily: 'GE-medium',
                                          color: Colors.black),
                                    ),
                                    onPressed: !lessonadd!
                                        ? () async {
                                            if (newLessonDate != '' &&
                                                newLessonTime != '') {
                                              setState(() {
                                                _isloadingappointment = true;
                                                group_level = false;
                                              });
                                              setState(() {
                                                lessonadd = true;
                                              });

                                              try {
                                                await Provider.of<
                                                            AppointmentManager>(
                                                        context,
                                                        listen: false)
                                                    .add_appointment(
                                                      group_id_selected,
                                                      newLessonTime,
                                                      newLessonDate,
                                                    )
                                                    .then((value) => Provider
                                                            .of<AppointmentManager>(
                                                                context,
                                                                listen: false)
                                                        .get_appointments(
                                                            group_id_selected))
                                                    .then(
                                                        (value) => setState(() {
                                                              _isloadingappointment =
                                                                  false;
                                                              group_level =
                                                                  true;
                                                            }))
                                                    .then((value) =>
                                                        setState(() {
                                                          app_id_selected =
                                                              Provider.of<AppointmentManager>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .currentapp!
                                                                  .id
                                                                  .toString();
                                                          app_name = Provider
                                                                  .of<AppointmentManager>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .currentapp!
                                                              .name!;
                                                        }))
                                                    .then(
                                                      (_) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              Colors.black38,
                                                          content: Text(
                                                            'تم اضافه الحصه بنجاح',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'GE-medium'),
                                                          ),
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ),
                                                      ),
                                                    );
                                                setState(() {
                                                  lessonadd = false;
                                                });
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                _showErrorDialog(
                                                    'حاول مره اخري. ',
                                                    'حدث خطأ');
                                              }
                                              setState(() {
                                                newLessonDate = '';
                                                newLessonTime = '';
                                              });
                                            }

                                            ;
                                          }
                                        : () {}),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ))));
  }

  List<String> years_levels = [];
  List<String> subjects = [];
  List<String> teachers = [];
  List<String> groups = [];
  var year_level = false;
  var subject_level = false;
  var teacher_level = false;
  var group_level = false;
  @override
  Widget build(BuildContext context) {
    // app_id_selected = Provider.of<AppointmentManager>(context, listen: false)
    //     .currentapp!
    //     .id
    //     .toString();
    // app_name = Provider.of<AppointmentManager>(context, listen: false)
    //     .currentapp!
    //     .name
    //     .toString();
    return Container(
      height: widget.size.height * .7,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Choice_container(
                    hinttext: yearname,
                    color: kbuttonColor3,
                    items: years_levels,
                    size: widget.size,
                    fnc: check_connectivity(context) == true
                        ? () => _modalBottomSheetMenuyear(context)
                        : () => _modalBottomSheetMenuyearOffline(context),
                    loading: _isloadingyears,
                    active: true,
                  ),
                  Choice_container(
                    hinttext: subjectname,
                    color: kbackgroundColor1,
                    items: subjects,
                    size: widget.size,
                    fnc: check_connectivity(context) == true
                        ? () => _modalBottomSheetMenusubject(context)
                        : () => _modalBottomSheetMenuSubjectOffline(context),
                    active: year_level == true,
                    loading: _isloadingsubjects,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Choice_container(
                    hinttext: teachername,
                    color: kbackgroundColor1,
                    items: teachers,
                    size: widget.size,
                    fnc: check_connectivity(context) == true
                        ? () => _modalBottomSheetMenuteacher(context)
                        : () => _modalBottomSheetMenuteacherOffline(context),
                    // (){
                    //   if(widget.usser != user.teacher){
                    //          return _modalBottomSheetMenuteacher(context);
                    //   }
                    //   if(check_connectivity(context) == true){
                    //           return _modalBottomSheetMenuteacher(context);
                    //   }

                    //   else{
                    //      return _modalBottomSheetMenuteacherOffline(context);

                    //   }
                    // } ,
                    ////////////
                    //  widget.usser != user.teacher
                    //     ? () => _modalBottomSheetMenuteacher(context)
                    //     : () {},
                    active: subject_level == true,
                    loading: _isloadingteachers,
                  ),
                  Choice_container(
                    hinttext: group_name,
                    color: kbackgroundColor3,
                    items: groups,
                    size: widget.size,
                    fnc: check_connectivity(context) == true
                        ? () => _modalBottomSheetMenugroup(context)
                        : () => _modalBottomSheetMenugroupOffline(context),
                    active: teacher_level == true,
                    loading: _isloadinggroups,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.usser != user.assistant0)
                    Button_Container(
                      color: kbuttonColor2,
                      size: widget.size,
                      text: 'ادخال طالب',
                      fnc: () async {
                        Provider.of<AppStateManager>(context, listen: false)
                            .registerStudent(true);
                      },
                    ),
                  (widget.usser == user.assistant ||
                          widget.usser == user.teacher ||
                          widget.usser == user.assistant0)
                      ? Button_Container(
                          color: kbuttonColor2,
                          size: widget.size,
                          text: 'المواد الدراسيه',
                          fnc: () async {
                            Provider.of<AppStateManager>(context, listen: false)
                                .modifySubjects(true);
                          },
                        )
                      : Button_Container(
                          color: kbuttonColor3,
                          size: widget.size,
                          text: 'ادخال معلم',
                          fnc: () async {
                            Provider.of<AppStateManager>(context, listen: false)
                                .registerTeacher(true);
                          },
                        ),
                  if (widget.usser == user.assistant0)
                    Button_Container(
                      color: kbackgroundColor1,
                      size: widget.size,
                      text: 'السنوات الدراسيه',
                      fnc: () async {
                        Provider.of<AppStateManager>(context, listen: false)
                            .addYears(true);
                      },
                    ),
                ],
              ),
            ),
            if (widget.usser != user.assistant0)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button_Container(
                      color: kbackgroundColor1,
                      size: widget.size,
                      text: 'السنوات الدراسيه',
                      fnc: () async {
                        Provider.of<AppStateManager>(context, listen: false)
                            .addYears(true);
                      },
                    ),
                    Button_Container(
                      color: kbackgroundColor3,
                      size: widget.size,
                      text: 'ادخال مجموعه',
                      fnc: () async {
                        Provider.of<AppStateManager>(context, listen: false)
                            .registerGroup(true);
                      },
                    ),
                  ],
                ),
              ),
            (widget.usser == user.assistant ||
                    widget.usser == user.teacher ||
                    widget.usser == user.assistant0)
                ? Container()
                : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button_Container(
                          color: kbuttonColor2,
                          size: widget.size,
                          text: 'المواد الدراسيه',
                          fnc: () async {
                            Provider.of<AppStateManager>(context, listen: false)
                                .modifySubjects(true);
                          },
                        ),
                        Container(
                          width: widget.size.width * .45,
                        )
                      ],
                    ),
                  ),
            if (widget.usser == user.teacher)
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button_Container(
                      color: kbuttonColor2,
                      size: widget.size,
                      text: 'ادخال مساعد',
                      fnc: () async {
                        Provider.of<AppStateManager>(context, listen: false)
                            .registerAssistant(true);
                      },
                    ),
                    Container(
                      width: widget.size.width * .45,
                    )
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: group_level
                              ? kbuttonColor3
                              : kbuttonColor3.withOpacity(.5),
                        ),
                        onPressed: group_level
                            ? () async {
                                _add_lesson('message', 'title');
                              }
                            : () {},
                        icon: Icon(Icons.add),
                        label: Container(),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    height: 30,
                    width: widget.size.width * .6,
                    decoration: BoxDecoration(
                      color: group_level
                          ? kbuttonColor3
                          : kbuttonColor3.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                        onTap: check_connectivity(context) == true
                            //||group_level
                            ? () => _modalBottomSheetMenuappoint(context)
                            : () =>
                                _modalBottomSheetMenuappointOffline(context),
                        //  group_level
                        //     ? () {
                        //        _modalBottomSheetMenuappoint(context);
                        //       }
                        //     : null,
                        /////
                        // group_level
                        //     ? () {
                        //         _modalBottomSheetMenuappoint(context);
                        //       }
                        //     : null,
                        child: Consumer<AppointmentManager>(
                          builder: (context, appmanager, child) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  _isloadingappointment
                                      ? CircularProgressIndicator()
                                      : Container(
                                          width: widget.size.width * .5,
                                          child: Text(
                                            app_name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: TextStyle(
                                                fontFamily:
                                                    'AraHamah1964B-Bold',
                                                fontSize: 20,
                                                color: group_level
                                                    ? Colors.black
                                                    : Colors.black26),
                                          ),
                                        ),
                                  Spacer(),
                                  Icon(Icons.keyboard_arrow_down)
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                ],
              ),
            ),
            if (!Platform.isWindows)
              // Consumer<AppStateManager>(
              //   builder: (context, appstatemanager, child) =>

              GestureDetector(
                onTap: check_connectivity(context) == false
                    // app_name != 'الحصه' && _loadingscann == false

                    ? () async {
                        print('lllllllllllllhhhhhhhhhhhhhhhhhhhhhhh');
                        String res = await FlutterBarcodeScanner.scanBarcode(
                            '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                        print('llllll' + res + 'yllllllllllllllll');
                        // if(res =='7565384k' ){
                        //            ScaffoldMessenger.of(context)
                        //                       .showSnackBar(
                        //                     SnackBar(
                        //                       backgroundColor: Colors.green[300],
                        //                       content: Text(
                        //                         ' تم التسجيل بنجاح',
                        //                         style: TextStyle(
                        //                             fontFamily: 'GE-medium'),
                        //                       ),
                        //                       duration: Duration(seconds: 3),
                        //                     ),
                        //                   );
                        //         }
                        ///////////////////

                        // _loadCodeData();
                        //   for (var i = 0; i < code_data.length; i++) {
                        //    // group_codes = [];

                        //     if (!group_codes.contains(code_data[i].code) &&
                        //         code_data[i].groupid == '${mygroup_id}') {
                        //       group_codes.add(code_data[i].code!);
                        //       print('sqflite subjecttttttttttttttttttt');
                        //       print(group_codes);
                        //         }
                        // print(group_codes);
                        print('hh' + group_codes[0] + 'hhh');
                        print('hh' + res + 'hhh');
                        for (var y = 0; y < group_codes.length; y++) {
                          if (res == group_codes[y]) {
                            print('emmmo');
                            is_ok = true;
                            record_attend = true;
                            setState(() {
                              is_ok = true;
                              attended_code.add(res);
                              record_attend = true;
                            });
                            break;
                          } else {
                            setState(() {
                              print('noo emmo');
                              is_ok = false;
                              record_attend = false;
                            });
                            // break;
                          }
                        }

                        // print('coooooooode');
                        // print(code_data[i].groupid);
                        // print(code_data[i].code);
                        // if (is_ok == true) {
                        //   print('iss_okkk');
                        // } else {
                        //   print('iskkk');
                        // }
                        if (is_ok == true) {
                          print('riss_okkk');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green[300],
                              content: Text(
                                ' تم التسجيل بنجاح',
                                style: TextStyle(fontFamily: 'GE-medium'),
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          is_ok == false;
                        } else {
                          _showErrorDialog(
                              'الطالب غير مسجل في المجموعة', 'غير مسجل');
                        }
                      }
                    : () async {
                        setState(() {
                          _loadingscann = true;
                        });
                        // String res = await FlutterBarcodeScanner.scanBarcode(
                        //     '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                        try {
                          String res = await FlutterBarcodeScanner.scanBarcode(
                              '#ff6666', 'Cancel', true, ScanMode.BARCODE);

                          print(res + 'llllllllllllllll');
                          dynamic resp = await Provider.of<AppointmentManager>(
                                  context,
                                  listen: false)
                              .attendlesson(res, app_id_selected!);

                          if (resp['last_appointment_attend'] == false) {
                            _showAttendConfirmDialog(res, app_id_selected!);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     backgroundColor: Colors.orange[200],
                            //     content: Text(
                            //       ' تم التسجيل بنجاح والحصه السابقه لم يحضرها',
                            //       style: TextStyle(fontFamily: 'GE-medium'),
                            //     ),
                            //     duration: Duration(seconds: 3),
                            //   ),
                            // );
                          }
                          if (resp['last_appointment_attend'] == true &&
                              resp['compensation'] == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green[300],
                                content: Text(
                                  ' تم التسجيل بنجاح',
                                  style: TextStyle(fontFamily: 'GE-medium'),
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                          if (resp['last_appointment_attend'] == true &&
                              resp['compensation'] == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.blue[200],
                                content: Text(
                                  ' تم التسجيل فى مجموعه تعويضيه',
                                  style: TextStyle(fontFamily: 'GE-medium'),
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                          // if (resp['last_appointment_attend'] ==
                          //     'This Group Has not have appointments') {
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       backgroundColor: Colors.green[300],
                          //       content: Text(
                          //         ' تم التسجيل بنجاح',
                          //         style: TextStyle(fontFamily: 'GE-medium'),
                          //       ),
                          //       duration: Duration(seconds: 3),
                          //     ),
                          //   );
                          // }
                        } on HttpException catch (e) {
                          _showErrorDialog(e.toString(), 'حدث خطأ');
                        } catch (e) {
                          _showErrorDialog('حاول مره اخري', 'حدث خطأ');
                        }
                        setState(() {
                          _loadingscann = false;
                        });

                        // .then((value) =>
                        //     _showErrorDialog(app_id_selected, res));
                      },
                // .then((value) =>
                //     _showErrorDialog(app_id_selected, scanResult_code))
                // : null,
                child: Scan_button(
                  active: app_name != 'الحصه' && _loadingscann == false,
                ),
              ),
            if (Platform.isWindows)
              Consumer<AppStateManager>(
                  builder: (context, appstatemanager, child) {
                String inputK = "";
                return RawKeyboardListener(
                    // autofocus: true,
                    focusNode: focusNode,
                    onKey: (RawKeyEvent event) {
                      if (event.runtimeType.toString() == 'RawKeyDownEvent' &&
                          (app_name != 'الحصه' && _loadingscann == false)) {
                        print(event.logicalKey.keyLabel);
                        if (event.logicalKey.keyLabel == 'Backspace') {
                          code_from_windows = '';
                          return;
                        }
                        if (event.logicalKey.keyLabel == 'Shift Left' ||
                            event.logicalKey.keyLabel == 'Control Left' ||
                            event.logicalKey.keyLabel == 'Meta Left' ||
                            event.logicalKey.keyLabel == 'Alt Left' ||
                            event.logicalKey.keyLabel == ' ' ||
                            event.logicalKey.keyLabel == 'Shift right' ||
                            event.logicalKey.keyLabel == 'Control right' ||
                            event.logicalKey.keyLabel == 'Meta right' ||
                            event.logicalKey.keyLabel == 'Alt right' ||
                            event.logicalKey.keyLabel == ' ' ||
                            event.logicalKey.keyLabel == 'Shift right' ||
                            event.logicalKey.keyLabel == 'Caps Lock' ||
                            event.logicalKey.keyLabel == 'Tab' ||
                            event.logicalKey.keyLabel == 'Numpad 1' ||
                            event.logicalKey.keyLabel == 'Numpad 2' ||
                            event.logicalKey.keyLabel == 'Numpad 3' ||
                            event.logicalKey.keyLabel == 'Numpad 4' ||
                            event.logicalKey.keyLabel == 'Numpad 5' ||
                            event.logicalKey.keyLabel == 'Numpad 6' ||
                            event.logicalKey.keyLabel == 'Numpad 7' ||
                            event.logicalKey.keyLabel == 'Numpad 8' ||
                            event.logicalKey.keyLabel == 'Numpad 9' ||
                            event.logicalKey.keyLabel == 'Numpad 0' ||
                            event.logicalKey.keyLabel == 'Numpad .' ||
                            event.logicalKey.keyLabel == 'Numpad /' ||
                            event.logicalKey.keyLabel == 'Numpad *' ||
                            event.logicalKey.keyLabel == '=' ||
                            event.logicalKey.keyLabel == '-' ||
                            event.logicalKey.keyLabel == 'Arrow') {
                          print('objects');

                          return;
                        }
                        if (event.logicalKey.keyLabel == 'Enter') {
                          if (app_name != 'الحصه' && _loadingscann == false) {
                            enterscaninwindows();
                          }

                          // focusNode.requestFocus();
                          return;
                        }

                        code_from_windows += event.logicalKey.keyLabel;

                        print(code_from_windows);
                      }
                      setState(() {});
                    },
                    child: Column(
                      children: [
                        InkWell(
                          // onDoubleTap:
                          //     app_name != 'الحصه' && _loadingscann == false
                          //         ? () {
                          //             _showAttendByNameDialogue();
                          //           }
                          //         : null,
                          // focusNode: focusNode,
                          onTap: app_name != 'الحصه' && _loadingscann == false
                              ? enterscaninwindows
                              : null,

                          child: Scan_button(
                            active:
                                app_name != 'الحصه' && _loadingscann == false,
                          ),
                        ),
                        Container(
                          width: 300,
                          child: Center(
                            child: Text(code_from_windows),
                          ),
                        )
                      ],
                    ));
              })
          ],
        ),
      ),
    );
  }

  Future<void> enterscaninwindows() async {
    setState(() {
      _loadingscann = true;
    });
    if (app_id_selected == null) {
      _showErrorDialog('اختر حصه', 'حدث خطأ');
      return;
    }

    try {
      dynamic resp =
          await Provider.of<AppointmentManager>(this.context, listen: false)
              .attendlesson(code_from_windows, app_id_selected!);

      if (resp['last_appointment_attend'] == false) {
        _showAttendConfirmDialog(code_from_windows, app_id_selected!);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     backgroundColor: Colors.orange[200],
        //     content: Text(
        //       ' تم التسجيل بنجاح والحصه السابقه لم يحضرها',
        //       style: TextStyle(
        //           fontFamily: 'GE-medium'),
        //     ),
        //     duration: Duration(seconds: 3),
        //   ),
        // );
      }
      if (resp['last_appointment_attend'] == true &&
          resp['compensation'] == false) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: Text(
              ' تم التسجيل بنجاح',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      if (resp['last_appointment_attend'] == true &&
          resp['compensation'] == true) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.blue[200],
            content: Text(
              ' تم التسجيل فى مجموعه تعويضيه',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      // if (resp['last_appointment_attend'] == true) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       backgroundColor: Colors.green[300],
      //       content: Text(
      //         ' تم التسجيل بنجاح',
      //         style: TextStyle(
      //             fontFamily: 'GE-medium'),
      //       ),
      //       duration: Duration(seconds: 3),
      //     ),
      //   );
      // }
    } on HttpException catch (e) {
      setState(() {
        _loadingscann = false;
      });
      // _showErrorDialog(e.toString(), 'حدث خطأ');
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[300],
          content: Text(
            e.toString(),
            style: TextStyle(fontFamily: 'GE-medium'),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        _loadingscann = false;
      });
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[300],
          content: Text(
            'حدث خطأ',
            style: TextStyle(fontFamily: 'GE-medium'),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      _loadingscann = false;
      code_from_windows = '';
    });
  }

  Future<void> scanBarcodeNormal() async {
    late String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      _showErrorDialog('حاول مره اخري', 'حدث خطا');
    }

    if (!mounted) return;

    setState(() {
      scanResult_code = barcodeScanRes;
    });
  }

  Future scanBarcode() async {
    String? scanResult;
    setState(() {
      _scanloading = true;
    });
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', "cancel", true, ScanMode.BARCODE)
          .then((value) {
        print(value);
      });
      // .then(
      //   (value) => Provider.of<AppointmentManager>(context, listen: false)
      //       .attendlesson(group_id_selected, value, app_id_selected),
      // )
      // .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       backgroundColor: Colors.green[300],
      //       content: Text(
      //         'تم تسجيل حضور الطالب بنجاح',
      //         style: TextStyle(fontFamily: 'GE-medium'),
      //       ),
      //       duration: Duration(seconds: 3),
      //     )));
    } on PlatformException {
      _showErrorDialog('حاول مره اخري', 'حدث خطا');
    }
    if (!mounted) return;
    setState(() {
      scanResult_code = scanResult!;

      _scanloading = false;
    });
  }
}

class Choice_container extends StatelessWidget {
  Choice_container(
      {Key? key,
      required this.size,
      required this.color,
      required this.items,
      // required this.value,
      required this.fnc,
      required this.hinttext,
      required this.active,
      this.loading = false})
      : super(key: key);
  final String hinttext;
  final Size size;
  final Color color;
  final List<String> items;
  // final String value;
  final Function() fnc;
  final bool active;
  final bool? loading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 6),
      margin: EdgeInsets.all(1),
      alignment: Alignment.center,
      height: size.height * .6 * .14,
      // height: 40,
      width: size.width * .45,
      decoration: BoxDecoration(
        color: active ? color : color.withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: active ? () => fnc() : null,
        child: Container(
          child: Row(
            children: [
              loading!
                  ? CircularProgressIndicator()
                  : Container(
                      width: size.width * .35,
                      child: Text(
                        hinttext,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            fontFamily: 'AraHamah1964B-Bold',
                            fontSize: 20,
                            color: active ? Colors.black : Colors.black26),
                      ),
                    ),
              Spacer(),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
      ),
    );
  }
}

class Button_Container extends StatelessWidget {
  const Button_Container(
      {Key? key,
      required this.size,
      required this.color,
      required this.text,
      required this.fnc})
      : super(key: key);
  final Size size;
  final Color color;
  final String text;
  final VoidCallback fnc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fnc,
      child: Container(
        margin: EdgeInsets.all(1),
        alignment: Alignment.center,
        height: size.height * .6 * .14,
        // height: 40,
        width: size.width * .45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: size.width * .4,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                    fontFamily: 'AraHamah1964B-Bold',
                    fontSize: size.width * .06),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
