// import 'dart:html';
import 'dart:io';
import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/models/appointment.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AbsTopPage extends StatefulWidget {
  AbsTopPage(
      {Key? key, required this.size, this.arrowback = true, this.lessonid})
      : super(key: key);
  final Size size;
  final bool arrowback;
  final String? lessonid;

  @override
  _AbsTopPageState createState() => _AbsTopPageState();
}

class _AbsTopPageState extends State<AbsTopPage> {
  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      // width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .gotosinglelessonabs(false, '', AppointmentModel());
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          // Icon(
          //   Icons.menu,
          //   size: 30,
          // ),
          Row(
            children: [
              Icon(Icons.table_view_sharp),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'غياب الحصه',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AraHamah1964B-Bold'),
                  ),
                ),
              ),
            ],
          ),

          Container()
        ],
      ),
    );
  }
}
