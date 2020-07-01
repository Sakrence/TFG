import 'package:flutter/material.dart';

import 'dart:math';

import 'package:prevencionriesgoslaborales/src/bloc/deficiencia_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/evaluaciones_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';

class ListaEvaluacionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _deficienciaBloc = Provider.deficienciaBloc(context);
    final _evaluacionBloc = Provider.evaluacionesBloc(context);
    final _inspeccionBloc = Provider.inspeccionBloc(context);

    return Stack(
      children: <Widget>[
        _fondoApp(),
        SafeArea(
          child: StreamBuilder(
            stream: _deficienciaBloc.deficienciasStream,
            builder: ( context, AsyncSnapshot<List<DeficienciaModel>> snapshot) {

              if ( !snapshot.hasData ){

                return Text('No hay datos');

              } else {

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: ( context, index)  => Dismissible(
                    key: UniqueKey(),
                    background: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 200.0,
                              spreadRadius: 0.5,
                              offset: Offset(-8.0, 10.0)
                            )
                          ],
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.6),
                              Colors.grey
                            ]
                          ),
                        ),
                      ),
                    ),
                    onDismissed: ( direction ) => { _deficienciaBloc.removeDeficiencia( snapshot.data[index], _inspeccionBloc.inspeccionSeleccionada ) },
                    child: _tarjeta(context, _deficienciaBloc, snapshot.data[index], _evaluacionBloc),
                  ),
                );

              } 
            }
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


  Widget _tarjeta( BuildContext context, DeficienciaBloc bloc, DeficienciaModel deficiencia, EvaluacionesBloc evaluacionBloc) {

    return GestureDetector(
      child: Container(
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
                _icono(deficiencia),
                _texto(deficiencia),
                _botonEvaluar(context, bloc, deficiencia, evaluacionBloc)
            ],
          ),
        ),
      ),
      onTap: (){
        if ( deficiencia.evaluacion == null ) {
          EvaluacionModel evaluacion = EvaluacionModel(idDeficiencia: deficiencia.id);
          evaluacionBloc.addEvaluacion(evaluacion, deficiencia.id);
          evaluacionBloc.getEvaluacion(deficiencia.id);

          deficiencia.evaluacion = evaluacion;
        } 
        Navigator.pushNamed(context, 'formPage', arguments: deficiencia);
      },
    );

  }

  Widget _icono( DeficienciaModel deficiencia ) {

    return Container(
      padding: EdgeInsets.all(10.0),
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: FadeInImage(
          placeholder: AssetImage('assets/img/original.gif'),
          image: AssetImage('assets/riesgos/${deficiencia.factorRiesgo.icono}_V-01.png'),
          fadeInDuration: Duration( milliseconds: 200 ),
          height: 10.0,
          fit: BoxFit.fitWidth,
        ),
      ),
    );

  }

  Widget _texto( DeficienciaModel deficiencia ) {

    return Container(
      width: 160,
      child: Text(
        deficiencia.factorRiesgo.nombre,
        textAlign: TextAlign.left,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
      ),
    );

  }

  Widget _botonEvaluar( BuildContext context, DeficienciaBloc bloc, DeficienciaModel deficiencia, EvaluacionesBloc evaluacionBloc) {

    return Container(
      height: 62,
      width: 62,
      child: FloatingActionButton(
        heroTag: UniqueKey(),
        backgroundColor: Color.fromRGBO(52, 54, 101, 1.0),
        onPressed: (){
          if ( deficiencia.evaluacion == null ) {
            EvaluacionModel evaluacion = EvaluacionModel(idDeficiencia: deficiencia.id);
            evaluacionBloc.addEvaluacion(evaluacion, deficiencia.id);
            evaluacionBloc.getEvaluacion(deficiencia.id);

            deficiencia.evaluacion = evaluacion;
          } 
          Navigator.pushNamed(context, 'formPage', arguments: deficiencia);
        },
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


}