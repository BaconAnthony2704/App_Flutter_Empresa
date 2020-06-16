class CategoriaModel{

  String categoria;


  CategoriaModel({
    this.categoria

  });

  factory CategoriaModel.fromJson(Map<String,dynamic>json)=>CategoriaModel(
    
    categoria       : json['categoria'],
   
  );

  Map<String,dynamic>toJson()=>{
    
    'categoria'       : categoria,
    
  };

}