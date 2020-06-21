import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
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
          ' FOREIGN KEY (idInspector) REFERENCES Inspector (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );

        await db.execute(
          'CREATE TABLE FactorRiesgo ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' codigo TEXT,'
          ' nombre TEXT,'
          ' icono TEXT,'
          ' idPadre INTEGER,'
          ' FOREIGN KEY (idPadre) REFERENCES FactorRiesgo (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );

        await db.execute(
          'CREATE TABLE Deficiencias ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' idFactorRiesgo INTEGER,'
          ' idInspeccion INTEGER,'
          ' FOREIGN KEY (idFactorRiesgo) REFERENCES FactorRiesgo (id) ON DELETE NO ACTION ON UPDATE NO ACTION,'
          ' FOREIGN KEY (idInspeccion) REFERENCES Inspecciones (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );

        await db.execute(
          'CREATE TABLE Evaluaciones ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' riesgo TEXT,'
          ' tipoFactor TEXT,'
          ' nivelDeficiencia INTEGER,'
          ' nivelExposicion INTEGER,'
          ' nivelConsecuencias INTEGER,'
          ' accionCorrectora TEXT,'
          ' nivelRiesgo INTEGER,'
          ' idDeficiencia INTEGER,'
          ' FOREIGN KEY (idDeficiencia) REFERENCES Deficiencias (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );

        // await db.execute(
        //   'CREATE TABLE Foto ('
        //   ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        //   ' foto BLOB,'
        //   ' idEvaluacion INTEGER,'
        //   ' FOREIGN KEY (idEvaluacion) REFERENCES Evaluaciones (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
        //   ')'
        // );
        await db.execute(
          'CREATE TABLE Foto ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' foto TEXT,'
          ' idEvaluacion INTEGER,'
          ' FOREIGN KEY (idEvaluacion) REFERENCES Evaluaciones (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );

        await db.execute(
          'CREATE TABLE Coordenadas ('
          ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' latitud REAL,'
          ' longitud REAL,'
          ' idEvaluacion INTEGER,'
          ' FOREIGN KEY (idEvaluacion) REFERENCES Evaluaciones (id) ON DELETE NO ACTION ON UPDATE NO ACTION'
          ')'
        );

        String respuesta = await rootBundle.loadString('data/categorias.json');
        Map dataMap = json.decode(respuesta);
        for (var i = 0; i < dataMap['categorias'].length; i++) {
          await db.insert('FactorRiesgo', dataMap['categorias'][i]);
        }

        respuesta = await rootBundle.loadString('data/subcategorias.json');
        dataMap = json.decode(respuesta);
        for (var i = 0; i < dataMap['subcategorias'].length; i++) {
          await db.insert('FactorRiesgo', dataMap['subcategorias'][i]);
        }
        
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

  nuevaDeficiencia( DeficienciaModel nuevaDeficiencia ) async {
    
    final db  = await database;
    final res = await db.insert('Deficiencias', nuevaDeficiencia.toJson());
    return res;
  }
  
  nuevaEvaluacion( EvaluacionModel nuevaEvaluacion ) async {
    
    final db  = await database;
    final res = await db.insert('Evaluaciones', nuevaEvaluacion.toJson());
    return res;
  }

  nuevaFoto( EvaluacionModel evaluacion ) async {
    
    final db  = await database;
    int res = 0;
    for (var i = 0; i < evaluacion.fotos.length ; i++) {
      evaluacion.fotos[i].idEvaluacion = evaluacion.id;
      await db.insert('Foto', evaluacion.fotos[i].toJson());
      res++;
    }
    return res;
  }

  nuevaCoordenada( EvaluacionModel evaluacion ) async {

    final db  = await database;
    evaluacion.coordenadas.idEvaluacion = evaluacion.id;
    return await db.insert('Coordenadas', evaluacion.coordenadas.toJson());
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

  Future<List<DeficienciaModel>> getDeficienciasByIdInspeccion( int id ) async {

    final db  = await database;
                                                          // and
    final res = await db.query('Deficiencias', where: 'idInspeccion = ?', whereArgs: [id] );

    List<DeficienciaModel> list = res.isNotEmpty 
                                    ? res.map((e) => DeficienciaModel.fromJson(e) ).toList()
                                    : [];
    return list;
  }

  Future<EvaluacionModel> getEvaluacionByIdDeficiencia( int id ) async {

    final db  = await database;
    final res = await db.query('Evaluaciones', where: 'idDeficiencia = ?', whereArgs: [id] );
    return res.isNotEmpty ? EvaluacionModel.fromJson( res.first ) : null;
  }

  Future<List<Foto>> getFotoByIdEvaluacion( int id ) async {

    final db  = await database;
                                                          // and
    final res = await db.query('Foto', where: 'idEvaluacion = ?', whereArgs: [id] );

    List<Foto> list = res.isNotEmpty 
                                    ? res.map((e) => Foto.fromJson(e) ).toList()
                                    : [];
    return list;
  }

  Future<Coordenadas> getCoordenadasByIdEvaluacion( int id ) async {

    final db  = await database;
    final res = await db.query('Coordenadas', where: 'idEvaluacion = ?', whereArgs: [id] );
    return res.isNotEmpty ? Coordenadas.fromJson( res.first ) : null;
  }

  Future<List<FactorRiesgoModel>> getAllFactoresPadre() async {

    final db  = await database;
                                                          // and
    final res = await db.query('FactorRiesgo', where: 'idPadre = ?', whereArgs: [null] );

    List<FactorRiesgoModel> list = res.isNotEmpty 
                                    ? res.map((e) => FactorRiesgoModel.fromJson(e) ).toList()
                                    : [];
    return list;
  }

  Future<List<FactorRiesgoModel>> getAllFactoresByIdPadre( int id ) async {

    final db  = await database;
                                                          // and
    final res = await db.query('FactorRiesgo', where: 'idPadre = ?', whereArgs: [id] );

    List<FactorRiesgoModel> list = res.isNotEmpty 
                                    ? res.map((e) => FactorRiesgoModel.fromJson(e) ).toList()
                                    : [];
    return list;
  }

  Future<FactorRiesgoModel> getFactorById( int id ) async {

    final db  = await database;
    final res = await db.query('FactorRiesgo', where: 'id = ?', whereArgs: [id] );
    return res.isNotEmpty ? FactorRiesgoModel.fromJson( res.first ) : null;
  }

  // UPDATE
  Future<int> updateInspeccion( InspeccionModel inspeccion ) async {

    final db  = await database;
    final res = await db.update('Inspecciones', inspeccion.toJson(), where: 'id = ?', whereArgs: [inspeccion.id] );
    return res;
  }

  Future<int> editarEvaluacion( EvaluacionModel evaluacion ) async {

    final db  = await database;
    final res = await db.update('Evaluaciones', evaluacion.toJson(), where: 'id = ?', whereArgs: [evaluacion.id] );
    return res;
  }

  Future<int> editarFoto( EvaluacionModel evaluacion ) async {

    final db  = await database;
    int res = 0;
    for (var i = 0; i < evaluacion.fotos.length ; i++) {

      if ( evaluacion.fotos[i].id == null ) {
        evaluacion.fotos[i].idEvaluacion = evaluacion.id;
        await db.insert('Foto', evaluacion.fotos[i].toJson());
        res++;
      } else {
        await db.update('Foto', evaluacion.fotos[i].toJson(), where: 'id = ? and idEvaluacion = ?', whereArgs: [evaluacion.fotos[i].id, evaluacion.id] );
        res++;
      }
    }
    return res;
  }

  Future<int> editarCoordenadas( Coordenadas coordenadas ) async {

    final db  = await database;
    // evaluacion.coordenadas.idEvaluacion = evaluacion.id;
    final res = await db.update('Coordenadas', coordenadas.toJson(), where: 'id = ?', whereArgs: [coordenadas.id] );
    return res;
  }

  // DELETE
  Future<int> deleteInspeccion( int id ) async {

    final db  = await database;
    final res = await db.delete('Inspecciones', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteDeficiencia( DeficienciaModel deficiencia ) async {

    final db  = await database;
    await db.delete('Deficiencias', where: 'id = ?', whereArgs: [deficiencia.id]);

    // EvaluacionModel evaluacion = await getEvaluacionByIdDeficiencia(deficiencia.id);
    // final aux = await db.query('Evaluaciones', where: 'idDeficiencia = ?', whereArgs: [id] );
    // EvaluacionModel evaluacion = aux.isNotEmpty ? EvaluacionModel.fromJson( aux.first ) : null;
    int res = 0;
    if ( deficiencia.evaluacion != null ) {
      res = await db.delete('Foto', where: 'idEvaluacion = ?', whereArgs: [deficiencia.evaluacion.id]);
      await db.delete('Coordenadas', where: 'idEvaluacion = ?', whereArgs: [deficiencia.evaluacion.id]);
    }
    
    await db.delete('Evaluaciones', where: 'idDeficiencia = ?', whereArgs: [deficiencia.id]);
    return (res+3);
  }

  Future<int> deleteFoto( Foto foto ) async {
    
    final db  = await database;
    final res = await db.delete('Foto', where: 'id = ?', whereArgs: [foto.id]);
    return res;
  }

}
