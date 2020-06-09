
//["idproducto","nombre","precio","urlimagen","isoferta","idempresa","descripcion","activo"];

class ProductoModel{

  int idproducto;
  String nombre;
  double precio;
  String urlimagen;
  int isoferta;
  int idempresa;
  String descripcion;
  int activo;

  ProductoModel({
    this.idproducto,
    this.nombre,
    this.precio,
    this.urlimagen,
    this.isoferta,
    this.idempresa,
    this.descripcion,
    this.activo
  });

  factory ProductoModel.fromJson(Map<String,dynamic>json)=>ProductoModel(
    idempresa     : json['idempresa'],
    nombre        : json['nombre'],
    precio        : json['precio'],
    urlimagen     : json['urlimagen'],
    isoferta      : json['isoferta'],
    descripcion   : json['descripcion'],
    activo        : json['activo'],
    idproducto    : json['idproducto'],          
  );
  Map<String,dynamic> toJson()=>{
    'idproducto'    :idproducto,
    'nombre'        :nombre,
    'precio'        :precio,
    'urlimagen'     :urlimagen,
    'isoferta'      :isoferta,
    'idempresa'     :idempresa,
    'descripcion'   :descripcion,
    'activo'        :activo
  };
}