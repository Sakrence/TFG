import 'package:flutter/material.dart';

import 'package:prevencionriesgoslaborales/src/bloc/categorias_bloc.dart';
export 'package:prevencionriesgoslaborales/src/bloc/categorias_bloc.dart';

class Provider extends InheritedWidget{


  static Provider _instancia;

  factory Provider({ Key key, Widget child }) { // si necesito una nueva instancia o usar la exstente
    
    if ( _instancia == null ) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;

  }
  
  
  final categoriasBloc = CategoriasBloc();

  Provider._internal({ Key key, Widget child })
    : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CategoriasBloc of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().categoriasBloc;
  }

}