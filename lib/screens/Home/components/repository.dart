import 'package:attendance/screens/Home/components/code_data.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

import 'home_data.dart';
import 'home_repository.dart';

class SembastHomeDataRepository extends HomeDataRepository {
  final Database _database = GetIt.I.get();
    final Database __database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("HomeData_store");
  final StoreRef __store = intMapStoreFactory.store("Code");

  @override
  Future<int> insertHomeData(HomeData HomeData) async {
    return await _store.add(_database, HomeData.toMap());
  }


@override
 Future<int> insert(CodeData codeData) async {
    return await __store.add(__database, codeData.toMap());
  }

  @override
  Future updateHomeData(HomeData HomeData) async {
    await _store.record(HomeData.id).update(_database, HomeData.toMap());
  }

  @override
  Future deleteHomeData(int HomeDataId) async{
    await _store.record(HomeDataId).delete(_database);
  }
  
  @override
  Future deleteCodeData(int HomeDataId) async{
    await __store.record(HomeDataId).delete(__database);
  }

  @override
  Future<List<HomeData>> getAllHomeData() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => HomeData.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }

  
  @override
  Future<List<CodeData>> getAllCodeData() async {
    final snapshots = await __store.find(__database);
    return snapshots
        .map((snapshot) => CodeData.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }
}