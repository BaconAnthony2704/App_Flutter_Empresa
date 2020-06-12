//nombre	apellido	email	telefono	limitecredito	formapago	activo
import 'package:flutter/material.dart';
class ClienteModel{
  int idcliente;
  String nombre;
  String apellido;
  String email;
  String telefono;
  double limite_credito;
  String forma_pago;
  int activo;
  int idempresa;
  String celular;
  String telefono_oficina;

  ClienteModel({
    this.idcliente,
    this.nombre,
    this.apellido,
    this.email,
    this.telefono,
    this.limite_credito,
    this.forma_pago,
    this.activo,
    this.idempresa,
    this.celular,
    this.telefono_oficina

  });

  factory ClienteModel.fromJson(Map<String,dynamic>json)=>ClienteModel(
    idcliente     : json['idcliente'],
    nombre        : json['nombre'],
    apellido      : json['apellido'],
    email         : json['email'],
    telefono      : json['telefono'],
    forma_pago    : json['forma_pago'],
    limite_credito: json['limite_credito'],
    activo        : json['activo'],
    idempresa     : json['idempresa'],
    celular       : json['celular'],
    telefono_oficina: json['telefono_oficina'] 
  );

  Map<String,dynamic>toJson()=>{
    'idcliente'     :idcliente,
    'nombre'        : nombre,
    'apellido'      : apellido,
    'email'         : email,
    'telefono'      :telefono,
    'forma_pago'    : forma_pago,
    'limite_credito': limite_credito,
    'activo'        : activo,
    'idempresa'     : idempresa,
    'celular'       : celular,
    'telefono_oficina':telefono_oficina
  };

}