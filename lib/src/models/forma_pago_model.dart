class FormaPagoModel{

  String forma_pago;


  FormaPagoModel({
    this.forma_pago

  });

  factory FormaPagoModel.fromJson(Map<String,dynamic>json)=>FormaPagoModel(
    
    forma_pago       : json['forma_pago'],
   
  );

  Map<String,dynamic>toJson()=>{
    
    'forma_pago'       : forma_pago,
    
  };

}