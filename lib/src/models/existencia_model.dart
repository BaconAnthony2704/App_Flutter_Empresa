
//["idexistencia","idproducto","idempresa","cantidad","activo"];
class ExistenciaModel{
  int      idexistencia;
  int        idproducto;
  int         idempresa;
  double       cantidad;
  int            activo;

  ExistenciaModel({
    this.idexistencia,
    this.idproducto,
    this.idempresa,
    this.cantidad,
    this.activo,
  });

  factory ExistenciaModel.fromJson(Map<String, dynamic>json)=>ExistenciaModel(
    idexistencia    : json['idexistencia'],
    idproducto      : json['idproducto'],
    idempresa       : json['idempresa'],
    cantidad        : json['cantidad'],
    activo          : json['activo'],    
  );

  Map<String,dynamic>toJson()=>{
    "idexistencia"    : idexistencia,
    "idproducto"      : idproducto,
    "idempresa"       : idempresa,
    "cantidad"        : cantidad,
    "activo"          : activo,
  };
}