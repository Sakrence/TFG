import 'dart:convert';

import 'inspeccion.dart';

EvaluacionModel evaluacionModelFromJson(String str) => EvaluacionModel.fromJson(json.decode(str));

String evaluacionModelToJson(EvaluacionModel data) => json.encode(data.toJson());

class EvaluacionModel {
    EvaluacionModel({
        this.id,
        this.riesgo = '',
        this.tipoFactor = 'Potencial',
        this.nivelDeficiencia = 0,
        this.nivelExposicion = 0 ,
        this.nivelConsecuencias = 0,
        this.fotos,
        this.accionCorrectora = '',
        this.coordenadas,
        this.nivelRiesgo = 0,
        this.idDeficiencia,
    }){
      if ( this.coordenadas == null) {
        this.coordenadas = Coordenadas(latitud: 0.0, longitud: 0.0);
      }
    }

    int id;
    String riesgo;
    String tipoFactor;
    int nivelDeficiencia;
    int nivelExposicion;
    int nivelConsecuencias;
    List<Foto> fotos;
    String accionCorrectora;
    Coordenadas coordenadas;
    int nivelRiesgo;
    int idDeficiencia;

    factory EvaluacionModel.fromJson(Map<String, dynamic> json) => EvaluacionModel(
        id                  : json["id"],
        riesgo              : json["riesgo"],
        tipoFactor          : json["tipoFactor"],
        nivelDeficiencia    : json["nivelDeficiencia"],
        nivelExposicion     : json["nivelExposicion"],
        nivelConsecuencias  : json["nivelConsecuencias"],
        accionCorrectora    : json["accionCorrectora"],
        nivelRiesgo         : json["nivelRiesgo"],
        idDeficiencia       : json["idDeficiencia"],
    );

    Map<String, dynamic> toJson() => {
        "id"                : id,
        "riesgo"            : riesgo,
        "tipoFactor"        : tipoFactor,
        "nivelDeficiencia"  : nivelDeficiencia,
        "nivelExposicion"   : nivelExposicion,
        "nivelConsecuencias": nivelConsecuencias,
        "accionCorrectora"  : accionCorrectora,
        "nivelRiesgo"       : nivelRiesgo,
        "idDeficiencia"     : idDeficiencia,
    };
}