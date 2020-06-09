import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:provider/provider.dart';
class UploadProductExcel extends StatefulWidget {
  @override
  _UploadProductExcelState createState() => _UploadProductExcelState();
}

class _UploadProductExcelState extends State<UploadProductExcel> {
  File file;
  List<ProductoModel> listaProducto;
  ProductoModel productModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaProducto=new List();
  }
  @override
  Widget build(BuildContext context) {
    int empresaProvider=Provider.of<EmpresaProvider>(context).idempresa;
    ProductoProvider productProvider=Provider.of<ProductoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Subir Excel"),
        actions: <Widget>[
          (listaProducto.length>0)
          ?IconButton(icon: Icon(Icons.delete), onPressed: ()async{
            bool estado=await Environment().confirmar(context, "Borrar", "Desea borrar el maestro?");
            if(estado){
              listaProducto.clear();
              setState(() {
              });
              BotToast.showText(text: "Maestro ha sido borrado satisfactoriamente");
            }else{
              BotToast.showText(text: "Cancelado");
            }
          })
          :Container(),
          (listaProducto.length>0)
          ?IconButton(icon: Icon(Icons.check), onPressed: ()async{
            int contar=0;
            bool estado=await Environment().confirmar(context, "Guardar", "Desea migrar estos archivos?");
            if(estado){
              listaProducto.forEach((prod) async{
                contar+=await productProvider.insertarProducto(prod);
               });
               if(contar==0){
                 listaProducto.clear();
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
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ListTile(
                    title: Text("${listaProducto[index].nombre}".toUpperCase()),
                    subtitle: Column(
                      children: <Widget>[
                        conceptos("Precio","\$ ${(listaProducto[index].precio).toStringAsPrecision(2)}"),
                        conceptos("Cantidad","${listaProducto[index].cantidad}"),
                        conceptos("Tipo", "${listaProducto[index].tipo}"),
                        conceptos("Categoria","${listaProducto[index].categoria}"),
                        conceptos("Descripcion", "${listaProducto[index].descripcion}")
                      ],
                    ),
                  ),
                  (listaProducto[index].isoferta==1)
                  ?Positioned(
                    right: 0,
                    child: Icon(Icons.local_offer,color: Colors.red),
                  )
                  :Container()
                ],
              ),
              Divider(),
            ],
          );
        },
        itemCount: listaProducto.length,
      ),
      floatingActionButton: (listaProducto.length==0)
      ?FloatingActionButton(
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
                listaProducto.clear();
                for(int i=1;i<excel.tables[table].rows.length;i++){
                  productModel=new ProductoModel(
                    nombre: excel.tables[table].rows[i][0].toString(),
                    tipo: excel.tables[table].rows[i][1].toString(),
                    categoria: excel.tables[table].rows[i][2].toString(),
                    precio: double.parse(excel.tables[table].rows[i][3].toString()).roundToDouble(),
                    cantidad: double.parse(excel.tables[table].rows[i][4].toString()).roundToDouble(),
                    isoferta: int.parse(excel.tables[table].rows[i][5].toString()).truncate(),
                    descripcion: excel.tables[table].rows[i][6].toString(),
                    activo: int.parse(excel.tables[table].rows[i][7].toString()).truncate(),
                    urlimagen: "",
                    create_at: DateTime.now().toIso8601String(),
                    upload_at: "",
                    idempresa: empresaProvider
                  );
                  listaProducto.add(productModel);
                }
              }
            }
            setState(() {
              
            });
          }
        })
        :Container(),
    );
  }

  Row conceptos(String titulo,String concepto) {
    return Row(
            children: <Widget>[
              Text(titulo),
              Expanded(child: Text(concepto,textAlign: TextAlign.end,))
            ],
          );
  }
}