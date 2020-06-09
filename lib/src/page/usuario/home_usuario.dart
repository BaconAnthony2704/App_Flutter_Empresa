import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:provider/provider.dart';
class UsuarioHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ContenedorPrincipalUsuario(),
    );
  }
}

class ContenedorPrincipalUsuario extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final empresa=Provider.of<EmpresaProvider>(context);
    final usuarios=Provider.of<UsuarioProvider>(context);
    return Container(
      margin: Environment().metMargen5All,
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<List<UsuarioModel>>(
        future: usuarios.obtenerUsuarios(empresa.idempresa),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.data.length==0){
            return Center(child: Text("Sin Usuarios registrados"));
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index){
              return Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${snapshot.data[index].nombre[0].toUpperCase()}"),),
                      title: Text("${snapshot.data[index].nombre.toUpperCase()}"),
                      subtitle: Text("${snapshot.data[index].email.toLowerCase()}"),
                      onTap: ()async{
                        print(snapshot.data[index].idusuario);
                        UsuarioModel usuarioModel=new UsuarioModel(
                          activo: snapshot.data[index].activo,
                          nombre: snapshot.data[index].nombre,
                          docreate: snapshot.data[index].docreate,
                          dodelete: snapshot.data[index].dodelete,
                          doread: snapshot.data[index].doread,
                          doupdate: snapshot.data[index].doupdate,
                          email: snapshot.data[index].email,
                          idempresa: snapshot.data[index].idempresa,
                          idrol: snapshot.data[index].idrol,
                          idusuario: snapshot.data[index].idusuario,
                          password: snapshot.data[index].password
                        );
                        //Navigator.of(context).pushNamed('edit_usuario',arguments: usuarioModel);
                        int accion=await Environment().opcionesUsuario(context, "Opciones");
                        switch(accion){
                          case 1:
                          Navigator.of(context).pushNamed('edit_usuario',arguments: usuarioModel);
                          break;
                          case 2:
                          Navigator.of(context).pushNamed('view_usuario',arguments: usuarioModel);
                          break;
                          case 3:
                          int e=await usuarios.eliminiarUsuario(usuarioModel);
                          if(e==1){
                            BotToast.showText(text: "Usuario eliminado");
                          }else{
                            BotToast.showText(text: "No se pudo eliminar");
                          }
                          break;
                          default:
                          BotToast.showText(text: "Cancelado");
                          break;
                        }
                      },
                    ),
                  ),
                  Icon(FontAwesomeIcons.ellipsisV)
                ],
              );
            },
            itemCount: snapshot.data.length,
          );
          }
        
      ),
    );
  }
}