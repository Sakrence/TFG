import 'dart:convert';

import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';

DeficienciaModel evaluacionModelFromJson(String str) => DeficienciaModel.fromJson(json.decode(str));

String evaluacionModelToJson(DeficienciaModel data) => json.encode(data.toJson());

class DeficienciaModel {
    DeficienciaModel({
        this.id,
        this.factorRiesgo,
        this.evaluacion,
        this.idInspeccion,
    });

    int id;
    FactorRiesgoModel factorRiesgo;
    EvaluacionModel evaluacion;
    int idInspeccion;

    factory DeficienciaModel.fromJson(Map<String, dynamic> json) => DeficienciaModel(
        id            : json["id"],
        factorRiesgo  : FactorRiesgoModel.fromJson(json["factorRiesgo"]),
        evaluacion    : EvaluacionModel.fromJson(json["evaluacion"]),
        idInspeccion  : json["idInspeccion"],
    );

    Map<String, dynamic> toJson() => {
        "id"          : id,
        "factorRiesgo": factorRiesgo.toJson(),
        "evaluacion"  : evaluacion.toJson(),
        "idInspeccion": idInspeccion,
    };
}