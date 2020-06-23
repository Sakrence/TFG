// To parse this JSON data, do
//
//     final inspeccionModel = inspeccionModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

import 'package:prevencionriesgoslaborales/src/providers/db_provider.dart';

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
        this.latitud,
        this.longitud,
        // this.coordenadas,
        this.comentarios,
        this.idInspector,
        // this.inspector,
        this.deficiencias,
    }){
      if ( this.fechaFin == null ) {
            this.fechaFin = DateTime.now().millisecondsSinceEpoch;
            this.latitud = 0.0;
            this.longitud = 0.0;
            // this.coordenadas = new Coordenadas(latitud: 0.0, longitud: 0.0);
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
    double latitud;
    double longitud;
    // Coordenadas coordenadas;
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
        latitud       : json["latitud"],
        longitud      : json["longitud"],
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
        // "latitud"     : coordenadas.latitud,
        // "longitud"    : coordenadas.longitud,
        "latitud"     : latitud,
        "longitud"    : longitud,
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
      this.id,
      this.latitud,
      this.longitud,
      this.idEvaluacion,
    });

    int id;
    double latitud;
    double longitud;
    int idEvaluacion;


    factory Coordenadas.fromJson(Map<String, dynamic> json) => Coordenadas(
        id             : json["id"],
        latitud        : json["latitud"],
        longitud       : json["longitud"],
        idEvaluacion   : json["idEvaluacion"],
    );

    Map<String, dynamic> toJson() => {
        "id" : id,
        "latitud" : latitud,
        "longitud": longitud,
        "idEvaluacion" : idEvaluacion,
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
      this.usuario,
      this.contrasena,
    });

    int id;
    String usuario;
    String contrasena;

    factory Inspector.fromJson(Map<String, dynamic> json) => Inspector(
      id      : json["id"],
      usuario  : json["usuario"],
      contrasena  : json["contrasena"],
    );

    Map<String, dynamic> toJson() => {
      "id"    : id,
      "usuario": usuario,
      "contrasena": contrasena,
    };

    // Inspector.fromMap(dynamic obj) {
    //   this.usuario = obj['usuario'];
    //   this.contrasena = obj['contrasena'];
    // }

    // Map<String, dynamic> toMap() {
    //   var map = new Map<String, dynamic>();
    //   map["usuario"] = usuario;
    //   map["contrasena"] = contrasena;
    //   return map;
    // }

}
