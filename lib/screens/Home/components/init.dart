import 'package:attendance/screens/Home/components/code_repository.dart';
import 'package:attendance/screens/Home/components/home_repository.dart';
import 'package:attendance/screens/Home/components/repository.dart';
import 'package:attendance/screens/Home/components/repository_code.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
  bool done = false;
class Init {

  static Future initialize() async {
    await _initSembast();
    await _registerRepositories();
    // await _registerRepositoriess();
  }

  static Future _initSembast() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "home.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    if (!GetIt.I.isRegistered<Database>()) {
      GetIt.I.registerSingleton<Database>(database);
    }
  }

  static _registerRepositories() {
    // GetIt s1 = GetIt.instance;
    GetIt locator = GetIt.instance;
    if (done == false) {
      locator.registerLazySingleton<HomeDataRepository>(
          () => SembastHomeDataRepository());
      done = true;
    }

    //     GetIt locatorr = GetIt.instance;
    // locatorr.registerLazySingleton<CodeDataRepository>(
    //     () => SembastCodeDataRepository());
  }

  // static _registerRepositoriess() {
  //   // GetIt s1 = GetIt.instance;
  //   //GetIt locator = GetIt.instance;
  //   GetIt.instance.registerLazySingleton<CodeDataRepository>(
  //       () => SembastCodeDataRepository());
  // }
}
