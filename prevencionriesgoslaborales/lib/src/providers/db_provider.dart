import 'dart:io';

import 'package:path/path.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
export 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {

    if ( _database != null ) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join( documentsDirectory.path, 'InspeccionesDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {

        await db.execute(
          'CREATE TABLE Inspector ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' nombre TEXT'
          ')'
        );

        await db.execute(
          'CREATE TABLE Inspecciones ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' fechaInicio INTEGER,'
          ' fechaFin INTEGER,'
          ' direccion TEXT,'
          ' provincia TEXT,'
          ' pais TEXT,'
          ' latitud REAL,'
          ' longitud REAL,'
          ' comentarios TEXT,'
          ' idInspector INTEGER,'
          ' deficiencias INTEGER,'
          ' FOREIGN KEY (idInspector) REFERENCES Inspector (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );
        
      }
    
    );

  }

  // CREAR Registros
  nuevaInspeccionRaw( InspeccionModel nuevaInspeccion ) async {

    final db = await database;

    final res = await db.rawInsert(
      "INSERT Into Inspecciones (fechaInicio, direccion, comentarios, idInspector) "
      "VALUES ( '${ nuevaInspeccion.fechaInicio }', '${ nuevaInspeccion.direccion }', '${ nuevaInspeccion.comentarios }', ${ nuevaInspeccion.idInspector} )"
    );

    return res;

  }

  nuevaInspeccion( InspeccionModel nuevaInspeccion ) async {

    final db  = await database;
    final res = await db.insert('Inspecciones', nuevaInspeccion.toJson());
    return res;
  }

  // SELECT
  Future<List<InspeccionModel>> getInspeccionesIdInspector( int id ) async {

    final db  = await database;
                                                          // and
    final res = await db.query('Inspecciones', where: 'idInspector = ?', whereArgs: [id] );

    List<InspeccionModel> list = res.isNotEmpty 
                                    ? res.map((e) => InspeccionModel.fromJson(e) ).toList()
                                    : [];
    return list;
  }


  // UPDATE
  Future<int> updateInspeccion( InspeccionModel nuevaInspeccion ) async {

    final db  = await database;
    final res = await db.update('Inspecciones', nuevaInspeccion.toJson(), where: 'id = ?', whereArgs: [nuevaInspeccion.id] );
    return res;
  }

  // DELETE
  Future<int> deleteInspeccion( int id ) async {

    final db  = await database;
    final res = await db.delete('Inspecciones', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  // Future<int> deleteAll() async {

  //   final db = await database;
  //   final res = await db.delete('Inspecciones');
  //   return res;
  // }

}
