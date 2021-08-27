import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/managers/assistant_manager.dart';
import 'package:attendance/managers/cities_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/managers/stage_manager.dart';
import 'package:attendance/managers/subject_manager.dart';
import 'package:attendance/managers/teacher_manager.dart';

import 'package:attendance/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managers/App_State_manager.dart';
import 'managers/year_manager.dart';
import 'navigation/app_router.dart';
import 'dart:io';
import 'package:desktop_window/desktop_window.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // setWindowTitle('App title');
    DesktopWindow.setWindowSize(Size(700, 680));

    DesktopWindow.setMinWindowSize(Size(700, 680));
    DesktopWindow.setMaxWindowSize(Size(700, 800));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _appStateManager = AppStateManager();
  // ignore: non_constant_identifier_names
  final _auth_Manager = Auth_manager();
  final _yearManager = YearManager();
  final _stageManager = StageManager();
  final _teachermanager = TeacherManager();
  final _citymanager = CitiesManager();
  final _groupmanager = GroupManager();
  final _studentsmanager = StudentManager();
  final _subjectmanager = SubjectManager();
  final _appointmentmanager = AppointmentManager();
  final _assistantmanager = AssistantManager();
  // final _studentmanager = StudentManager();

  // ignore: non_constant_identifier_names
  AppRouter GetRouter() {
    return AppRouter(
      studentManager: _studentsmanager,
      appStateManager: _appStateManager,
      authmanager: _auth_Manager,
      citiesManager: _citymanager,
      groupManager: _groupmanager,
      subjectManager: _subjectmanager,
      teachermanager: _teachermanager,
      yearManager: _yearManager,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => _appStateManager),
        ChangeNotifierProvider(create: (context) => _auth_Manager),
        ChangeNotifierProvider(create: (context) => _citymanager),
        ChangeNotifierProxyProvider<Auth_manager, YearManager>(
          create: (ctx) => _yearManager,
          update: (ctx, auth, prevyear) => prevyear!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevyear == null ? [] : prevyear.years),
        ),
        ChangeNotifierProxyProvider<Auth_manager, StageManager>(
          create: (ctx) => _stageManager,
          update: (ctx, auth, prevstage) => prevstage!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevstage == null ? [] : prevstage.stages!),
        ),
        ChangeNotifierProxyProvider<Auth_manager, SubjectManager>(
          create: (ctx) => _subjectmanager,
          update: (ctx, auth, prevstage) => prevstage!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevstage == null ? [] : prevstage.subjects!),
        ),
        ChangeNotifierProxyProvider<Auth_manager, TeacherManager>(
          create: (ctx) => _teachermanager,
          update: (ctx, auth, prevstage) => prevstage!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevstage == null ? [] : prevstage.teachers),
        ),
        ChangeNotifierProxyProvider<Auth_manager, GroupManager>(
          create: (ctx) => _groupmanager,
          update: (ctx, auth, prevstage) => prevstage!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevstage == null ? [] : prevstage.groups),
        ),
        ChangeNotifierProxyProvider<Auth_manager, StudentManager>(
          create: (ctx) => _studentsmanager,
          update: (ctx, auth, prevstage) => prevstage!
            // ignore: unnecessary_null_comparison
            ..receiveToken(auth, prevstage == null ? [] : prevstage.students),
        ),
        ChangeNotifierProxyProvider<Auth_manager, AppointmentManager>(
          create: (ctx) => _appointmentmanager,
          update: (ctx, auth, prevstage) => prevstage!
            ..receiveToken(
                // ignore: unnecessary_null_comparison
                auth,
                prevstage == null ? [] : prevstage.appointments!),
        ),
        ChangeNotifierProxyProvider<Auth_manager, AssistantManager>(
          create: (ctx) => _assistantmanager,
          update: (ctx, auth, prevstage) => prevstage!
            ..receiveToken(
                // ignore: unnecessary_null_comparison
                auth,
                prevstage == null ? [] : prevstage.assistants),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale("ar", "AE"),
        ],
        locale: Locale("ar", "AE"),
        debugShowCheckedModeBanner: false,
        title: 'حضور',
        theme: ThemeData(
            // canvasColor: Colors.transparent,
            ),
        home: FutureBuilder(
          future: _auth_Manager.tryAutoLogin(),
          builder: (context, datasnapshot) =>
              datasnapshot.connectionState == ConnectionState.waiting
                  ? Splash_Screen()
                  : Router(
                      routerDelegate: GetRouter(),
                      backButtonDispatcher: RootBackButtonDispatcher(),
                    ),
        ),
      ),
    );
  }
}
