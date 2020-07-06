class CategoriaModel{

  String categoria;
  int en_uso;
  int preferido;
  int idEmpresa;

  CategoriaModel({
    this.categoria,
    this.en_uso,
    this.preferido,
    this.idEmpresa

  });

  factory CategoriaModel.fromJson(Map<String,dynamic>json)=>CategoriaModel(
    
    categoria       : json['categoria'],
    en_uso        : json['en_uso'],
    preferido       : json['preferido'],
    idEmpresa: json['idEmpresa']

   
  );

  Map<String,dynamic>toJson()=>{
    
    'categoria'       : categoria,
    'en_uso':en_uso,
    'preferido':preferido,
    'idEmpresa':idEmpresa
    
  };

}