import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Show_Class_Top_Page extends StatelessWidget {
  const Show_Class_Top_Page({Key? key, required this.size, this.group})
      : super(key: key);
  final Size size;
  final GroupModelSimple? group;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 50,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .goToSinglegroup(false, '', GroupModelSimple());
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
                    group!.name!,
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
