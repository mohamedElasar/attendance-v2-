import 'dart:async';
import 'dart:io';
// import 'dart:html';
import 'package:attendance/constants.dart';
import 'package:attendance/helper/httpexception.dart';
import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/models/StudentModelSimple.dart';
import 'package:attendance/models/appointment.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/show_group_presence/components/Presence_top_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'components/connectivity.dart';
import 'package:url_launcher/url_launcher.dart';

bool refresh_degree = false;
String path = '';
//int count_deree = 0;
List degree_list = [];
List id_list = [];
var degree_value = '';
bool show_select = false;
bool is_true = false;
bool _is = true;
List<String> userChecked = [];
bool is_visible = false;
// List<bool> checkBoxValues = [];
bool ok = false;
int l_index = 0;
bool add = false;
int _selectedIndex = 0;
bool _checked = false;
bool is__checked = false;
List<bool> _is_checked = [];
var _isLoading = false;
String? Group_Id;
int? Student__id;
String Lesson_Id = '';
//List<String> search_list = [];
List<String> mysearch_list = [];

List<int> list_index = [0, 1, 2, 3];
String result = '';

class Show_Group_Presence extends StatefulWidget {
  final String? group_id;

  final GroupModelSimple? mygroup;
  final String? mylessonid;
  final AppointmentModel? mylesson;
  // final String? lessonid;
  static MaterialPage page(
      {required String groupid,
      required GroupModelSimple group,
      required String lessonid,
      required AppointmentModel lesson}) {
    return MaterialPage(
      name: Attendance_Screens.classattend,
      key: ValueKey(Attendance_Screens.classattend),
      child: Show_Group_Presence(
        group_id: groupid,
        mygroup: group,
        mylessonid: lessonid,
        mylesson: lesson,
      ),
    );
  }

  // @override

  Show_Group_Presence({
    Key? key,
    this.group_id,
    this.mygroup,
    this.mylessonid,
    this.mylesson,
  }) : super(key: key);

  @override
  _Show_Group_PresenceState createState() => _Show_Group_PresenceState();
}

class _Show_Group_PresenceState extends State<Show_Group_Presence> {
  // List<String> search_list = [];
  void _Selected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  bool sent = false;

  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode fnode = FocusNode();

