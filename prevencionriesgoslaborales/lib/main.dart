import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/pages/formulario_evaluacion_page.dart';

import 'package:prevencionriesgoslaborales/src/pages/home.dart';
import 'package:prevencionriesgoslaborales/src/pages/lista_evaluaciones_page.dart';
import 'package:prevencionriesgoslaborales/src/pages/lista_inspecciones.dart';
import 'package:prevencionriesgoslaborales/src/pages/login.dart';
import 'package:prevencionriesgoslaborales/src/pages/subcategorias.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent
    ));

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Prevención Riesgos Laborales',
        initialRoute: 'login',
        routes: {
          'login' : ( BuildContext conext ) => LoginPage(),
          'inspecciones' : ( BuildContext conext ) => ListaInspeccionPage(),
          'categorias' : ( BuildContext conext ) => HomePage(),
          'subcategoria' : ( BuildContext conext ) => SubcategoriaPage(),
          'listaEvaluaciones' : ( BuildContext conext ) => ListaEvaluacionPage(),
          'formPage' : ( BuildContext conext ) => FormPage(),
        },
        theme: ThemeData(primaryColor: Colors.purple),
      ),
    );
  }
}