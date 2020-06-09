import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/service/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validator,ChangeNotifier{
  final _passwordController=BehaviorSubject<String>();
  final _emailController=BehaviorSubject<String>();
  //Recuperar los datos del stream
  Stream<String>get passwordStream => _passwordController.stream.transform(validaPassword);
  Stream<String>get emailStream => _emailController.stream.transform(validarEmail);

  Stream<bool> get formValidState =>CombineLatestStream
              .combine2(passwordStream, emailStream, (a, b) => true);
  
  //Get y Set - Insertar valores al stream
   Function(String) get changePassword => _passwordController.sink.add;
   Function(String) get changeEmail => _emailController.sink.add;

   dispose(){
     _passwordController?.close();
     _emailController?.close();
   }

   //Obtener el ultimo valor ingresado
   String get password => _passwordController.value;

   String get email => _emailController.value;

}