import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/page/menu/mas_acciones.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Environment{
  Directory _downloadDirectory;
  EdgeInsetsGeometry get metMargen5All => EdgeInsets.all(5.0);
  Color get metColor => Colors.white;

  TableRow generarFila(String texto,String concepto) {
    return TableRow(
                children: [
                  Text(texto),
                  Text("${concepto}",textAlign: TextAlign.end,)
                ],
              );
  }

  Future<void> mostrarAlerta(BuildContext context,String alerta) {
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      content: Text(alerta),
      actions: <Widget>[
        RaisedButton(onPressed: ()=>Navigator.of(context).pop(),child: Text("Aceptar"),)
      ],
    ));
  }
  Future<int> opcionesUsuario(BuildContext context,String texto) async{
    int accion=0;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      elevation: 10.0,
      content: Container(
        height: 180.0,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Editar permisos"),
              onTap: (){
                accion=1;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.info),
              title: Text("Inspeccionar permisos"),
              onTap: (){
                accion=2;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Eliminar usuario"),
              onTap: (){
                accion=3;
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      title: Row(
        children: <Widget>[
          Expanded(child: Text(texto)),
          IconButton(icon: Icon(Icons.clear), onPressed: ()=>Navigator.of(context).pop())
        ],
      ),
    ));
    return accion;
  }
  mostrarEmpresas(BuildContext context,EmpresaProvider empresaProvider,String email,String password)async{
    return showDialog(context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        content: FutureBuilder<List<EmpresaModel>>(
      future: empresaProvider.obtenerEmpresas(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        if(snapshot.data.length==0){
          return Center(child: Text("No hay empresas"),);
        }
        return Column(
          children: <Widget>[
            Center(child: Text("Seleccione una empresa"),),
            Expanded(
              child: ListView.builder(
                itemBuilder:(context,index){
                  return ListTile(
                    leading: Icon(Icons.business),
                    title: Text("${snapshot.data[index].nombre}"),
                    onTap: ()async{
                      print("Empresa seleccionada ${snapshot.data[index].idempresa}");
                      BotToast.showText(text: "Empresa seleccionada");
                      int cambio=await empresaProvider.actualizarUsuario(email, password, snapshot.data[index].idempresa);
                      if(cambio==1){
                        BotToast.showText(text: "Cambio actualizado");
                      }
                    },
                  );
                },
                itemCount: snapshot.data.length,
              ),
            ),
          ],
        );
        },
      ),
      actions: <Widget>[
        RaisedButton(onPressed: ()=>Navigator.of(context).pop(),child: Text("Aceptar"),)
        ],
      );
      },
    );
    

  }

  int parseEntero(bool condicion){
    if(condicion){
      return 1;
    }else{
      return 0;
    }
  }
  bool parseBooleano(int condicion){
    if(condicion==1){
      return true;
    }else{
      return false;
    }
  }
  ThemeData changeTheme() {
    PreferenciasUsuario preferenciasUsuario=new PreferenciasUsuario();
    switch(preferenciasUsuario.tema){
      case 0:
      return ThemeData.dark();
      break;
      case 1:
      return ThemeData(primaryColor: Color(0xFF101C42),textSelectionColor: Color(0xFF101C42));
    }
  }  

  Future<bool> confirmar(BuildContext context,String contenido,String descripcion)async{
    bool estado;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      content: Text(descripcion),
      title: Text(contenido),
      actions: <Widget>[
        RaisedButton(onPressed: (){
          estado=true;
          Navigator.of(context).pop();
        },child: Text("Si"),),
        RaisedButton(onPressed: (){
          estado=false;
          Navigator.of(context).pop();
        },child: Text("No"),),
      ],
    ));
    return estado;
  }
  Future<bool> salirApp(BuildContext context,String contenido,String descripcion)async{
    bool estado;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context)=>AlertDialog(
      content: Text(descripcion),
      title: Text(contenido),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          onPressed: (){
          estado=true;
          //Navigator.of(context).pop();
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },child: Text("Si"),),
        RaisedButton(
          color: Colors.green,
          onPressed: (){
          estado=false;
          Navigator.of(context).pop();
        },child: Text("No"),),
      ],
    ));
    return estado;
  }

  PopupMenuButton mostrarPopupMenu({@required List<CustomPopupMenu> choices}){
  return PopupMenuButton<CustomPopupMenu>(
    elevation: 3.2,
    onSelected: (choice){

    },
    itemBuilder: (context){
      return choices.map((CustomPopupMenu choice){
        return PopupMenuItem(
        value: choice,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(choice.icono),
          title: Text(choice.title),
          onTap:choice.funcion
        ),
      );
      }).toList();
    });
  }

  writeOnPdfProductos({pdf:pw.Document, EmpresaModel empresaModel,ProductoProvider productoProvider})async{
    int i=0;
    double totalP=0.0;
    double iva=0.13;
    List<ProductoModel> listaProducto=await productoProvider.obtenerTodosProductos(empresaModel.idempresa);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context){
          return<pw.Widget>[
            pw.Header(level: 0,
            child: pw.Row(children: [
              pw.Expanded(child: pw.Text(empresaModel.nombre)),
            ])
            ),
            pw.Table(children: [
              tableRow("Giro:",empresaModel.giro),
              tableRow("Identificacion tributaria:",empresaModel.nit),
              tableRow("Email:",empresaModel.email),
              tableRow("Telefono:",empresaModel.telefono),
              tableRow("Departamento:",empresaModel.departamento),
              tableRow("Municipio:",empresaModel.municipio),
              tableRow("Direccion:",empresaModel.direccion),
            ]),
            pw.Header(level: 1,
            child: pw.Text("Productos")),

            pw.Expanded(
              child: pw.Table(
                children:[
                  pw.TableRow(
                    children: [
                      pw.Text("No."),
                      pw.Text("Nombre"),
                      pw.Text("Tipo"),
                      pw.Text("Categoria"),
                      pw.Text("Precio"),
                      pw.Text("Cantidad"),
                      pw.Text("Sub-Total"),
                    ]
                  ),
                  ...listaProducto.map((producto){
                    i++;
                    totalP=producto.cantidad*producto.precio;
                    return pw.TableRow(children: [
                      pw.Text("${i}"),
                      pw.Text(producto.nombre),
                      pw.Text(producto.tipo),
                      pw.Text(producto.categoria!=null?producto.categoria:"Categoria"),
                      pw.Text("\$ "+producto.precio.toString()),
                      pw.Text(producto.cantidad.toString()),
                      pw.Text("\$ "+totalP.toString())

                    ]);
                  }).toList()

                ]
              ),
            )

          ];
        },
        footer: (context){
          return pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(DateTime.now().toIso8601String())
          );
        }
      )
    );

  }

  Future savePdf({pdf:pw.Document,File file})async{
    // Directory directory=await getApplicationDocumentsDirectory();
    // String documentPath=directory.path;
    // File file=File(filePath);
    file.writeAsBytesSync(pdf.save());
  }

  Future<String> downloadExcelProducto({List<ProductoModel> listaProducto})async{
    String hoja="Sheet1";
    Directory ruta=await DownloadsPathProvider.downloadsDirectory;
    //List<ProductoModel> listaProducto=lista;
    var excel=Excel.createExcel();
    String colorTexto="#252850";
    String colorFondo="#BDECB6";

    excel.updateCell(hoja, CellIndex.indexByString("A1"),"nombre",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("B1"), "tipo",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("C1"), "categoria",fontColorHex:colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("D1"), "descripcion",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("E1"), "precio",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("F1"), "cantidad",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    for(int i=0;i<listaProducto.length;i++){
      excel.updateCell(hoja, CellIndex.indexByString("A${i+2}"),listaProducto[i].nombre);
      excel.updateCell(hoja, CellIndex.indexByString("B${i+2}"), listaProducto[i].tipo);
      excel.updateCell(hoja, CellIndex.indexByString("C${i+2}"), listaProducto[i].categoria);
      excel.updateCell(hoja, CellIndex.indexByString("D${i+2}"), listaProducto[i].descripcion);
      excel.updateCell(hoja, CellIndex.indexByString("E${i+2}"), listaProducto[i].precio);
      excel.updateCell(hoja, CellIndex.indexByString("F${i+2}"), listaProducto[i].cantidad);
    }
    excel.encode().then((onValue){
      File(join("${ruta.path}/excel_producto_${DateTime.now().toIso8601String()}.xlsx"))
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue);
    });
    return ruta.path;
    
    

  }



}

pw.TableRow tableRow(String texto,String concepto){
  return pw.TableRow(
    children: [
      pw.Paragraph(text: texto),
      pw.Paragraph(text: concepto),
    ]
  );
}

