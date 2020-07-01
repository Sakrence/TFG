import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class FactoresBloc {

  FactoresBloc(CategoriaModel categoria) {
    changeFactores([]);
    getFactores (categoria);
  }

  final _factoresController = BehaviorSubject<List<FactorRiesgoModel>>();

  Stream<List<FactorRiesgoModel>> get factoresStream          => _factoresController.stream;

  Function(List<FactorRiesgoModel>) get changeFactores  => _factoresController.sink.add;

  List<FactorRiesgoModel> get factores => _factoresController.value;

  void getFactores (CategoriaModel categoria) async {

    _factoresController.sink.add(await DBProvider.db.getAllFactoresByIdPadre(categoria.id));
  }

  addFactor(FactorRiesgoModel factor) {

    final factores = _factoresController.value;

    if ( !factores.contains(factor) ) {
      factores.add(factor);
      changeFactores(factores);
    }
    
  }

  removeFactor( FactorRiesgoModel factor ) {
    final factores = _factoresController.value;
    factores.remove(factor);
  }

  void dispose () {
    _factoresController?.close();
  }
}