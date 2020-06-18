import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:provider/provider.dart';
class UploadCliente extends StatefulWidget {
  @override
  _UploadClienteState createState() => _UploadClienteState();
}

class _UploadClienteState extends State<UploadCliente> {
  File file;
  List<ClienteModel> lista;
  ClienteModel clienteModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lista=new List();
  }
  @override
  Widget build(BuildContext context) {
    int empresaProvider=Provider.of<EmpresaProvider>(context).idempresa;
    final clienteProvider=Provider.of<ClienteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Subir Cliente"),
        actions: <Widget>[
           (lista.length>0)
          ?IconButton(icon: Icon(Icons.delete), onPressed: ()async{
            bool estado=await Environment().confirmar(context, "Borrar", "Desea borrar el maestro?");
            if(estado){
              lista.clear();
              setState(() {
              });
              BotToast.showText(text: "Maestro ha sido borrado satisfactoriamente");
            }else{
              BotToast.showText(text: "Cancelado");
            }
          })
          :Container(),
          (lista.length>0)
          ?IconButton(icon: Icon(Icons.check), onPressed: ()async{
            int contar=0;
            bool estado=await Environment().confirmar(context, "Guardar", "Desea migrar estos archivos?");
            if(estado){
              lista.forEach((clie) async{
                contar+=await clienteProvider.ingresarCliente(clie);
                clienteProvider.notifyListeners();
               });
               if(contar==0){
                 lista.clear();
                 BotToast.showText(text: "Archivos agregados a la base de datos");
                 
               }else{
                 BotToast.showText(text: "No se pudo migrar los archivos");
               }
              
            }else{
              BotToast.showText(text: "Cancelado");
            }
          })
          :Container(),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context,index){
          return ListTile(
            leading: Icon(FontAwesomeIcons.userCheck),
            title: Text(lista[index].nombre),
          );
        },
        itemCount: lista.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).textSelectionColor,
        child: Icon(FontAwesomeIcons.fileExport),
        onPressed: ()async{
          file=await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['xlsx']
          );
          //Validar que sea la extension correcta
          if(file.existsSync()){
            if(file.path.contains('.xlsx')){
              String ruta=file.path;
              var bytes=File(ruta).readAsBytesSync();
              var excel=Excel.decodeBytes(bytes,update: true);
              //var excel=Excel.decodeBytes(bytes,update: true);
              //Llenar la lista con el modelo producto
              for(var table in excel.tables.keys){
                lista.clear();
                for(int i=1;i<excel.tables[table].rows.length;i++){
                  clienteModel=new ClienteModel(
                    nombre: excel.tables[table].rows[i][0].toString(),
                    apellido: excel.tables[table].rows[i][1].toString(),
                    email: excel.tables[table].rows[i][2].toString(),
                    telefono: excel.tables[table].rows[i][3].toString(),
                    celular: excel.tables[table].rows[i][4].toString(),
                    telefono_oficina: excel.tables[table].rows[i][5].toString(),
                    limite_credito: double.parse(excel.tables[table].rows[i][6].toString()).roundToDouble(),
                    forma_pago: excel.tables[table].rows[i][7].toString(),
                    activo: int.parse(excel.tables[table].rows[i][8].toString()).truncate(),
                    idempresa: empresaProvider
                  );
                  lista.add(clienteModel);
                }
              }
            }
            setState(() {
              
            });
          }
        }
      ),
    );
  }
}