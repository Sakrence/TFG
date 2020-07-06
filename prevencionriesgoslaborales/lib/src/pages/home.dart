import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:prevencionriesgoslaborales/src/bloc/factores_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/widgets/fondoApp.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.categoriasBloc(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          FondoApp(),

          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _titulos(),
                _botonesRedondeados(bloc),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _titulos() {

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Prevención Riesgos Laborlaes', style: TextStyle( color: Colors.black87, fontSize: 25.0, fontWeight: FontWeight.bold)),
            SizedBox( height: 10.0),
            Text('Selecciona el riesgo laboral encontrado', style: TextStyle( color: Colors.black, fontSize: 16.0))
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeados( CategoriasBloc bloc) {
    
    return Container(
      child: StreamBuilder(
        stream: bloc.categoriasStream,
        builder: (BuildContext context , AsyncSnapshot<List<CategoriaModel>> categorias ){
          if (categorias.hasData) {

            List<TableRow> rows = [];

            for (var i = 0; i < categorias.data.length; i = i + 2) {

              if ( i+1 != categorias.data.length ) {

                rows.add(TableRow(
                  children: [
                    _crearBotonRedondeado( context, Colors.blue, categorias.data[i], bloc ),
                    _crearBotonRedondeado( context, Colors.blue, categorias.data[i+1], bloc ),
                  ]
                ));

              } else {
                
                rows.add(TableRow(
                  children: [
                    _crearBotonRedondeado( context, Colors.blue, categorias.data[i], bloc ),
                    Container()
                  ]
                ));

              }
            }

            return Table(children: rows);

          } else return Text ('No hay datos');
        },
      ),
    );
                  
  }

  Widget _crearBotonRedondeado(BuildContext context, Color color, CategoriaModel categoria, CategoriasBloc bloc) {

    final card = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          FadeInImage(
            placeholder: AssetImage('assets/img/original.gif'),
            image: AssetImage('assets/riesgos/${categoria.icono}_V-01.png'),
            fadeInDuration: Duration( milliseconds: 200 ),
            height: 165.0,
            fit: BoxFit.cover,
          ),

          Expanded(
            key: Key('${categoria.id.toString()}'),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text( categoria.nombre, style: TextStyle(fontWeight: FontWeight.w500 ))
            ),
          )
        ],
      )
    );
  
    return GestureDetector(
      onTap: () {
        Provider.of(context).factoresBloc = FactoresBloc(categoria);

        Navigator.pushNamed(context, 'subcategoria');
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          height: 220.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0)
              )
            ]
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: card,
          ),
        ),
      ),
    );
  }
}