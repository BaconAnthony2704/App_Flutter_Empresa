import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/providers/validators.dart';
import 'package:rxdart/rxdart.dart';

class ValidaBloc with Validators, ChangeNotifier{
  final _nombreEmpresaController=BehaviorSubject<String>();
  final _emailController=BehaviorSubject<String>();
  final _telefonoController=BehaviorSubject<String>();
  final _nitController=BehaviorSubject<String>();
  //Recuperar los datos del stream
  Stream<String>get nombreEmpresaStream => _nombreEmpresaController.stream.transform(validaNombreEmpresa);
  Stream<String>get emailStream => _emailController.stream.transform(validaEmail);
  Stream<String>get telefonoStream => _telefonoController.stream.transform(validaTelefono);
  Stream<String>get nitStream => _nitController.stream.transform(validaNit);

  Stream<bool> get formValidStream => CombineLatestStream.combine4(nombreEmpresaStream,
   emailStream,telefonoStream,nitStream, (a, b,c,d) => true);

   //Get y Set - Insertar valores al stream
   Function(String) get changeNombreEmpresa => _nombreEmpresaController.sink.add;
   Function(String) get changeEmail => _emailController.sink.add;
   Function(String) get changeTelefono => _telefonoController.sink.add;
   Function(String) get changeNit => _nitController.sink.add;

   dispose(){
     _nombreEmpresaController?.close();
     _emailController?.close();
     _telefonoController?.close();
     _nitController?.close();
   }
   //Obtener el ultimo valor ingresado
   String get nombreEmpresa => _nombreEmpresaController.value;

   String get email => _emailController.value;

   String get telefono => _telefonoController.value;

   String get nit => _nitController.value;

}