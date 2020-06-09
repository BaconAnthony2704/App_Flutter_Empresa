import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  String email;
  String password;
  String nombre;
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context,usuarioProvider),
        ],
      )
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

  Widget _loginForm(BuildContext context, UsuarioProvider usuarioProvider) {
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
              Text("Registro",style: Theme.of(context).textTheme.headline6,),
              _crearNombre(),
              SizedBox(height: 60.0,),
              _crearEmail(),
               SizedBox(height: 60.0,),
              _crearPassword(context),
               SizedBox(height: 60.0,),
              _crearBoton(context,usuarioProvider),
              SizedBox(height: 30.0,),
              _iniciarSesion(context),
              
            ],
          ),
          )
        ],
      ),
    );
  }

 Widget _crearNombre() {
   return Container(
         padding: EdgeInsets.symmetric(horizontal: 20.0),
         child: TextField(
           keyboardType: TextInputType.text,
           decoration: InputDecoration(
             icon: Icon(FontAwesomeIcons.userAlt),
             hintText: "Nombre de usuario",
             labelText: "Nombre",
             
           ),
           onChanged: (valor){
             nombre=valor;
           }),
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
          controller: _emailController,
          ),
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
       controller: _passwordController,
      ),
    );

   
 }
 Widget _crearBoton(BuildContext context, UsuarioProvider usuarioProvider){
       return RaisedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
          child: Text('Registrarme'),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0.0,
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        onPressed:(){
          _loginBtn(context,usuarioProvider);
        },
  );
 }
 _loginBtn(BuildContext context, UsuarioProvider usuarioProvider)async{
   if(this.email==null && this.password==null && this.nombre==null){
     await Environment().mostrarAlerta(context, "Completa los campos");
   }else{
     bool acceso=false,integridad;
     integridad=await usuarioProvider.verificarIntegridad(email);
     if(integridad){
       acceso=await usuarioProvider.getCrearUsuario(nombre, email, password);
     }else{
       await Environment().mostrarAlerta(context,"Usuario existente");
       _emailController.clear();
       _passwordController.clear();
     }
    
    if(acceso){
      await Environment().mostrarAlerta(context, "Usuario registrados");
    }
   }
   
   
   
 }
 Widget _iniciarSesion(BuildContext context) {
   return GestureDetector(
     onTap: (){
       Navigator.of(context).pushReplacementNamed('login');
     },
     child: Text("Iniciar Sesion",style: TextStyle(color: Theme.of(context).textSelectionColor),
    ),
    );
 }

 
}