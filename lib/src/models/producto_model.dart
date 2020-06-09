
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
  String tipo;
  String categoria;
  double cantidad;
  String create_at;
  String upload_at;

  ProductoModel({
    this.idproducto,
    this.nombre,
    this.precio,
    this.urlimagen,
    this.isoferta,
    this.idempresa,
    this.descripcion,
    this.activo,
    this.tipo,
    this.categoria,
    this.cantidad,
    this.create_at,
    this.upload_at,
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
    tipo          : json['tipo'],
    categoria     : json['categoria'],
    cantidad      : json['cantidad'],
    upload_at     : json['upload_at'],
    create_at     : json['create_at'],          
  );
  Map<String,dynamic> toJson()=>{
    'idproducto'    :idproducto,
    'nombre'        :nombre,
    'precio'        :precio,
    'urlimagen'     :urlimagen,
    'isoferta'      :isoferta,
    'idempresa'     :idempresa,
    'descripcion'   :descripcion,
    'activo'        :activo,
    'tipo'          :tipo,
    'categoria'     :categoria,
    'cantidad'      :cantidad,
    'upload_at'     :upload_at,
    'create_at'     :create_at
  };
}