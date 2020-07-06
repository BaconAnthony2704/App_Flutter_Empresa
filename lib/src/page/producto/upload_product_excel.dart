import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/categoria_model.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/models/tipo_producto_model.dart';
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
  List<TipoProductoModel> listaTipoProducto;
  TipoProductoModel tipoProductoModel;
  List<CategoriaModel> listaCategorias;
  CategoriaModel categoriaModel;
  int contar=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaProducto=new List();
    listaTipoProducto=new List();
    listaCategorias=new List();
  }
  @override
  Widget build(BuildContext context) {
    int empresaProvider=Provider.of<EmpresaProvider>(context).idempresa;
    ProductoProvider productProvider=Provider.of<ProductoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Subir Excel"),
        actions: <Widget>[
          // IconButton(icon: Icon(Icons.cloud_upload), onPressed: ()async{
          //   int valor= await productProvider.ingresarTipoProducto(tipoProductoModel);
          //   BotToast.showText(text: "Ingresado: ${valor}");
          // }),
          (listaProducto.length>0 || listaTipoProducto.length>0 ||listaCategorias.length>0)
          ?IconButton(icon: Icon(Icons.delete), onPressed: ()async{
            bool estado=await Environment().confirmar(context, "Borrar", "Desea borrar el maestro?");
            if(estado){
              listaProducto.clear();
              listaTipoProducto.clear();
              listaCategorias.clear();
              setState(() {
              });
              BotToast.showText(text: "Maestro ha sido borrado satisfactoriamente");
            }else{
              BotToast.showText(text: "Cancelado");
            }
          })
          :Container(),
          (listaProducto.length>0 || listaTipoProducto.length>0 ||listaCategorias.length>0)
          ?IconButton(icon: Icon(Icons.check), onPressed: ()async{
            
            bool estado=await Environment().confirmar(context, "Guardar", "Desea migrar estos archivos?");
            if(estado && listaProducto.length>0){
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
            if(estado && listaTipoProducto.length>0){
              listaTipoProducto.forEach((tipo){
                  productProvider.ingresarTipoProducto(tipo).then((value) {
                    contar+=value;
                    if(contar>0){
                      
                      BotToast.showText(text: "Archivos agregados a la base de datos");
                      
                    }else{
                      BotToast.showText(text: "No se pudo migrar los archivos, verifique integridad");
                    }
                  });
                 
               });          
            }
            if(estado && listaCategorias.length>0){
              listaCategorias.forEach((categoria) {
                productProvider.ingresarCategoriaProducto(categoria).then((value){
                  contar+=value;
                  if(contar>0){
                    BotToast.showText(text: "Archivos agregados a la base de datos");
                    
                  }else{
                      BotToast.showText(text: "No se pudo migrar los archivos, verifique integridad");
                    }
                });
               });
            }
          })
          :Container(),
        ],
      ),
      body:(listaProducto.length>0)
      ? ListView.builder(
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
      )
      :(listaTipoProducto.length>0)
      ?ListView.builder(
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ListTile(
                    title: Text("${listaTipoProducto[index].tipo}".toUpperCase()),
                    subtitle: Column(
                      children: <Widget>[
                        conceptos("Arancel","\$ ${(listaTipoProducto[index].arancel).toStringAsPrecision(2)}"),
                        conceptos("Factor precio 1","${listaTipoProducto[index].factor1}"),
                        conceptos("Factor precio 2", "${listaTipoProducto[index].factor2}"),
                        conceptos("Factor precio 3","${listaTipoProducto[index].factor3}"),
                        conceptos("Factor precio 4", "${listaTipoProducto[index].factor4}"),
                        conceptos("Factor precio 5", "${listaTipoProducto[index].factor5}")
                      ],
                    ),
                  ),
                  (listaTipoProducto[index].en_uso==1)
                  ?Positioned(
                    right: 0,
                    child: Icon(Icons.verified_user,color: Colors.green),
                  )
                  :Container()
                ],
              ),
              Divider(),
            ],
          );
        },
        itemCount: listaTipoProducto.length,
      )
      :(listaCategorias.length>0)
      ?ListView.builder(
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ListTile(
                    title: Text("${listaCategorias[index].categoria}".toUpperCase()),
                    leading: CircleAvatar(child: Text("${listaCategorias[index].categoria.substring(0,1)}"),),
                  ),
                  (listaCategorias[index].en_uso==1)
                  ?Positioned(
                    right: 0,
                    child: Icon(Icons.store,color: Colors.green),
                  )
                  :Container()
                ],
              ),
              Divider(),
            ],
          );
        },
        itemCount: listaCategorias.length,
      )
      :Center(child: Text("Esperando datos de subida"),),
      floatingActionButton: (listaProducto.length==0)
      ?FloatingActionButton(
        backgroundColor: Theme.of(context).textSelectionColor,
        child: Icon(FontAwesomeIcons.fileExport),
        onPressed: ()async{
          try{
            file=await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['xlsx']
            );
            //Validar que sea la extension correcta
            if(file.existsSync()){
              if(file.path.contains('Producto')){
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
              if(file.path.contains('Tipo')){
                String ruta=file.path;
                var bytes=File(ruta).readAsBytesSync();
                var excel=Excel.decodeBytes(bytes,update: true);
                //var excel=Excel.decodeBytes(bytes,update: true);
                //Llenar la lista con el modelo producto
                for(var table in excel.tables.keys){
                  listaTipoProducto.clear();
                  for(int i=1;i<excel.tables[table].rows.length;i++){
                    tipoProductoModel=new TipoProductoModel(
                      tipo: excel.tables[table].rows[i][0].toString(),
                      arancel: double.parse(excel.tables[table].rows[i][1].toString()),
                      en_uso: int.parse(excel.tables[table].rows[i][2].toString()),
                      preferido: int.parse(excel.tables[table].rows[i][3].toString()),
                      factor1: double.parse(excel.tables[table].rows[i][4].toString()),
                      factor2: double.parse(excel.tables[table].rows[i][5].toString()),
                      factor3: double.parse(excel.tables[table].rows[i][6].toString()),
                      factor4: double.parse(excel.tables[table].rows[i][7].toString()),
                      factor5: double.parse(excel.tables[table].rows[i][8].toString()),
                      principal: int.parse(excel.tables[table].rows[i][9].toString()),
                      create_at: DateTime.now().toIso8601String(),
                      upload_at: "",
                      foto: "",
                      idempresa: empresaProvider
                    );
                    listaTipoProducto.add(tipoProductoModel);
                  }
                }
              }
              if(file.path.contains('Categoria')){
                String ruta=file.path;
                var bytes=File(ruta).readAsBytesSync();
                var excel=Excel.decodeBytes(bytes,update: true);
                //var excel=Excel.decodeBytes(bytes,update: true);
                //Llenar la lista con el modelo producto
                for(var table in excel.tables.keys){
                  listaCategorias.clear();
                  for(int i=1;i<excel.tables[table].rows.length;i++){
                    categoriaModel=new CategoriaModel(
                      categoria: excel.tables[table].rows[i][0].toString(),
                      en_uso: int.parse(excel.tables[table].rows[i][1].toString()),
                      preferido: int.parse(excel.tables[table].rows[i][1].toString()),
                      idEmpresa: empresaProvider
                    );
                    listaCategorias.add(categoriaModel);
                  }
                }
              }
              setState(() {
                
              });
            }
          }catch(Exception){
            BotToast.showText(text: "No se pudo obtener el maestro excel");
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