import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';

import 'package:prevencionriesgoslaborales/src/pages/home.dart';
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
        initialRoute: 'home',
        routes: {
          'home' : ( BuildContext conext ) => HomePage(),
          'subcategoria' : ( BuildContext conext ) => SubcategoriaPage(),
        },
      ),
    );
  }
}