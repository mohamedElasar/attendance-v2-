// import 'dart:convert';

// import 'package:get_it/get_it.dart';
// import 'package:sembast/sembast.dart';

// import 'code_data.dart';
// import 'code_repository.dart';
// import 'home_data.dart';
// import 'home_repository.dart';

// class SembastCodeDataRepository extends CodeDataRepository {
//   final Database _database = GetIt.I.get();
//   final StoreRef _store = intMapStoreFactory.store("HomeData_store");

//   @override
//   Future<int> insertCodeData(CodeData codeData) async {
//     return await _store.add(_database, codeData.toMap());
//   }


// //   gg() async {
// //     // Import the data
// //     var map = jsonDecode(saved) as Map;
// //     var importedDb = await importDatabase(map, databaseFactory, 'imported.db');

// // // Check the lamp price
// //     expect((await _store.record('lampKey').get(importedDb))['price'], 12);
// //   }

//   @override
//   Future updateCodeData(CodeData CodeData) async {
//     await _store.record(CodeData.id).update(_database, CodeData.toMap());
//   }

//   @override
//   Future deleteCodeData(int codeDataId) async {
//     await _store.record(codeDataId).delete(_database);
//   }

//   @override
//   Future<List<CodeData>> getAllCodeData() async {
//     final snapshots = await _store.find(_database);
//     return snapshots
//         .map((snapshot) => CodeData.fromMap(snapshot.key, snapshot.value))
//         .toList(growable: false);
//   }
// }
