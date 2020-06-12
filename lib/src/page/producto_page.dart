import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/design/pdf_viewer.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:mantenimiento_empresa/src/page/menu/mas_acciones.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
import 'package:mantenimiento_empresa/src/page/producto/contenedor_principal.dart';
import 'package:mantenimiento_empresa/src/page/producto/contenedor_principal_promocion.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/product_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  PreferenciasUsuario prefs;
  int pos;
  
  
  CustomPopupMenu _selectedChoices;
  @override
  void initState() {
    // TODO: implement initState
    pos=0;
    prefs=PreferenciasUsuario();
    //_selectedChoices=choices[0];
    super.initState();
  }
  
  @override
  Widget build(BuildContext context){
    ProductoProvider productoModel=Provider.of<ProductoProvider>(context);
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    List<CustomPopupMenu> choices=[
    CustomPopupMenu(title: "Imprimir",icono: Icons.print,funcion: ()async{
      EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
      List<ProductoModel> lista=await productoModel.obtenerTodosProductos(empresaModel.idempresa);
      bool estado=await Environment().confirmar(context, "Imprimir", "Desea imprmir los productos?");
      if(estado){
        Navigator.of(context).pop();
        print("Imprimir");
        
        var status=await Permission.storage.request();
        if(lista.length>0 && status.isGranted){
          pw.Document pdf=pw.Document();
          Directory documentDirectory=await getApplicationDocumentsDirectory();
          String documentPath=documentDirectory.path;
          String fullPath="$documentPath/${DateTime.now().year}_${DateTime.now().month}_"
          "${DateTime.now().day}_${DateTime.now().hour}${DateTime.now().minute}_example.pdf";
          File file=File(fullPath);
          productoModel.notifyListeners();
          await Environment().writeOnPdfProductos(pdf: pdf,empresaModel: empresaModel,productoProvider: productoModel);
          await Environment().savePdf(pdf: pdf,file: file );
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>PdfPreviweScreen(path: fullPath,),
            settings: RouteSettings(arguments: pdf)
          )
          );
          //await Printing.layoutPdf(onLayout: (PdfPageFormat format)async=>pdf.save());
          pdf=null;
        }else{
          BotToast.showText(text: "No hay productos disponibles");
        }

      }else{
        BotToast.showText(text: "Cancelado");
      }
      
    }),
    CustomPopupMenu(title: "Exportar",icono: FontAwesomeIcons.fileExcel, funcion: ()async{
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('upload_producto');
    }),
    CustomPopupMenu(title:"Importar", icono: FontAwesomeIcons.cloudDownloadAlt,funcion: ()async{
      Navigator.of(context).pop();
      EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
      List<ProductoModel> lista=await productoModel.obtenerTodosProductos(empresaModel.idempresa);
      
      if(lista.length>0){
        String texto=await Environment().downloadExcelProducto(listaProducto:lista );
        BotToast.showNotification(
        leading: (_)=>Icon(Icons.file_download),
        title: (_)=>Text("Guardado en: "+texto)
      );
      }else{
        BotToast.showText(text: "No hay productos disponibles");
      }

    })
  ];
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){}),
          IconButton(icon: Icon(Icons.filter_list), onPressed: (){}),
          Environment().mostrarPopupMenu(choices: choices)
        ],
      ),
      body: _callPage(pos),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Theme.of(context).textSelectionColor,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed('edit_producto');
        }
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.local_offer),title: Text("Productos")),
        BottomNavigationBarItem(icon: Icon(Icons.insert_chart),title: Text("Existencias")),
      ],
      onTap: (posicion){
        setState(() {
          pos=posicion;
        });
      },
      currentIndex: pos,
      ),
    );
  }

  Widget _callPage(int pos) {
    switch(pos){
      case 0:
        return ContenedorPrincipal();
        break;
      case 1:
        return ContenedorPrincipalPromocional();
        break;
    }
  }
}

