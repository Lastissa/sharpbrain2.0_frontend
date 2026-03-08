// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabasePage {
//   static Database? localDatabase;
//   Future<Database> get databaseGetter async {
//     if (localDatabase != null) {
//       return localDatabase!;
//     } else {
//       final path = join(await getDatabasesPath(), "localDatabase.db");
//       Database localDatabase = await openDatabase(
//         path,
//         onCreate: (db, version) {
//           db.rawInsert("""""");
//         },
//       );
//       return localDatabase;
//     }
//   }
// }
