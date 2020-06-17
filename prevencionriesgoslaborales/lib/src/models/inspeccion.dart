// To parse this JSON data, do
//
//     final inspeccionModel = inspeccionModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'deficiencia_model.dart';

InspeccionModel inspeccionModelFromJson(String str) => InspeccionModel.fromJson(json.decode(str));

String inspeccionModelToJson(InspeccionModel data) => json.encode(data.toJson());

class InspeccionModel {
    InspeccionModel({
        this.id,
        this.fechaInicio,
        this.fechaFin,
        this.direccion,
        this.provincia,
        this.pais,
        // this.latitud,
        // this.longitud,
        this.coordenadas,
        this.comentarios,
        this.idInspector,
        // this.inspector,
        this.deficiencias,
    }){
      if ( this.fechaFin == null ) {
            this.fechaFin = DateTime.now().millisecondsSinceEpoch;
            // this.latitud = 1.0;
            // this.longitud = 1.0;
            this.pais = "";
            this.provincia = "";
            this.deficiencias = [];
      }
    }

    int id;
    int fechaInicio;
    int fechaFin;
    String direccion;
    String provincia;
    String pais;
    // double latitud;
    // double longitud;
    Coordenadas coordenadas;
    String comentarios;
    // Inspector inspector;
    int idInspector;
    List<DeficienciaModel> deficiencias;
    // int deficiencias;

    factory InspeccionModel.fromJson(Map<String, dynamic> json) => InspeccionModel(
        id            : json["id"],
        fechaInicio   : json["fechaInicio"],
        fechaFin      : json["fechaFin"],
        direccion     : json["direccion"],
        provincia     : json["provincia"],
        pais          : json["pais"],
        // latitud       : json["latitud"],
        // longitud      : json["longitud"],
        // coordenadas   : Coordenadas.fromJson(json["coordenadas"]),
        comentarios   : json["comentarios"],
        idInspector   : json["inspector"],
        // inspector     : Inspector.fromJson(json["inspector"]),
        // deficiencias  : List<DeficienciaModel>.from(json["deficiencias"].map((x) => DeficienciaModel.fromJson(x))),
        // deficiencias  : json["deficiencias"]
    );

    Map<String, dynamic> toJson() => {
        "id"          : id,
        // "fechaInicio" : "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        // "fechaFin"    : "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "fechaInicio" : fechaInicio,
        "fechaFin"    : fechaFin,
        "direccion"   : direccion,
        "provincia"   : provincia,
        "pais"        : pais,
        // "latitud"     : latitud,
        // "longitud"    : longitud,
        // "coordenadas" : coordenadas.toJson(),
        "comentarios" : comentarios,
        "idInspector" : idInspector,
        // "inspector"   : inspector.toJson(),
        // "deficiencias": List<dynamic>.from(deficiencias.map((x) => x.toJson())),
        // "deficiencias": deficiencias,
    };
}

class Coordenadas {
    Coordenadas({
        this.latitud,
        this.longitud,
    });

    int latitud;
    int longitud;

    factory Coordenadas.fromJson(Map<String, dynamic> json) => Coordenadas(
        latitud   : json["latitud"],
        longitud  : json["longitud"],
    );

    Map<String, dynamic> toJson() => {
        "latitud" : latitud,
        "longitud": longitud,
    };
}





class Foto {
    Foto({
      this.id,
      this.foto,
      this.idEvaluacion
    });

    int id;
    Uint8List foto;
    int idEvaluacion;

    factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        id  : json["id"],
        foto  : json["foto"],
        idEvaluacion  : json["idEvaluacion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "foto": foto,
        "idEvaluacion": idEvaluacion,
    };
}



class Inspector {
    Inspector({
        this.id,
        this.nombre,
    });

    int id;
    String nombre;

    factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
        id      : json["id"],
        nombre  : json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id"    : id,
        "nombre": nombre,
    };
}