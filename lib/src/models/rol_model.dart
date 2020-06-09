//["idrol","accion","activo"];

class RolModel{
  int idrol;
  String accion;
  int activo;

  RolModel({
    this.idrol,
    this.accion,
    this.activo
  });
  factory RolModel.fromJson(Map<String,dynamic> json)=>RolModel(
    idrol   : json['idrol'],
    accion  : json['accion'],
    activo  : json['activo']   
  );
  Map<String,dynamic>toJson()=>{
    "idrol"   : idrol,
    "accion"  : accion,
    "activo"  : activo,
  };

}