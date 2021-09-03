import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/screens/Home/components/choices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Filters_top extends StatelessWidget {
  
  const Filters_top({
    Key? key,
    this.size,
  }) : super(key: key);
  final size;
  @override
  Widget build(BuildContext context) {
    Choices h = new Choices(size: this.size,);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: size.height * .2,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   // 'سنتر الياسمين',
              //   '${Auth_manager.group__name}',
              //   style: TextStyle(
              //       fontSize: 35,
              //       color: Colors.blue,
              //       fontFamily: 'AraHamah1964B-Bold'),
              // ),
              // // SizedBox(
              // //   width: 6,
              // // ),

              Consumer<Auth_manager>(builder: (context, ss, child) {
                return Text(
                  // Choices.mygroup_name,
                  ss.name,
                  style: TextStyle(
                      fontSize: 35,
                    color: Colors.blue,
                      fontFamily: 'AraHamah1964B-Bold'),
                );
              }),

              // Consumer<Choices>(
              //   builder: (_, ssh, child) {
              //   return
              Text(
                h.mygroup_name,
                // Choices.mygroup_name,
                // "Choices.groupr",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontFamily: 'AraHamah1964B-Bold'),
              )
              //   ;
              // }
              // ),

              // SizedBox(
              //   height: 2,
              // ),
            ],
          ),
        )
      ],
    );
  }
}
