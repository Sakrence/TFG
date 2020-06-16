import 'dart:convert';

EvaluacionModel evaluacionModelFromJson(String str) => EvaluacionModel.fromJson(json.decode(str));

String evaluacionModelToJson(EvaluacionModel data) => json.encode(data.toJson());

class EvaluacionModel {
    EvaluacionModel({
        this.consecuenciaRiesgo,
        this.propabilidadRiesgo,
        this.nivelRiesgo,
    });
    
    int consecuenciaRiesgo;
    int propabilidadRiesgo;
    int nivelRiesgo;

    factory EvaluacionModel.fromJson(Map<String, dynamic> json) => EvaluacionModel(
        consecuenciaRiesgo  : json["consecuenciaRiesgo"],
        propabilidadRiesgo  : json["propabilidadRiesgo"],
        nivelRiesgo         : json["nivelRiesgo"],
    );

    Map<String, dynamic> toJson() => {
        "consecuenciaRiesgo": consecuenciaRiesgo,
        "propabilidadRiesgo": propabilidadRiesgo,
        "nivelRiesgo"       : nivelRiesgo,
    };
}