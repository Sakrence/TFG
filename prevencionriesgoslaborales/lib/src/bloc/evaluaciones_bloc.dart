import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class EvaluacionesBloc {

  static final EvaluacionesBloc _singleton = new EvaluacionesBloc._internal();

  factory EvaluacionesBloc() {
    return _singleton;
  }

  EvaluacionesBloc._internal() {
    // changeContador(0);
    // changeEvaluaciones([]);
    // Obtener CategoriaModels de la Base de datos
    // obtenerCategoriaModels();
    // _CategoriaModelSeleccionadaController.listen((value) {
    //   obtenerSubCategoriaModels();
    //  });
  }


  // final _evaluacionesController = BehaviorSubject<List<EvaluacionModel>>();
  final _evaluacionController = BehaviorSubject<EvaluacionModel>();

  // Recuperar los datos del Stream
  // Stream<List<EvaluacionModel>> get evaluacionesStream  => _evaluacionesController.stream;
  Stream<EvaluacionModel> get evaluacionStream  => _evaluacionController.stream;

  // Insertar valores al Stream
  // Function(List<EvaluacionModel>) get changeEvaluaciones  => _evaluacionesController.sink.add;

  // Obtener el último valor ingresado a los streams
  // List<EvaluacionModel> get evaluaciones => _evaluacionesController.value;
  EvaluacionModel get evaluacion => _evaluacionController.value;

  dispose() {
    // _evaluacionesController?.close();
    _evaluacionController?.close();
  }

  addEvaluacion( EvaluacionModel nuevaEvaluacion, int idDeficiencia ) async {
    // final nuevaEvaluacion = EvaluacionModel(idDeficiencia: idDeficiencia);
    nuevaEvaluacion.nivelDeficiencia = idDeficiencia;
    await DBProvider.db.nuevaEvaluacion(nuevaEvaluacion);
  }

  getEvaluacion( int idDeficiencia ) async {
    final evaluacion = await DBProvider.db.getEvaluacionByIdDeficiencia(idDeficiencia);
    if ( evaluacion != null ) {
      evaluacion.fotos = await DBProvider.db.getFotoByIdEvaluacion(evaluacion.id);
      evaluacion.coordenadas = await DBProvider.db.getCoordenadasByIdEvaluacion(evaluacion.id);
    }
 
    _evaluacionController.sink.add(evaluacion);
 }




}