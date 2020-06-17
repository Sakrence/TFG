import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
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

  // Recuperar los datos del Stream
  Stream<int> get contadorStream                      => _contadorController.stream;
  Stream<List<DeficienciaModel>> get deficienciasStream  => _deficienciasController.stream;

  // Insertar valores al Stream
  Function(int) get changeContador              => _contadorController.sink.add;
  Function(List<DeficienciaModel>) get changeDeficiencias  => _deficienciasController.sink.add;

  // Obtener el último valor ingresado a los streams
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

    // final evaluacion = new EvaluacionModel();

    // final deficiencia = new DeficienciaModel(evaluacion: evaluacion, factorRiesgo: factor);

    // if ( _deficienciasController.value == null ) changeDeficiencias([]);


    // final List<DeficienciaModel> deficiencias = _deficienciasController.value;

    // if ( deficiencias == null || !deficiencias.contains(deficiencia) ) {

    //   // deficiencias.add(deficiencia);
    //   changeDeficiencias(deficiencias);

    //   int contador;
    //   if ( _contadorController.value == null ){
    //     contador = 0;
    //   } else {
    //     contador = _contadorController.value;
    //   }
      
    //   contador = contador + 1;
    //   changeContador( contador );

    // }

  }

  removeDeficiencia( DeficienciaModel deficiencia ) {

    final deficiencias = _deficienciasController.value;
    deficiencias.remove(deficiencia);
    changeDeficiencias(deficiencias);
    final contador = _contadorController.value -1;
    changeContador(contador);

  }

  obtenerDeficiencias( int idInspeccion ) async {

    List<DeficienciaModel> deficiencias = await DBProvider.db.getDeficienciasByIdInspeccion(idInspeccion);

    for (var i = 0; i < deficiencias.length; i++) {
      deficiencias[i].factorRiesgo = await DBProvider.db.getFactorById(deficiencias[i].idFactorRiesgo);

      // deficiencias[i].evaluacion = await DBProvider.db.getEvaluacionByIdDeficiencia(deficiencias[i].id);
    }

    _deficienciasController.sink.add( deficiencias );
    _contadorController.sink.add( deficiencias.length );
    
  }


}