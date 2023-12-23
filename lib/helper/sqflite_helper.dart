import 'dart:io';


import 'package:learn_project/model/doctor_model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';

class DoctorHelper {
  late Database database;
  static DoctorHelper dbHelper = DoctorHelper();
  final String tableName = 'doctorlist';
  final String titleColumn = 'title';
  final String idColumn = 'id';
  final String qualificationColumn = 'qualification';
  final String nameColumn = 'name';
  final String specialtyColumn = 'specialty';
  final String designationColumn = 'designation';
  final String organizationColumn = 'organization';
  final String genderColumn = 'gender';
  final String bmdcNumberColumn = 'bmdc_number';
  final String doctorPhotoColumn = 'doctor_photo';
  final String createColumn = 'created_at';
  final String updatedAtColumn = 'updated_at';
  final String deleteAtColumn = 'deleted_at';

  initDatabase() async {
    database = await connectToDatabase();
  }

  Future<Database> connectToDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '$directory/list.db';
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          // 'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $productNameColumn TEXT, $priceColumn INTEGER,$vatPercentColumn INTEGER,  $categoryNameColumn TEXT, $companyNameColumn TEXT, $unitNameColumn TEXT,$genericNameColumn TEXT,$strengthColumn TEXT,)');

            'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $titleColumn TEXT, $qualificationColumn TEXT, $specialtyColumn TEXT, $designationColumn TEXT, $organizationColumn TEXT,$genderColumn INTEGER,$bmdcNumberColumn TEXT,$doctorPhotoColumn TEXT, $createColumn TEXT,$updatedAtColumn TEXT,$deleteAtColumn TEXT)');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute(
            'CREATE TABLE $tableName ($idColumn INTEGER PRIMARY KEY AUTOINCREMENT, $nameColumn TEXT, $titleColumn TEXT, $qualificationColumn TEXT, $specialtyColumn TEXT, $designationColumn TEXT, $organizationColumn TEXT,$genderColumn INTEGER,$bmdcNumberColumn TEXT,$doctorPhotoColumn TEXT, $createColumn TEXT,$updatedAtColumn TEXT,$deleteAtColumn TEXT)');
      },
      onDowngrade: (db, oldVersion, newVersion) {
        db.delete(tableName);
      },
    );
  }

  Future<List<Data>> getAllRecipes() async {
    List<Map<String, dynamic>> tasks = await database.query(tableName);

    print("brand data---------------------.${tasks}");

    print("grand length-------------------->${tasks.length}");
    return tasks.map((e) => Data.fromJson(e)).toList();
  }

  insertNewRecipe(Data recipeModel) {
    database.insert(tableName, recipeModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // insertNewRecipe2(CompanyData recipeModel) {
  //   database.insert("company", recipeModel.toJson(),conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  deleteRecipe(Data recipeModel) {
    database.delete(tableName, where: '$idColumn=?', whereArgs: [recipeModel]);
  }

  deleteRecipes() {
    database.delete(tableName);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await database;
    return await db.rawQuery('''
    select 
    company.name, branddata.* 
    from branddata 
    left join company on branddata.company_id = company.id 
    ''');
  }

// Future<List<Map<String, dynamic>>> leftJoinTables() async {
//   final  db =  await database;
//
//   final query = '''
//   SELECT branddata.*, company.*
//   FROM branddata
//   LEFT JOIN company ON branddata.company_id = company.id
// ''';
//
//   return await db.rawQuery(query);
// }
}