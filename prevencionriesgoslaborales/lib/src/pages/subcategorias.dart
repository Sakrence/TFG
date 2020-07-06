import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:prevencionriesgoslaborales/src/bloc/deficiencia_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/factores_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/inspeccion_bloc.dart';
import 'package:prevencionriesgoslaborales/src/bloc/provider.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';
import 'package:prevencionriesgoslaborales/src/widgets/fondoApp.dart';

class SubcategoriaPage extends StatefulWidget {

  @override
  _SubcategoriaPageState createState() => _SubcategoriaPageState();
}

class _SubcategoriaPageState extends State<SubcategoriaPage> {
  
  double _radius = 25.0;

  @override
  Widget build(BuildContext context) {

    final _factoresBloc = Provider.of(context).factoresBloc;
    final _deficienciasBloc = Provider.deficienciaBloc(context);
    final _inspeccionBloc = Provider.inspeccionBloc(context);
    _deficienciasBloc.obtenerDeficiencias(_inspeccionBloc.inspeccionSeleccionada.id);
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FondoApp(),

          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _titulos(),
                _botonesRedondeados(_deficienciasBloc, _factoresBloc, _inspeccionBloc),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _botonFlotante(_deficienciasBloc, _radius),
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
            Text('Selecciona el subriesgo laboral encontrado', style: TextStyle( color: Colors.black, fontSize: 16.0))
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeados( DeficienciaBloc deficienciasBloc, FactoresBloc factoresBloc, InspeccionBloc inspeccionBloc ) {
    
    return Container(
      child: StreamBuilder(
        stream: factoresBloc.factoresStream,
        builder: (BuildContext context , AsyncSnapshot<List<FactorRiesgoModel>> factores ){
          if (factores.hasData) {

            List<TableRow> rows = [];

            for (var i = 0; i < factores.data.length; i = i + 2) {

              if ( i+1 != factores.data.length ) {

                rows.add(TableRow(
                  children: [
                    _crearBotonRedondeado( context, Colors.blue, factores.data[i], deficienciasBloc, inspeccionBloc ),
                    _crearBotonRedondeado( context, Colors.blue, factores.data[i+1], deficienciasBloc, inspeccionBloc ),
                  ]
                ));

              } else {
                
                rows.add(TableRow(
                  children: [
                    _crearBotonRedondeado( context, Colors.blue, factores.data[i], deficienciasBloc, inspeccionBloc ),
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

  Widget _crearBotonRedondeado(BuildContext context, Color color, FactorRiesgoModel factor, DeficienciaBloc deficienciasBloc, InspeccionBloc inspeccionBloc) {

    final card = Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          FadeInImage(
            placeholder: AssetImage('assets/img/original.gif'),
            image: AssetImage('assets/riesgos/${factor.icono}_V-01.png'),
            fadeInDuration: Duration( milliseconds: 200 ),
            height: 165.0,
            fit: BoxFit.cover,
          ),

          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(factor.nombre, style: TextStyle(fontWeight: FontWeight.w500 ))
            ),
          )
        ],
      )
    );
  
    return GestureDetector(
      onTap: () async {
        deficienciasBloc.addDeficiencia(factor, inspeccionBloc.inspeccionSeleccionada.id);
        animateEventPart1();
        await animateEventPart2();
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

  Widget _botonFlotante( DeficienciaBloc bloc, double _radius ) {

    return Stack(
      children: <Widget>[
        FloatingActionButton.extended(
            icon: Icon(Icons.assignment_late, size: 27.0),
            label: Text('Evaluar riesgos'),
            backgroundColor: Colors.blue,
            
            onPressed: () {
              Navigator.pushNamed(context, 'listaEvaluaciones');
            }
        ),
        Positioned (
          top: -0.5,
          right: 0,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            curve: Curves.fastOutSlowIn,
            width: _radius,
            height: _radius,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.red
            ),
            child: Center(
              child: StreamBuilder<int> (
                    stream: bloc.contadorStream,
                    initialData: 0,
                    builder: (context, snapshot) {
                      return Text (snapshot.data.toString(),
                        style: TextStyle(fontSize:12.0, color: Colors.white));
                    }
              ),
            ),
          ),)

      ],
    );

  }

  void animateEventPart1() {
    setState(() {
      _radius = 1.0;
    });
  }
  Future animateEventPart2() async {
    await Future.delayed(Duration(milliseconds:280));
    setState(() {
      _radius = 25.0;
    });
  }
}