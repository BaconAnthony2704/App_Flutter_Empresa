//["idusuario","nombre","email","password","idrol","idempresa","activo"];

class UsuarioModel{
  int idusuario;
  String nombre;
  String email;
  String password;
  int idrol;
  int idempresa;
  int activo;
  int docreate;
  int doread;
  int doupdate;
  int dodelete;

  UsuarioModel({
    this.idusuario,
    this.nombre,
    this.email,
    this.password,
    this.idrol,
    this.idempresa,
    this.activo,
    this.docreate,
    this.doread,
    this.doupdate,
    this.dodelete
  });

  factory UsuarioModel.fromJson(Map<String,dynamic> json)=>UsuarioModel(
    idusuario   : json['idusuario'],
    nombre      : json['nombre'],
    email       : json['email'],
    password    : json['password'],
    idrol       : json['idrol'],
    idempresa   : json['idempresa'],
    activo      : json['activo'],
    doread      : json['doread'],
    docreate    : json['docreate'],
    doupdate    : json['doupdate'],
    dodelete    : json['dodelete']           
  );
  Map<String,dynamic> toJson()=>{
    "idusuario"   : idusuario,
    "nombre"      : nombre,
    "email"       : email,
    "password"    : password,
    "idrol"       : idrol,
    "idempresa"   : idempresa,
    "activo"      : activo,
    "doread"      : doread,
    "doupdate"    : doupdate,
    "docreate"    : docreate,
    "dodelete"    : dodelete
  };
}