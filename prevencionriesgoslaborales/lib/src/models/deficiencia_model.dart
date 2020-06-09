import 'dart:convert';

import 'package:prevencionriesgoslaborales/src/models/evaluacion_model.dart';
import 'package:prevencionriesgoslaborales/src/models/factor_riesgo_model.dart';

DeficienciaModel evaluacionModelFromJson(String str) => DeficienciaModel.fromJson(json.decode(str));

String evaluacionModelToJson(DeficienciaModel data) => json.encode(data.toJson());

class DeficienciaModel {
    DeficienciaModel({
        this.id,
        this.factor,
        this.evaluacion,
        this.descripcion,
        this.riesgo,
        this.tipo,
        this.imagen,
    });

    int id;
    FactorRiesgoModel factor;
    EvaluacionModel evaluacion;
    String descripcion;
    String riesgo;
    String tipo;
    String imagen;

    factory DeficienciaModel.fromJson(Map<String, dynamic> json) => DeficienciaModel(
        id                  : json["id"],
        factor              : json["factor"],
        evaluacion          : json["evaluacion"],
        descripcion         : json["descripcion"],
        riesgo              : json["riesgo"],
        tipo                : json["tipo"],
        imagen              : json["imagen"],
    );

    Map<String, dynamic> toJson() => {
        "factor"            : factor,
        "evaluacion"        : evaluacion,
        "descripcion"       : descripcion,
        "riesgo"            : riesgo,
        "tipo"              : tipo,
        "imagen"            : imagen,
    };
}