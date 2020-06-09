import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  String email;
  String password;
  final emailController=new TextEditingController();
  final passwordController=new TextEditingController();
  final _prefs=new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    
    return WillPopScope(
      onWillPop:()async=> await Environment().salirApp(context, "Salir", "Deseas salir de la aplicacion?"),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _crearFondo(context),
            _loginForm(context,empresaProvider,usuarioProvider),
          ],
        )
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final fondoPrimario=Container(
      height: size.height*.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Theme.of(context).indicatorColor,
          Theme.of(context).primaryColor,
          
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight
      )
      ),
    );
    final circulo=Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Theme.of(context).primaryColor.withOpacity(0.5),
      ),
    );

    return Stack(
      children: <Widget>[
        fondoPrimario,
        Positioned(child: circulo,top: 90,left: 30,),
        Positioned(child: circulo,top: -40,left: -30,),
        Positioned(child: circulo,bottom: -50,right: -10,),
        Positioned(child: circulo,bottom: 120,right: 20,),
        Positioned(child: circulo,bottom: -50,left: -20,),
      ],
    );
  }

  Widget _loginForm(BuildContext context, EmpresaProvider empresaProvider,UsuarioProvider usuarioProvider) {
    final size=MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child:Container(height: 180.0,), 
          ),
          Container(width: size.width*.85,
          padding: EdgeInsets.symmetric(vertical: 50.0),
          margin: EdgeInsets.symmetric(vertical: 30.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: <BoxShadow>[
              BoxShadow(color: Theme.of(context).textSelectionColor,
              blurRadius: 3.0,
              offset: Offset(0.0, 5.0),
              spreadRadius: 3.0),
            ]
          ),
          child: Column(
            children: <Widget>[
              Text("Ingreso",style: Theme.of(context).textTheme.headline6,),
              SizedBox(height: 60.0,),
              _crearEmail(),
               SizedBox(height: 60.0,),
              _crearPassword(context),
               SizedBox(height: 60.0,),
              _crearBoton(context,empresaProvider,usuarioProvider),
              SizedBox(height: 30.0,),
              _registrarse(context),
              
            ],
          ),
          )
        ],
      ),
    );
  }

 Widget _crearEmail() {
   return Container(
         padding: EdgeInsets.symmetric(horizontal: 20.0),
         child: TextField(
           keyboardType: TextInputType.emailAddress,
           decoration: InputDecoration(
             icon: Icon(Icons.alternate_email),
             hintText: "Ejemplo@correo.com",
             labelText: "Correo electronico",
             
           ),
           onChanged: (valor){
             email=valor;
           },
           controller: emailController,),
   );
 }
 Widget _crearPassword(BuildContext context) {
   
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 20.0),
     child: TextField(
       obscureText: true,
       decoration: InputDecoration(
         icon: Icon(Icons.lock_outline),
         labelText: 'Contraseña',
       ),
       onChanged: (valor){
         password=valor;
       },
       controller: passwordController,),
    );

   
 }
 Widget _crearBoton(BuildContext context, EmpresaProvider empresaProvider,UsuarioProvider usuarioProvider){
       return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('Ingresar'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:(){
          _loginBtn(context,empresaProvider,usuarioProvider);
        },
  );
 }
 _loginBtn(BuildContext context, EmpresaProvider empresaProvider,UsuarioProvider usuarioProvider)async{
   
   if(this.email==null && this.password==null){
     await Environment().mostrarAlerta(context, "Completa los campos");
   }else{
     bool acceso=false,integridad;
     integridad=await usuarioProvider.verificarIntegridad(email);
     
    acceso=await empresaProvider.obtenerUsuarioRegistrado(email, password);
    if(acceso){
      _prefs.ultimaPagina='/';
      Navigator.of(context).pushReplacementNamed('/');
      
    }else{
      //await Environment().mostrarAlerta(context,"No tienes permisos");
      emailController.clear();
      passwordController.clear();
      if(!integridad && usuarioProvider.idempresa==0){
       //await Environment().mostrarAlerta(context, "Solicite permiso de acceso");
       await Environment().mostrarEmpresas(context,empresaProvider,email,password);
     }else{
       await Environment().mostrarAlerta(context, "Solicite permiso de acceso");
     }
    }
    
   }
   
   
   
 }
 Widget _registrarse(BuildContext context) {
   return GestureDetector(
     onTap: (){
       Navigator.of(context).pushReplacementNamed('registro');
     },
     child: Text("Registrarse",style: TextStyle(color: Theme.of(context).textSelectionColor),
    ),
    );
 }

 
}