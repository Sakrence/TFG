import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:rxdart/rxdart.dart';

class EvaluacionesBloc {

  static final EvaluacionesBloc _singleton = new EvaluacionesBloc._internal();

  factory EvaluacionesBloc() {
    return _singleton;
  }

  EvaluacionesBloc._internal() {
    // changeContador(0);
    changeEvaluaciones([]);
    // Obtener CategoriaModels de la Base de datos
    // obtenerCategoriaModels();
    // _CategoriaModelSeleccionadaController.listen((value) {
    //   obtenerSubCategoriaModels();
    //  });
  }


  final _contadorController = BehaviorSubject<int>();
  // final _factoresController = BehaviorSubject<List<FactorRiesgoModel>>();
  final _evaluacionesController = BehaviorSubject<List<EvaluacionModel>>();

  // Recuperar los datos del Stream
  Stream<int> get contadorStream                      => _contadorController.stream;
  // Stream<List<FactorRiesgoModel>> get factoresStream          => _factoresController.stream;
  Stream<List<EvaluacionModel>> get evaluacionesStream  => _evaluacionesController.stream;

  // Insertar valores al Stream
  Function(int) get changeContador              => _contadorController.sink.add;
  // Function(List<FactorRiesgoModel>) get changeFactores  => _factoresController.sink.add;
  Function(List<EvaluacionModel>) get changeEvaluaciones  => _evaluacionesController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get contador             => _contadorController.value;
  // List<FactorRiesgoModel> get factores => _factoresController.value;
  List<EvaluacionModel> get evaluaciones => _evaluacionesController.value;

  dispose() {
    _contadorController?.close();
    // _factoresController?.close();
    _evaluacionesController?.close();
  }

  addFactor(FactorRiesgoModel factor) {

    final evalucion = new EvaluacionModel();

    // final factores = _factoresController.value;

    // if ( !factores.contains(factor) ) {
    //   factores.add(factor);
    //   changeFactores(factores);
    //   final contador = _contadorController.value + 1;
    //   changeContador( contador );
    // }
    
  }

  removeFactor( FactorRiesgoModel factor ) {
    // final factores = _factoresController.value;
    // factores.remove(factor);
    // final contador = _contadorController.value - 1;
    // changeContador( contador );
  }

  // obtenerSubCategoriaModels() async {
  //   // print("ID_Seleccionado: ${_CategoriaModelSeleccionadaController.value.id}");
  //   _subCategoriaModelsController.sink.add( await CategoriaModelsProvider.cargarSubCategoriaModels(seleccionada) );
  //   // print("INDEX 7 de subCategoriaModels: ${_subCategoriaModelsController.value[0]}");
  // }


}