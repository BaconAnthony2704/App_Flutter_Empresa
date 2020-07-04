
//["idproducto","nombre","precio","urlimagen","isoferta","idempresa","descripcion","activo"];

class TipoProductoModel{
 
  String tipo;
  double arancel;
  String foto;
  int en_uso;
  int preferido;
  double factor1;
  double factor2;
  double factor3;
  double factor4;
  double factor5;
  int principal;  
  String create_at;
  String upload_at;
  int idempresa;

  TipoProductoModel({
    
    this.tipo,
    this.arancel,
    this.foto,
    this.preferido,
    this.en_uso,
    this.factor1,
    this.factor2,
    this.factor3,
    this.factor4,
    this.factor5,
    this.principal,
    this.create_at,
    this.upload_at,
    this.idempresa
  });

  factory TipoProductoModel.fromJson(Map<String,dynamic>json)=>TipoProductoModel(
   
    tipo     : json['tipo'],
    arancel        : json['arancel'],
    foto        : json['foto'],
    preferido     : json['preferido'],
    en_uso      : json['en_uso'],
    factor1   : json['factor1'],
    factor2   : json['factor2'],
    factor3   : json['factor3'],
    factor4   : json['factor4'],
    factor5   : json['factor5'],
    principal   : json['principal'],
    upload_at     : json['upload_at'],
    create_at     : json['create_at'],
    idempresa     : json['idempresa'],          
  );
  Map<String,dynamic> toJson()=>{
    
    'tipo'    :tipo,
    'arancel'        :arancel,
    'en_uso'        :en_uso,
    'foto'     :foto,
    'preferido'     :preferido,
    'factor1'   :factor1,
    'factor2'   :factor2,
    'factor3'   :factor3,
    'factor4'   :factor4,
    'factor5'   :factor5,
    'principal'   :principal,
    'upload_at'     :upload_at,
    'create_at'     :create_at,
    'idempresa'     :idempresa
  };
}