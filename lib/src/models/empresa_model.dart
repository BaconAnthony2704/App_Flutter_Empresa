
//["idempresa","nombre","giro","nit","telefono","email","direccion","isdomicilio","activo"];
import 'dart:convert';
class EmpresaModel{

  int idempresa;
  String nombre;
  String giro;
  String nit;
  String telefono;
  String email;
  String direccion;
  int isdomicilio;
  int activo;
  String departamento;
  String municipio;
  String create_at;
  String upload_at;
  String url_imagen;


  EmpresaModel({
    this.idempresa,
    this.nombre,
    this.giro,
    this.nit,
    this.telefono,
    this.email,
    this.direccion,
    this.isdomicilio,
    this.activo,
    this.departamento,
    this.municipio,
    this.create_at,
    this.upload_at,
    this.url_imagen,

  });

  factory EmpresaModel.fromJson(Map<String,dynamic>json)=>EmpresaModel(
    idempresa   : json['idempresa'],
    nombre      : json['nombre'],
    giro        : json['giro'],
    nit         : json['nit'],
    telefono    : json['telefono'],
    email       : json['email'],
    direccion   : json['direccion'],
    isdomicilio : json['isdomicilio'],
    activo      : json['activo'],
    departamento      : json['departamento'],
    municipio      : json['municipio'],
    create_at      : json['create_at'],
    upload_at      : json['upload_at'], 
    url_imagen: json['url_imagen'],          

  );

  Map<String,dynamic>toJson()=>{
    "idempresa"   : idempresa,
    "nombre"      : nombre,
    "giro"        : giro,
    "nit"         : nit,
    "telefono"    : telefono,
    "email"       : email,
    "direccion"   : direccion,
    "isdomicilio" : isdomicilio,
    "activo"      : activo,
    "departamento":departamento,
    "municipio":municipio,
    "create_at":create_at,
    "upload_at":upload_at,
    "url_imagen":url_imagen,
  };

}