import 'package:attendance/managers/Student_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class Students_Page_Title extends StatelessWidget {
  const Students_Page_Title({
    Key? key,
    required this.title,
    this.id,
  }) : super(key: key);

  final title;
  final id;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Consumer<StudentManager>(
              builder: (builder, studentManager, child) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontFamily: 'GE-bold',
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        InkWell(
                          onTap: () {
                            launch(
                                'https://development.mrsaidmostafa.com/api/exports/students/groups/$id');
                          },
                          child: Text('تصدير اكسل',
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'GE-light',
                                fontSize: 15,
                              )),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          studentManager.studNumberInGroup.toString(),
                          style: TextStyle(
                              fontFamily: 'GE-medium',
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'طالب',
                          style: TextStyle(
                              fontFamily: 'GE-medium',
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
