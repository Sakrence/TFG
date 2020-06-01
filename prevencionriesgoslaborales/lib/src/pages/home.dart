import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/categorias.dart';
import 'package:prevencionriesgoslaborales/src/providers/categorias_provider.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _fondoApp(),

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

  Widget _fondoApp() {

    final gradiente = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0)
          ],
        )
      ),
    );

    final cajaRosa = Transform.rotate(
      angle: -pi / 5.2,
      child: Container(
        height: 350.0,
        width: 350.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(85.0),
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent,
              Colors.blueAccent
            ]
          ),
        ),
      ),
    );
    

    return Stack(
      children: <Widget>[
        gradiente,
        Positioned(
          top: -100,
          child: cajaRosa
        ),
      ],
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
        builder: (BuildContext context , AsyncSnapshot<List<Categoria>> categorias ){
          if (categorias.hasData) {

            List<TableRow> rows = [];

            for (var i = 0; i < categorias.data.length; i = i + 2) {

              if ( i+1 != categorias.data.length ) {

                rows.add(TableRow(
                  children: [
                    _crearBotonRedondeado( context, Colors.blue, AssetImage('assets/riesgos/${categorias.data[i].icon}_V-01.png'), '${categorias.data[i].name}' ),
                    _crearBotonRedondeado( context, Colors.blue, AssetImage('assets/riesgos/${categorias.data[i+1].icon}_V-01.png'), '${categorias.data[i+1].name}' ),
                  ]
                ));

              } else {
                
                rows.add(TableRow(
                  children: [
                    _crearBotonRedondeado( context, Colors.blue, AssetImage('assets/riesgos/${categorias.data[i].icon}_V-01.png'), '${categorias.data[i].name}' ),
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

  Widget _crearBotonRedondeado(BuildContext context, Color color, ImageProvider image, String texto) {

    final card = Container(
      // height: 300.0,
      // width: 150.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          FadeInImage(
            placeholder: AssetImage('assets/img/original.gif'),
            image: image,
            fadeInDuration: Duration( milliseconds: 200 ),
            height: 165.0,
            // width: 160.0,
            fit: BoxFit.cover,
          ),

          // Image(
          //   image: NetworkImage('https://static.photocdn.pt/images/articles/2018/03/20/articles/2017_8/Natural_Night.jpg'),
          // ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(texto, style: TextStyle(fontWeight: FontWeight.w500 ))
            ),
          )
        ],
      )
    );
  
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, 'subcategoria');
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          height: 220.0,
          // width: 200.0,
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