  var _isLoading = false;
  Map<String, dynamic> _register_data = {
    'name': '',
  };

  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }

  void _showErrorDialog(String message, String title, context) {
    showDialog(
      context: context,
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
                '????????',
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

  void _showstudentsCompensate(
      {String? title, List<StudentModelSimple>? com_students, context}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title!,
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Container(
          height: 300,
          child: ListView.builder(
            itemBuilder: (ctx, index) => ListTile(
              leading: Text('com_students![index].name!'),
            ),
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kbuttonColor2)),
              // color: kbackgroundColor1,
              child: Text(
                '????????',
                style: TextStyle(fontFamily: 'GE-medium', color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  // int _selectedIndex = 0;

  // _onSelected(int index) {
  //   setState(() => _selectedIndex = index);
  // }

  String button_text = '?????????? ????????';
  bool show_text = false;

  // List<String> items = [
  //   '???????? ????????',
  //   '???????? ????????????',
  //   '?????? ????????',
  //   '???????? ????????????????',
  //   '???????? ????????',
  //   '???????? ????????????',
  //   '?????? ????????',
  //   '???????? ????????????????'
  // ];
  var colors = [
    kbuttonColor3.withOpacity(.8),
    kbuttonColor3.withOpacity(.6),
  ];
  var text_colors = [Colors.black, Colors.black];
  String text = '';

  Map<String, dynamic> _add_data = {
    'year': null,
  };

  //var yearController = TextEditingController();
  var degreeController = TextEditingController();
  Map _source = {ConnectivityResult.none: false};
  final MyConnectivity _connectivity = MyConnectivity.instance;
  String text_value = '';

  bool _isloading = true;
  //List<bool> _isChecked = [];
  int search_list_length = 0;
  // for(var i=0 ; i< search_list_length ;i++){
  //   _isChecked[i]= false;
  // }
  void deleteAll() async {
    await deleteDatabase(path);
  }

  @override
  void initState() {
    super.initState();
    //deleteDatabase(path);

    _connectivity.initialise();

    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
    //if (ok == true) {
    _is_checked = List<bool>.filled(mysearch_list.length, false);
    print('ok my search_listtttttttttt');
    print(mysearch_list);

    Future.delayed(Duration.zero, () async {
      // Provider.of<AppointmentManager>(context, listen: false).resetlist();
      try {
        await Provider.of<AppointmentManager>(this.context, listen: false)
            .get_students_attending_lesson(widget.group_id!, widget.mylessonid!)
            .then((_) {
          setState(() {
            _isloading = false;

            // search_list = search_list_all;

            Lesson_Id = widget.mylessonid!;
            print('LESSON_Id');
            print(Lesson_Id);
            print('widget.group_id!');
            print(widget.group_id!);

            //search_list_all = search_list;
            //isLoading = false;
          });
          // AppointmentManager j =new AppointmentManager();
          // if (j.student_attend.length > 0) {
          //  setState(() {
          //show_select = true;

          print('j.student_attend.length');
          print(AppointmentManager.myattend.length);
          // });
          // }
        });
        // AppointmentManager j = AppointmentManager();
        // print('j.student_attend.length');
        //       print(j.student_attend.length);
      } catch (e) {}
      if (!mounted) return;
    });

    Future.delayed(Duration.zero, () async {
      try {
        await Provider.of<AppointmentManager>(this.context, listen: false)
            .get_degrees(widget.mylessonid!)
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

  TextEditingController searchcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Show_Presence_Top_Page(
                  size: size,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 20,
                      end: 20,
                      top: 20,
                    ),
                    child: Wrap(spacing: 10.0, runSpacing: 10.0, children: <
                        Widget>[
                      buildChip(widget.mygroup!.name!),
                      buildChip(widget.mygroup!.subject!.name!),
                      // buildChip('???????????? ???????????????? 2'),
                      buildChip(widget.mygroup!.teacher!.name!),
                      buildChip('???????? ?????????? :  ${widget.mylesson!.time}'),
                      buildChip('?????????? ?????????? :  ${widget.mylesson!.date}'),
                      buildChip(
                          '????????????:  ${widget.mylesson!.students!.length.toString()}'),
                      InkWell(
                        onTap: () {
                          // _showstudentsCompensate(
                          //     title: '??????????????',
                          //     context: context,
                          //     com_students:
                          //         widget.mylesson!.compensateStudents!);
                        },
                        child: buildChip(
                            '??????????????:  ${widget.mylesson!.compensateStudents!.length.toString()}'),
                      ),
                      InkWell(
                          onTap: () {
                            launch(
                                'https://development.mrsaidmostafa.com/api/exports/students/appointments/${widget.mylesson!.id!}');
                          },
                          child: buildChip('?????????? ????????', link: true)),
                      Visibility(
                        visible: AppointmentManager.myattend.length > 0
                            ? true
                            : false,
                        child: InkWell(
                          child: buildChip(' ??????', link: true),
                          onTap: () async {
                            await showSearch(
                                context: context,
                                delegate: StudentSearch(widget.mylesson!));
                          },
                          onDoubleTap: () async {
                            setState(() {
                              _isloading = true;
                            });
                            await Provider.of<AppointmentManager>(this.context,
                                    listen: false)
                                .get_students_attending_lesson(
                                    widget.group_id!, widget.mylessonid!)
                                .then((value) => setState(() {
                                      _isloading = false;
                                    }));
                          },
                        ),
                      ),

                      // TextFormField(
                      //   controller:searchcontroller ,
                      //   onFieldSubmitted: (value){
                      //     if (value == ''){

                      //     }else{

                      //     }
                      //   },
                      // ),
                      AppointmentManager.myattend.length > 0
                          ? IconButton(
                              icon: Icon(Icons.refresh),
                              onPressed: () async {
                                if (_ListItemState._connectionStatus ==
                                    ConnectivityResult.none) {
                                  print("no connection again");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red[400],
                                      content: Text(
                                        '???? ???????? ?????????? ??????????????????',
                                        style:
                                            TextStyle(fontFamily: 'GE-medium'),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                } else {
                                  print("reconnected");
                                  for (var i = 0; i < degree_list.length; i++) {
                                    try {
                                      setState(() {
                                        Group_Id;
                                      });

                                      await Provider.of<GroupManager>(context,
                                              listen: false)
                                          .add_degree(degree_list[i]['degree'],
                                              id_list[i]['id_value'], Lesson_Id)
                                          //                           .then((_) {
                                          //   result = '';
                                          //   setState(() {
                                          //     //sent = true;
                                          //   });
                                          // })
                                          .then((value) => setState(() {
                                                _isLoading = false;
                                              }))
                                          .then(
                                            (_) => ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.green[300],
                                                content: Text(
                                                  '???? ?????????? ???????????? ??????????',
                                                  style: TextStyle(
                                                      fontFamily: 'GE-medium'),
                                                ),
                                                duration: Duration(seconds: 3),
                                              ),
                                            ),
                                          );
                                      deleteAll();
                                    } on HttpException catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green[300],
                                          content: Text(
                                            '????????  ???????? ????????????????',
                                            style: TextStyle(
                                                fontFamily: 'GE-medium'),
                                          ),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red[400],
                                          content: Text(
                                            '????????  ???????? ????????????????',
                                            style: TextStyle(
                                                fontFamily: 'GE-medium'),
                                          ),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                    }
                                  }
                                }
                              })
                          : SizedBox()
                    ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // SizedBox(
                //   height: 20,
                // ),
                Visibility(
                  visible:
                      AppointmentManager.myattend.length > 0 ? true : false,
                  child: FlatButton(
                      // my selectAll button
                      onPressed: () {},
                      child: Row(children: [
                        SizedBox(),
                        Spacer(),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: Colors.black,
                                value:
                                    // _is_checked[widget.Index]
                                    // userChecked.contains(search_list[l_index]),
                                    _checked,
                                onChanged: (val) {
                                  setState(() {
                                    _checked = val!;
                                    if (_checked == true) {
                                      // for (var i in _is_checked) {
                                      //   i = true;
                                      // }
                                      _is_checked = List<bool>.filled(
                                          mysearch_list.length, true);
                                    } else {
                                      // for (var i in _is_checked) {
                                      //   i = false;
                                      // }
                                      _is_checked = List<bool>.filled(
                                          mysearch_list.length, false);
                                    }
                                  });
                                }),
                            Text(
                              'selecct all',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 27),
                            )
                          ],
                        ),
                      ])),
                ),
                //  :
                //           SizedBox(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20,
                        end: 20,
                        top: 10,
                      ),
                      child: Container(
                        // color: kbackgroundColor2,
                        child: Consumer<AppointmentManager>(
                            builder: (builder, appmgr, child) {
                          if (appmgr.student_attend.isEmpty || _isLoading) {
                            //show_select = false;
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                '???? ???????? ????????',
                                //  ???????? ??????????',
                                style: TextStyle(fontFamily: 'GE-Bold'),
                              ),
                            );
                          } else {
                            // show_select = true;
                            return ListView.separated(
                                separatorBuilder:
                                    (BuildContext ctxt, int Index) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Divider(
                                            color: Colors.black,
                                            height: 3,
                                            //thickness: 3,
                                          ),
                                        ),
                                // controller: _sc,
                                itemCount: appmgr.student_attend.length,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  // if(appmgr.student_attend.length>0){
                                  //        show_select = true;
                                  // }

                                  // add = true;
                                  // l_index = Index;
                                  // list_index.add(Index);
                                  // search_list
                                  //     .add(appmgr.student_attend[Index].name!);
                                  // _isChecked.length = search_list.length;
                                  // print('list_indexxxxxxxxxxx');
                                  // print(list_index);
                                  // _onSelected(Index);
                                  if (!mysearch_list.contains(
                                      appmgr.student_attend[Index].name)) {
                                    mysearch_list.add(
                                        appmgr.student_attend[Index].name!);
                                    //_isChecked.length = search_list.length;
                                    // print("my search_listtttttttt");
                                    // print(mysearch_list);
                                  }

                                  // print('_isCheckeddddddddddd');
                                  // print(_isChecked);

                                  // print('isCheckeddddddddddd');
                                  // print(_isChecked);
                                  // print("search_listtttttttt");
                                  // print(search_list);
                                  // key:

                                  Student__id = appmgr.student_attend[Index].id;
                                  // print('Student__id');
                                  // print(Student__id);

                                  return ListItem(
                                      Index, appmgr, widget.mylessonid!);
                                });
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ));
  }

  Widget buildChip(text, {link = false}) => Chip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE-medium'),
        ),
        backgroundColor: !link ? kbuttonColor3 : kbackgroundColor2,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      );
}

