import 'package:flutter/material.dart';

import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';

import 'package:prevencionriesgoslaborales/src/pages/home.dart';
import 'package:prevencionriesgoslaborales/src/pages/subcategorias.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Prevención Riesgos Laborales',
        initialRoute: 'home',
        routes: {
          'home' : ( BuildContext conext ) => HomePage(),
          'subcategoria' : ( BuildContext conext ) => SubcategoriaPage(),
        },
      ),
    );
  }
}