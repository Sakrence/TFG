import 'dart:math';

import 'package:flutter/material.dart';

class ListaEvaluacionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _fondoApp(),
        SafeArea(
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            children: <Widget>[
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
              _tarjeta(),
            ] ,
          ),
        ),
      ],
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


  Widget _tarjeta() {

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(-8.0, 10.0)
          )
        ],
      ),
      child: Card(
        elevation: 20.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
              _icono(),
              Container(
                width: 160,
                child: Text(
                  'Caídas de objetos por desplome o derrumbamiento',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
                ),
              ),
              _botonEvaluar()
          ],
        ),
      ),
    );

  }

  Widget _botonEvaluar() {

    return Container(
      height: 62,
      width: 62,
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: Color.fromRGBO(52, 54, 101, 1.0),
        onPressed: (){},
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.assignment_late, color: Colors.blueAccent),
                Text('Evaluar', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.white),),
              ],
            ),
      ),
    );

  }

  Widget _icono() {

    return Container(
      padding: EdgeInsets.all(10.0),
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: FadeInImage(
          placeholder: AssetImage('assets/img/original.gif'),
          image: AssetImage('assets/riesgos/01_V-01.png'),
          fadeInDuration: Duration( milliseconds: 200 ),
          height: 10.0,
          fit: BoxFit.fitWidth,
        ),
      ),
    );

  }
}