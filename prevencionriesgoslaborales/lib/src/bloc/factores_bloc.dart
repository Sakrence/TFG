import 'dart:async';

import 'package:prevencionriesgoslaborales/src/bloc/bloc_provider.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';
import 'package:rxdart/rxdart.dart';

class FactoresBloc extends BlocBase {

  FactoresBloc(CategoriaModel categoria) {
    // changeContador(0);
    changeFactores([]);
    getFactores (categoria);
  }


  // final _contadorController = BehaviorSubject<int>();
  final _factoresController = BehaviorSubject<List<FactorRiesgoModel>>();

  // Stream<int> get contadorStream                      => _contadorController.stream;
  Stream<List<FactorRiesgoModel>> get factoresStream          => _factoresController.stream;

  // Function(int) get changeContador              => _contadorController.sink.add;
  Function(List<FactorRiesgoModel>) get changeFactores  => _factoresController.sink.add;

  // int get contador             => _contadorController.value;
  List<FactorRiesgoModel> get factores => _factoresController.value;



  
  void getFactores (CategoriaModel categoria) async {
    // DbApi dbApi = DbApi();
    // _factores = dbApi.getFactores (categoria);
    // _inFactores.add (_factores);
    
    final factores = await categoriasProvider.cargarSubcategorias(categoria);
    changeFactores(factores);

  }

  addFactor(FactorRiesgoModel factor) {

    final factores = _factoresController.value;

    if ( !factores.contains(factor) ) {
      factores.add(factor);
      changeFactores(factores);
      // final contador = _contadorController.value + 1;
      // changeContador( contador );
    }
    
  }

  removeFactor( FactorRiesgoModel factor ) {
    final factores = _factoresController.value;
    factores.remove(factor);
    // final contador = _contadorController.value - 1;
    // changeContador( contador );
  }

  void dispose () {
    // _contadorController?.close();
    _factoresController?.close();
  }
}