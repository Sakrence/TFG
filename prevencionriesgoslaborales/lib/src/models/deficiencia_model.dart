import 'dart:convert';

import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';

DeficienciaModel evaluacionModelFromJson(String str) => DeficienciaModel.fromJson(json.decode(str));

String evaluacionModelToJson(DeficienciaModel data) => json.encode(data.toJson());

class DeficienciaModel {
    DeficienciaModel({
        this.id,
        this.idFactorRiesgo,
        this.factorRiesgo,
        this.evaluacion,
        this.idInspeccion,
    });

    int id;
    int idFactorRiesgo;
    FactorRiesgoModel factorRiesgo;
    EvaluacionModel evaluacion;
    int idInspeccion;

    factory DeficienciaModel.fromJson(Map<String, dynamic> json) => DeficienciaModel(
        id              : json["id"],
        idFactorRiesgo  : json["idFactorRiesgo"],
        idInspeccion    : json["idInspeccion"],
    );

    Map<String, dynamic> toJson() => {
        "id"            : id,
        "idFactorRiesgo": idFactorRiesgo,
        "idInspeccion"  : idInspeccion,
    };
}