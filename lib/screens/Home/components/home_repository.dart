


import 'package:attendance/screens/Home/components/code_data.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

import 'home_data.dart';

abstract class HomeDataRepository {

  Future<int> insertHomeData(HomeData HomeData);
  Future<int> insert(CodeData codeData);

  Future updateHomeData(HomeData HomeData);

  Future deleteHomeData(int HomeDataId);
 Future deleteCodeData(int HomeDataId);
  Future<List<HomeData>> getAllHomeData();
  Future<List<CodeData>> getAllCodeData();
}