///

class ListItem extends StatefulWidget {
  AppointmentManager appmgr;
  @required
  final int Index;
  String lessonid;
  ListItem(this.Index, this.appmgr, this.lessonid);
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  static late ConnectivityResult _connectionStatus;
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;

  // FocusNode _usernameFocusNode = FocusNode();
  bool show_text = false;

  var added_degrees = [];

  var colors = [
    kbuttonColor3.withOpacity(.8),
    kbuttonColor3.withOpacity(.6),
  ];

  var degreeController = TextEditingController();

  List<bool> _isChecked = [];

  var text_colors = [Colors.black, Colors.black];

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> get_degree() async {
    try {
      await Provider.of<AppointmentManager>(this.context, listen: false)
          .get_degrees(widget.lessonid)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _submitwindows(Student__id, context) async {
    setState(() {
      _isLoading = true;
      ConnectivityResult.wifi;
    });
    // var connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.wifi) {
    try {
      setState(() {
        Group_Id;
      });

      await Provider.of<GroupManager>(context, listen: false)
          .add_degree(result, '$Student__id', Lesson_Id)
          .then((_) {
            result = '';
            setState(() {
              //sent = true;
            });
          })
          .then((value) => setState(() {
                _isLoading = false;
              }))
          .then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green[300],
                content: Text(
                  '???? ?????????? ???????????? ??????????',
                  style: TextStyle(fontFamily: 'GE-medium'),
                ),
                duration: Duration(seconds: 3),
              ),
            ),
          );
    } on HttpException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[300],
          content: Text(
            '????????  ???????? ????????????????',
            style: TextStyle(fontFamily: 'GE-medium'),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: Text(
            '????????  ???????? ????????????????',
            style: TextStyle(fontFamily: 'GE-medium'),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

//      else {
//       setState(() {
//         connectivityResult;
//       });
//       print("no connection");

//       var databasesPath = await getDatabasesPath();
//       path = join(databasesPath, 'student.db');

// //Delete the database
//       //await deleteDatabase(path);

// // open the database
//       Database database = await openDatabase(path, version: 1,
//           onCreate: (Database db, int version) async {
//         // When creating the db, create the table
//         await db.execute(
//             'CREATE TABLE Test (id INTEGER PRIMARY KEY, degree TEXT, id_value TEXT)');
//       });

//       await database.transaction((txn) async {
//         int id1 = await txn.rawInsert(
//             'INSERT INTO Test(degree, id_value) VALUES($result, $Student__id)');
//         print('inserted1: $id1');
//         // count_deree + 1;

//         //
//       });

//       List<Map> list = await database.rawQuery('SELECT * FROM Test');
//       degree_list = await database.rawQuery('SELECT degree FROM Test');
//       id_list = await database.rawQuery('SELECT id_value FROM Test');

//       print('sqflite degree');
//       print(degree_list[0]['degree']);
//       print('sqflite list');
//       print(list);

//       print('_connectionStatus');
//       print(_connectionStatus.toString());
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _is_checked = List<bool>.filled(mysearch_list.length, false);

//     // print('okkkk');
//     // print(mysearch_list);
//     connectivity = new Connectivity();
//     subscription = connectivity!.onConnectivityChanged
//         .listen((ConnectivityResult myresult) {
//       _connectionStatus = myresult;
//       // print('_connectionStatus');
//       // print(_connectionStatus);
//       if (myresult == ConnectivityResult.wifi)
//       // ||
//       //     result == ConnectivityResult.mobile)
//       {
//         setState(() {});
//       }
//     });
//   }
  Future<void> _submit(Student__id, context) async {
    setState(() {
      _isLoading = true;
      ConnectivityResult.wifi;
    });
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      try {
        setState(() {
          Group_Id;
        });

        await Provider.of<GroupManager>(context, listen: false)
            .add_degree(result, '$Student__id', Lesson_Id)
            .then((_) {
              result = '';
              setState(() {
                //sent = true;
              });
            })
            .then((value) => setState(() {
                  _isLoading = false;
                }))
            .then(
              (_) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[300],
                  content: Text(
                    '???? ?????????? ???????????? ??????????',
                    style: TextStyle(fontFamily: 'GE-medium'),
                  ),
                  duration: Duration(seconds: 3),
                ),
              ),
            );
      } on HttpException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: Text(
              '????????  ???????? ????????????????',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(
              '????????  ???????? ????????????????',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        connectivityResult;
      });
      print("no connection");

      var databasesPath = await getDatabasesPath();
      path = join(databasesPath, 'student.db');

//Delete the database
      //await deleteDatabase(path);

// open the database
      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute(
            'CREATE TABLE Test (id INTEGER PRIMARY KEY, degree TEXT, id_value TEXT)');
      });

      await database.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO Test(degree, id_value) VALUES($result, $Student__id)');
        print('inserted1: $id1');
        // count_deree + 1;

        //
      });

      List<Map> list = await database.rawQuery('SELECT * FROM Test');
      degree_list = await database.rawQuery('SELECT degree FROM Test');
      id_list = await database.rawQuery('SELECT id_value FROM Test');

      print('sqflite degree');
      print(degree_list[0]['degree']);
      print('sqflite list');
      print(list);

      print('_connectionStatus');
      print(_connectionStatus.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _is_checked = List<bool>.filled(mysearch_list.length, false);

    // print('okkkk');
    // print(mysearch_list);
    connectivity = new Connectivity();
    subscription = connectivity!.onConnectivityChanged
        .listen((ConnectivityResult myresult) {
      _connectionStatus = myresult;
      // print('_connectionStatus');
      // print(_connectionStatus);
      if (myresult == ConnectivityResult.wifi)
      // ||
      //     result == ConnectivityResult.mobile)
      {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        activeColor: Colors.black,
        value: _is_checked[widget.Index],
        // checked,
        // _checked
        // userChecked.contains(search_list[widget.Index]),
        onChanged: (val) {
          //  _Selected(val!, search_list[widget.Index]);
          // print('vallllllllllllllllll');
          // print(val);
          // checked = val;
          setState(() {
            _is_checked[widget.Index] = val!;
            // checked = val;
            // if (checked == true) {
            //   show_text = true;
            //   _onSelected(widget.Index);
            // }

            if (_is_checked[widget.Index] == true) {
              show_text = true;
              _onSelected(widget.Index);
            }
          });
        },

        title: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              color: colors[widget.Index % colors.length],
              child: ListTile(
                trailing: Text(
                  // '????????????',
                  widget.appmgr.student_attend[widget.Index].phone ?? '',
                  style: TextStyle(
                      color: text_colors[widget.Index % colors.length],
                      fontFamily: 'GE-light'),
                ),
                onTap: () {},
                title: Text(
                  // '????????????',

                  widget.appmgr.student_attend[widget.Index].name!,
                  style: TextStyle(
                      color: text_colors[widget.Index % colors.length],
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GE-medium'),
                ),
              ),
            ),
            // _selectedIndex != null &&
            // _selectedIndex == widget.Index &&
            _is_checked[widget.Index] == true
                //checked == true
                //list_index[index]
                ?
                // visible: _checked == false  ? false : true,
                Row(children: [
                    // Text(
                    //   '???????????? ',
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),

                    // SizedBox(width: 5,),
                    '${widget.appmgr.appointments_degree![widget.Index].degree}'
                                .isNotEmpty &&
                            '${widget.appmgr.appointments_degree![widget.Index].degree}' !=
                                "null"
                        ? Container(
                            color: Colors.amber,
                            child: Consumer<AppointmentManager>(
                                builder: (_, appointmanager, child) {
                              return Text(
                                // '???????????? ',

                                appointmanager
                                    .appointments_degree![widget.Index].degree!,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              );
                            }),
                          )
                        : SizedBox(
                            width: 10,
                          ),
                    Spacer(),
                    InkWell(
                        onTap: () async {
                          print('object');
                          // fieldFocusChange(context, _usernameFocusNode);
                          if (degreeController.text == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text(
                                  '????????  ???????? ????????????????',
                                  style: TextStyle(fontFamily: 'GE-medium'),
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            setState(() {
                              result = degreeController.text;

                              show_text = !show_text;
                            });
                            // _selectedIndex; ;;;

                            // if (_checked == true) {
                            if (Platform.isWindows) {
                              await _submitwindows(
                                      widget.appmgr.student_attend[widget.Index]
                                          .id,
                                      context)
                                  .then((value) => get_degree().then(
                                      (value) => degreeController.clear()));
                            } else {
                              await _submit(
                                      widget.appmgr.student_attend[widget.Index]
                                          .id,
                                      context)
                                  .then((value) => get_degree().then(
                                      (value) => degreeController.clear()));
                            }

                            // refresh_degree = true;;;;
                            // widget;;;
                            //     .appmgr.appointments_degree![widget.Index].degree;;;;

                            _is_checked[widget.Index] == true;
                          }

                          // added_degrees;

                          // Lesson_Id;
                        },
                        child: Icon(Icons.edit)),

                    // show_box == true
                    // ?
                    Container(
                      width: 70,
                      color: colors[widget.Index % colors.length],
                      child: TextFormField(
                        // focusNode: _usernameFocusNode,
                        // autofocus: true,
                        keyboardType: TextInputType.number,

                        // onFieldSubmitted: (val) {
                        //   print('v_vallllll');
                        //   print(val);
                        // },
                        style: TextStyle(
                            // color: Colors
                            //     .white,
                            fontWeight: FontWeight.bold),

                        onFieldSubmitted: (String str) {
                          print('object');
                          // fieldFocusChange(context, _usernameFocusNode);
                          if (str == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red[400],
                                content: Text(
                                  '????????  ???????? ????????????????',
                                  style: TextStyle(fontFamily: 'GE-medium'),
                                ),
                                duration: Duration(seconds: 3),
                              ),
                            );

                            // print('noooooooooooooooooo');
                          }
                          // print('nammmmmmmmmmmmmmmme');
                          // print(widget
                          //     .appmgr.student_attend[widget.Index].name);
                          // print(widget
                          //     .appmgr.student_attend[widget.Index].id);
                          setState(() {
                            result = str;
                            // print('ressssssssult');
                            // print(result);

                            // if (_selectedIndex == widget.Index) {
                            setState(() {
                              show_text = !show_text;

                              _selectedIndex;
                              // if (_checked == true) {
                              _submit(
                                  widget.appmgr.student_attend[widget.Index].id,
                                  context);
                              get_degree();
                              refresh_degree = true;
                              widget.appmgr.appointments_degree![widget.Index]
                                  .degree;
                              // _checked = false;
                              //   _is=false;
                              // }

                              _is_checked[widget.Index] == true;

                              // print('nammmmmmmmmmmmmmmme');
                              // print(
                              //   widget.appmgr.appointments_degree![widget.Index]
                              //       .degree!,
                              // );

                              // print(widget
                              //     .appmgr.student_attend[widget.Index].name);
                              // added_degrees.add(widget.appmgr
                              //     .student_attend[widget.Index].parentPhone);

                              added_degrees;

                              Lesson_Id;
                            });
                          });
                          degreeController.clear();
                        },

                        controller: degreeController,
                      ),
                    )
                  ])
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class StudentSearch extends SearchDelegate<String> {
  final AppointmentModel? mylesson;

  StudentSearch(this.mylesson);

  @override
  List<Widget> buildActions(BuildContext context) => [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                if (query.isEmpty) {
                  close(context, '');
                } else {
                  query = '';
                  showSuggestions(context);
                }
              },
            ),
          ],
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) =>
      FutureBuilder<List<StudentModelSimple>>(
        future: Provider.of<AppointmentManager>(context, listen: false)
            .searchStudentsDegrees(query),
        builder: (context, snapshot) {
          print(snapshot.data![0]);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Container(
                  // color: Colors.black,
                  alignment: Alignment.center,
                  child: Text(
                    '???????? ??????',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                );
              } else {
                return buildResultSuccess(snapshot.data![0]);
              }
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        child: FutureBuilder<List<StudentModelSimple>>(
          future: Provider.of<AppointmentManager>(context, listen: false)
              .searchStudentsDegrees(query),
          builder: (context, snapshot) {
            print('snapshot.data');
            print(snapshot.data);

            if (query.isEmpty) return buildNoSuggestions();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoSuggestions();
                } else {
                  return buildSuggestionsSuccess(snapshot.data);
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() => Center(
        child: Text(
          '???? ???????? ????????????????',
          style: TextStyle(fontSize: 28, color: Colors.black),
        ),
      );

  Widget buildSuggestionsSuccess(List<StudentModelSimple>? suggestions) {
    return ListView.builder(
        itemCount: suggestions!.length,
        itemBuilder: (context, index) {
          final name_suggestion = suggestions[index].name;
          print('suggestion');
          //print(suggestion);
          final name_queryText = name_suggestion!.substring(0, query.length);
          print('queryText[0');
          // print(queryText[0]);
          final name_remainingText = name_suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              Provider.of<AppointmentManager>(context, listen: false)
                  .setSearch([suggestions[index]]);
              ;

              Provider.of<AppStateManager>(context, listen: false)
                  .goToSinglelessonattend(
                      true, mylesson!.id.toString(), mylesson!);
              close(context, '');
            },
            leading: Icon(Icons.person),
            title: RichText(
              text: TextSpan(
                text: name_queryText,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: name_remainingText,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildResultSuccess(StudentModelSimple student) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3279e2), Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(64),
          children: [
            Text(
              student.name!,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 72),
            const SizedBox(height: 32),
          ],
        ),
      );
}
