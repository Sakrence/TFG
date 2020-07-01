import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class DeficienciaBloc {

  static final DeficienciaBloc _singleton = new DeficienciaBloc._internal();

  factory DeficienciaBloc() {
    return _singleton;
  }

  DeficienciaBloc._internal();

  final _contadorController = BehaviorSubject<int>();
  final _deficienciasController = BehaviorSubject<List<DeficienciaModel>>();

  Stream<int> get contadorStream                      => _contadorController.stream;
  Stream<List<DeficienciaModel>> get deficienciasStream  => _deficienciasController.stream;

  Function(int) get changeContador              => _contadorController.sink.add;
  Function(List<DeficienciaModel>) get changeDeficiencias  => _deficienciasController.sink.add;

  int get contador             => _contadorController.value;
  List<DeficienciaModel> get deficiencias => _deficienciasController.value;

  dispose() {
    _contadorController?.close();
    _deficienciasController?.close();
  }

  addDeficiencia(FactorRiesgoModel factor, int idInspeccion) async {

    final nuevaDeficiencia = DeficienciaModel(idFactorRiesgo: factor.id, idInspeccion: idInspeccion);
    await DBProvider.db.nuevaDeficiencia(nuevaDeficiencia);
    obtenerDeficiencias(idInspeccion);
  }

  removeDeficiencia( DeficienciaModel deficiencia, InspeccionModel inspeccion ) async {

    await DBProvider.db.deleteDeficiencia(deficiencia);
    obtenerDeficiencias(inspeccion.id);
  }

  obtenerDeficiencias( int idInspeccion ) async {

    List<DeficienciaModel> deficiencias = await DBProvider.db.getDeficienciasByIdInspeccion(idInspeccion);

    for (var i = 0; i < deficiencias.length; i++) {
      deficiencias[i].factorRiesgo = await DBProvider.db.getFactorById(deficiencias[i].idFactorRiesgo);

      deficiencias[i].evaluacion = await DBProvider.db.getEvaluacionByIdDeficiencia(deficiencias[i].id);
      if ( deficiencias[i].evaluacion != null ) {
        deficiencias[i].evaluacion.fotos = await DBProvider.db.getFotoByIdEvaluacion(deficiencias[i].evaluacion.id);
        deficiencias[i].evaluacion.coordenadas = await DBProvider.db.getCoordenadasByIdEvaluacion(deficiencias[i].evaluacion.id);
        if ( deficiencias[i].evaluacion.coordenadas == null ) {          
          deficiencias[i].evaluacion.coordenadas = Coordenadas(latitud: 0.0, longitud: 0.0);
        }
      }
    }

    _deficienciasController.sink.add( deficiencias );
    _contadorController.sink.add( deficiencias.length );
    
  }


}