import 'dart:async';

class Validators{
  final validaNombreEmpresa=StreamTransformer<String,String>.fromHandlers(
    handleData: (nombre,sink){
      if(nombre.length>=1){
        sink.add(nombre);
      }else{
        sink.addError('Debe tener mas de 2 caracteres');
      }
    }
  );
  final validaEmail=StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp=new RegExp(pattern);
      if(regExp.hasMatch(email)){
        sink.add(email);
      }else{
        sink.addError('Email no valido');
      }
    }
  );
  
  final validaTelefono=StreamTransformer<String,String>.fromHandlers(
    handleData: (telefono,sink){
      if(telefono.length>=8){
        sink.add(telefono);
      }else{
        sink.addError("Telefono no valido");
      }
    }
  );

  final validaNit=StreamTransformer<String,String>.fromHandlers(
    handleData: (nit,sink){
      Pattern pattern=r'^([0-9]{4})+([-]{1})+([0-9]{6})+([-]{1})+([0-9]{3})+([-]{1})+([0-9]{1})+$';
      RegExp regExp=new RegExp(pattern);
      if(regExp.hasMatch(nit)){
        sink.add(nit);
      }else{
        sink.addError('NIT no valido');
      }
    }
  );

  final validaPassword=StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length>=6){
        sink.add(password);
      }else{
        sink.addError("Mas de 6 caracteres");
      }
    }
  );
}