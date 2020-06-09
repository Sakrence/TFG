import 'dart:async';

import 'package:prevencionriesgoslaborales/src/bloc/bloc_provider.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:rxdart/rxdart.dart';

class DeficienciaBloc extends BlocBase {

  static final DeficienciaBloc _singleton = new DeficienciaBloc._internal();

  factory DeficienciaBloc() {
    return _singleton;
  }

  DeficienciaBloc._internal();


  final _contadorController = BehaviorSubject<int>();
  // final _factoresController = BehaviorSubject<List<FactorRiesgoModel>>();
  final _deficienciasController = BehaviorSubject<List<DeficienciaModel>>();

  // Recuperar los datos del Stream
  Stream<int> get contadorStream                      => _contadorController.stream;
  // Stream<List<FactorRiesgoModel>> get factoresStream          => _factoresController.stream;
  Stream<List<DeficienciaModel>> get deficienciasStream  => _deficienciasController.stream;

  // Insertar valores al Stream
  Function(int) get changeContador              => _contadorController.sink.add;
  Function(List<DeficienciaModel>) get changeDeficiencias  => _deficienciasController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get contador             => _contadorController.value;
  // List<FactorRiesgoModel> get factores => _factoresController.value;
  List<DeficienciaModel> get deficiencias => _deficienciasController.value;

  dispose() {
    _contadorController?.close();
    // _factoresController?.close();
    _deficienciasController?.close();
  }

  addDeficiencia(FactorRiesgoModel factor) {

    final evaluacion = new EvaluacionModel();

    final deficiencia = new DeficienciaModel(evaluacion: evaluacion, factor: factor);

    if ( _deficienciasController.value == null ) changeDeficiencias([]);


    final List<DeficienciaModel> deficiencias = _deficienciasController.value;
    // final List<DeficienciaModel> deficiencias = [];

    if ( deficiencias == null || !deficiencias.contains(deficiencia) ) {

      deficiencias.add(deficiencia);
      changeDeficiencias(deficiencias);

      int contador;
      if ( _contadorController.value == null ){
        contador = 0;
      } else {
        contador = _contadorController.value;
      }
      
      contador = contador + 1;
      changeContador( contador );

    }


  }

  removeDeficiencia( DeficienciaModel deficiencia ) {

    final deficiencias = _deficienciasController.value;
    deficiencias.remove(deficiencia);
    changeDeficiencias(deficiencias);
    final contador = _contadorController.value -1;
    changeContador(contador);

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