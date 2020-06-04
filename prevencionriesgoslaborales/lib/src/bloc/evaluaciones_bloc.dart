import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:rxdart/rxdart.dart';

class EvaluacionesBloc {

  static final EvaluacionesBloc _singleton = new EvaluacionesBloc._internal();

  factory EvaluacionesBloc() {
    return _singleton;
  }

  EvaluacionesBloc._internal() {
    changeContador(0);
    changeFactores([]);
    // Obtener Categorias de la Base de datos
    // obtenerCategorias();
    // _categoriaSeleccionadaController.listen((value) {
    //   obtenerSubcategorias();
    //  });
  }


  final _contadorController = BehaviorSubject<int>();
  final _factoresController = BehaviorSubject<List<Categoria>>();

  // Recuperar los datos del Stream
  Stream<int> get contadorStream              => _contadorController.stream;
  Stream<List<Categoria>> get factoresStream  => _factoresController.stream;

  // Insertar valores al Stream
  Function(int) get changeContador              => _contadorController.sink.add;
  Function(List<Categoria>) get changeFactores  => _factoresController.sink.add;

  // Obtener el último valor ingresado a los streams
  int get contador             => _contadorController.value;
  List<Categoria> get factores => _factoresController.value;

  dispose() {
    _contadorController?.close();
    _factoresController?.close();
  }

  addFactor(Categoria factor) {

    final factores = _factoresController.value;

    if ( !factores.contains(factor) ) {
      factores.add(factor);
      changeFactores(factores);
      final contador = _contadorController.value + 1;
      changeContador( contador );
    }
    
  }

  removeFactor( String id ) {
    final factores = _factoresController.value;
    factores.removeAt(int.parse(id));
    final contador = _contadorController.value - 1;
    changeContador( contador );
  }

  // obtenerSubcategorias() async {
  //   // print("ID_Seleccionado: ${_categoriaSeleccionadaController.value.id}");
  //   _subcategoriasController.sink.add( await categoriasProvider.cargarSubcategorias(seleccionada) );
  //   // print("INDEX 7 de subcategorias: ${_subcategoriasController.value[0]}");
  // }


}