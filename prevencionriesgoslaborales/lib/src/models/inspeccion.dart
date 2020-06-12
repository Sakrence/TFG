import 'dart:convert';

import 'package:prevencionriesgoslaborales/src/models/deficiencia_model.dart';

InspeccionModel inspeccionModelFromJson(String str) => InspeccionModel.fromJson(json.decode(str));

String inspeccionModelToJson(InspeccionModel data) => json.encode(data.toJson());

class InspeccionModel {
    InspeccionModel({
        this.fechaInicio,
        this.fechaFin,
        this.lugar,
        this.comentarios,
        this.inspector,
        this.deficiencias,
    });

    DateTime fechaInicio;
    DateTime fechaFin;
    String lugar;
    String comentarios;
    Inspector inspector;
    List<DeficienciaModel> deficiencias;

    factory InspeccionModel.fromJson(Map<String, dynamic> json) => InspeccionModel(
        fechaInicio   : DateTime.parse(json["fechaInicio"]),
        fechaFin      : DateTime.parse(json["fechaFin"]),
        lugar         : json["lugar"],
        comentarios   : json["comentarios"],
        inspector     : Inspector.fromJson(json["inspector"]),
        deficiencias  : List<DeficienciaModel>.from(json["deficiencias"].map((x) => DeficienciaModel.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "fechaInicio" : "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fechaFin"    : "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "lugar"       : lugar,
        "comentarios" : comentarios,
        "inspector"   : inspector.toJson(),
        "deficiencias": List<dynamic>.from(deficiencias.map((x) => x.toJson())),
    };
}

class Inspector {
    Inspector({
        this.nombre,
        this.dni,
    });

    String nombre;
    String dni;

    factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
        nombre  : json["nombre"],
        dni     : json["dni"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "dni"   : dni,
    };
}
