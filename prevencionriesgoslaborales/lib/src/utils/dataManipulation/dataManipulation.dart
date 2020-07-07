import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';
import 'package:prevencionriesgoslaborales/src/models/inspeccion.dart';

Map<String, List<DeficienciaModel>> agruparRiesgos( InspeccionModel inspeccion ) {
    
    List<DeficienciaModel> deficiencias = List();

    Map<String, List<DeficienciaModel>> mapa = Map<String, List<DeficienciaModel>>();

    inspeccion.deficiencias.forEach((item) => {
      
      if ( item.evaluacion != null && item.evaluacion.riesgo != "" ) {

        if( mapa.containsKey(item.factorRiesgo.nombre) ) {
          mapa.update(item.factorRiesgo.nombre, (value) {
            value.add(item);
            return value;
          })
        } else {
          deficiencias = [],
          deficiencias.add(item),
          mapa[item.factorRiesgo.nombre] = deficiencias
        }
      }
    });
    return mapa;
  }