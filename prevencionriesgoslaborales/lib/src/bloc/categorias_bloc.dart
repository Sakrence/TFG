import 'dart:async';

import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';

class CategoriasBloc {

  static final CategoriasBloc _singleton = new CategoriasBloc._internal();

  factory CategoriasBloc() {
    return _singleton;
  }

  CategoriasBloc._internal() {
    // Obtener Categorias de la Base de datos
    obtenerCategorias();
  }


  final _categoriasController    = StreamController<List<Categoria>>();

  // Recuperar los datos del Stream
  Stream<List<Categoria>> get categoriasStream    => _categoriasController.stream;
  

  // Insertar valores al Stream
  Function(List<Categoria>) get changeCategorias    => _categoriasController.sink.add;

  dispose() {
    _categoriasController?.close();
  }

  obtenerCategorias() async {
    _categoriasController.sink.add( await categoriasProvider.cargarData() );
  }


}