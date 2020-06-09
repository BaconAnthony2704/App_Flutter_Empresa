import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:provider/provider.dart';
class EditUsuario extends StatefulWidget {
  @override
  _EditUsuarioState createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  bool lee=false,edita,borra,actualiza,crea;
  bool activo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activo=false;
    edita=false;
    borra=false;
    actualiza=false;
    crea=false;
  }
  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    UsuarioModel usuarioModel=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar permisos"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.check), onPressed: ()async{
            bool estado=await Environment().confirmar(context, "Guardar", "Desea guardar los cambios?");
            if(estado){
              int afectado=await usuarioProvider.actualizarUsuario(usuarioModel);
              if(afectado!=0){
                BotToast.showText(text: "Cambios actualizados, filas afectadas: $afectado");
              }else{
                BotToast.showText(text: "No se genero los cambios");
              }
              Navigator.of(context).pop();
            }

          })
        ],
      ),
      body: Container(
        margin: Environment().metMargen5All,
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            ListTile(
              title: Text("${usuarioModel.nombre.toUpperCase()}"),
              subtitle: Text("${usuarioModel.email.toLowerCase()}"),
              trailing: CircleAvatar(child: Text("${usuarioModel.nombre.toUpperCase()[0]}"),),
            ),
            ListTile(
              title: Text("Activo"),
              trailing: Checkbox(value: activo, onChanged: (value){
                activo=value;
                usuarioModel.activo=Environment().parseEntero(value);
                setState(() {
                  
                });
              }),
            ),
            ListTile(
              title: Text("Puede consultar"),
              trailing: Checkbox(value: lee, onChanged: (value){
                lee=value;
                usuarioModel.doread=Environment().parseEntero(value);
                setState(() {
                  
                });
              }),
            ),
            ListTile(
              title: Text("Puede crear"),
              trailing: Checkbox(value: crea, onChanged: (value){
                crea=value;
                usuarioModel.docreate=Environment().parseEntero(value);
                setState(() {
                  
                });
              }),
            ),
            ListTile(
              title: Text("Puede actualizar"),
              trailing: Checkbox(value: actualiza, onChanged: (value){
                actualiza=value;
                usuarioModel.doupdate=Environment().parseEntero(value);
                setState(() {
                  
                });
              }),
            ),
            ListTile(
              title: Text("Puede eliminar"),
              trailing: Checkbox(value: borra, onChanged: (value){
                borra=value;
                usuarioModel.dodelete=Environment().parseEntero(value);
                setState(() {
                  
                });
              }),
            ),
          ],
        ),
      ),
      
    );
  }
}