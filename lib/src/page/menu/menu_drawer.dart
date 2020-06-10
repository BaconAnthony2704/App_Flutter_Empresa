import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/providers/tema_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';
class MenuLateral extends StatelessWidget {

  MenuLateral({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefs=new PreferenciasUsuario();
    TemaProvider temaProvider=Provider.of<TemaProvider>(context);
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    return FutureBuilder<UsuarioModel>(
      future: usuarioProvider.obtenerUnUsuarioParaMenu(prefs.idusuario),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data==null){
          return Center(child: Text("Cargando...."),);
        }
        return Drawer(

          elevation: 10.0,
          child: Column(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Stack(
                  children: <Widget>[
                    Container(
                    //width: double.infinity,
                    height: MediaQuery.of(context).size.height*.2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).secondaryHeaderColor,
                          Theme.of(context).primaryColor,
                        ]
                      )
                      ),
                    ),
                    Positioned(
                      left: -70,
                      child: Icon(Icons.settings,
                      color: Theme.of(context).textTheme.headline1.color,
                      size: MediaQuery.of(context).size.height*.2,),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        maxRadius: 40,
                        child: Text("${snapshot.data.nombre[0].toUpperCase()}",style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height*.05
                        ),),
                      ),
                    ),
                  ],
                )
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  opcionMenuLateral(icono: Icons.home,titulo: "Inicio",subtitulo: "Principal",
                  funcion: ()=>Navigator.of(context).pushReplacementNamed('/')),
                  (snapshot.data.docreate==1 && snapshot.data.dodelete==1
                  && snapshot.data.doread==1 && snapshot.data.doupdate==1)?
                  opcionMenuLateral(icono: Icons.business,titulo:"Empresa",
                  subtitulo:"Mantenimiento",funcion:()=>Navigator.of(context).pushNamed('miempresa'))
                  :Container(),
                  (snapshot.data.docreate==1 && snapshot.data.dodelete==1
                  && snapshot.data.doread==1 && snapshot.data.doupdate==1)
                  ?opcionMenuLateral(icono: FontAwesomeIcons.userCog,titulo: "Usuarios",
                  subtitulo: "Mantenimiento",funcion: ()=>Navigator.of(context).pushNamed('usuario_home'))
                  :Container(),
                  opcionMenuLateral(icono:FontAwesomeIcons.productHunt,titulo: "Producto",
                  subtitulo: "Mantenimiento",funcion: ()=>Navigator.of(context).pushNamed('inicio_producto')),
                  opcionMenuLateral(icono: FontAwesomeIcons.userCheck,titulo: "Clientes",
                  subtitulo:"Mantenimiento",funcion: ()=>Navigator.of(context).pushNamed('cliente_home') ),
                  ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Switch(value: temaProvider.darkTheme, 
                  onChanged: (value){
                    
                      prefs.tema=Environment().parseEntero(value);
                      temaProvider.darkTheme=value;
                    
                  }),
                  title: Text("Tema"),
                  subtitle: Text("Cambiar tema"),
                  ),
                  opcionMenuLateral(icono: Icons.exit_to_app,titulo: "Salir de sesion",
                  subtitulo: "Salir",funcion: (){
                    prefs.ultimaPagina='login';
                    prefs.idusuario=0;
                    Navigator.of(context).pushReplacementNamed('login');
                  })
                ],
              ),
            )
            ],
          ),
        );
      },
    );
  }
}


  

  

  ListTile opcionMenuLateral({IconData icono, String titulo, String subtitulo, Function funcion}) => 
  ListTile(
    leading: Icon(icono),
    title: Text(titulo),
    subtitle: Text(subtitulo),
    onTap: funcion,
  );
