import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class EvaluacionesBloc {

  static final EvaluacionesBloc _singleton = new EvaluacionesBloc._internal();

  factory EvaluacionesBloc() {
    return _singleton;
  }

  EvaluacionesBloc._internal() {  }

  final _evaluacionController = BehaviorSubject<EvaluacionModel>();

  Stream<EvaluacionModel> get evaluacionStream  => _evaluacionController.stream;

  EvaluacionModel get evaluacion => _evaluacionController.value;

  dispose() {
    _evaluacionController?.close();
  }

  addEvaluacion( EvaluacionModel nuevaEvaluacion, int idDeficiencia ) async {
    nuevaEvaluacion.idDeficiencia = idDeficiencia;
    await DBProvider.db.nuevaEvaluacion(nuevaEvaluacion);

    final evaluacion = await DBProvider.db.getEvaluacionByIdDeficiencia(idDeficiencia);
    nuevaEvaluacion.id = evaluacion.id;
    if ( nuevaEvaluacion.fotos != null ) {
      await DBProvider.db.nuevaFoto(nuevaEvaluacion);
    }
    if ( nuevaEvaluacion.coordenadas.latitud != 0.0 ) {
      await DBProvider.db.nuevaCoordenada(nuevaEvaluacion);
    }
  }

  getEvaluacion( int idDeficiencia ) async {
    final evaluacion = await DBProvider.db.getEvaluacionByIdDeficiencia(idDeficiencia);
    if ( evaluacion != null ) {
      evaluacion.fotos = await DBProvider.db.getFotoByIdEvaluacion(evaluacion.id);
      evaluacion.coordenadas = await DBProvider.db.getCoordenadasByIdEvaluacion(evaluacion.id);
    }
 
    _evaluacionController.sink.add(evaluacion);
  }

  editarEvaluacion( EvaluacionModel evaluacion ) async {
    await DBProvider.db.editarEvaluacion(evaluacion);
    if ( evaluacion.coordenadas.latitud != null ) {
      final coordenadas = await DBProvider.db.getCoordenadasByIdEvaluacion(evaluacion.id);
      if(  coordenadas != null ){
        await DBProvider.db.editarCoordenadas(coordenadas);
      } else {
        await DBProvider.db.nuevaCoordenada(evaluacion);
      }
    }
    if ( evaluacion.fotos != null ) {
      await DBProvider.db.editarFoto(evaluacion);
    }

  }




}