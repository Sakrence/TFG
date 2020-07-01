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
        this.latitud,
        this.longitud,
        this.comentarios,
        this.idInspector,
        this.deficiencias,
    }){
      if ( this.fechaFin == null ) {
            this.fechaFin = DateTime.now().millisecondsSinceEpoch;
            this.latitud = 0.0;
            this.longitud = 0.0;
            this.pais = null;
            this.provincia = null;
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
    String comentarios;
    int idInspector;
    List<DeficienciaModel> deficiencias;

    factory InspeccionModel.fromJson(Map<String, dynamic> json) => InspeccionModel(
        id            : json["id"],
        fechaInicio   : json["fechaInicio"],
        fechaFin      : json["fechaFin"],
        direccion     : json["direccion"],
        provincia     : json["provincia"],
        pais          : json["pais"],
        latitud       : json["latitud"],
        longitud      : json["longitud"],
        comentarios   : json["comentarios"],
        idInspector   : json["inspector"],
    );

    Map<String, dynamic> toJson() => {
        "id"          : id,
        "fechaInicio" : fechaInicio,
        "fechaFin"    : fechaFin,
        "direccion"   : direccion,
        "provincia"   : provincia,
        "pais"        : pais,
        "latitud"     : latitud,
        "longitud"    : longitud,
        "comentarios" : comentarios,
        "idInspector" : idInspector,
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
}

class Provincia {
    Provincia({
      this.id,
      this.nm,
    });

    String id;
    String nm;

    factory Provincia.fromJson(Map<String, dynamic> json) => Provincia(
      id      : json["id"],
      nm  : json["nm"],
    );

    Map<String, dynamic> toJson() => {
      "id"    : id,
      "nm": nm,
    };
}
