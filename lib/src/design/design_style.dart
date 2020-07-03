import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
//import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:excel/excel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/pdf_viewer.dart';
import 'package:mantenimiento_empresa/src/models/ExtStorage_model.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/page/menu/mas_acciones.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'dart:math';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
PreferenciasUsuario prefs=PreferenciasUsuario();
class Environment{
  Directory _downloadDirectory;
  EdgeInsetsGeometry get metMargen5All => EdgeInsets.all(5.0);
  Color get metColor => Colors.white;

  Random _random = new Random();

  String generateRandomHexColor(){
      int length = 6;
      String chars = '0123456789ABCDEF';
      String hex = '';
      while(length-- > 0) hex += chars[(_random.nextInt(16)) | 0];
      return hex;
  }
  

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
          prefs.ultimaPagina='login';
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
    List<ProductoModel> listaProducto=new List();
    if(productoProvider.consultaP==null){
      listaProducto=await productoProvider.obtenerTodosProductos(empresaModel.idempresa);
    }else{
      listaProducto=await productoProvider.buscarProducto(empresaModel.idempresa, productoProvider.consultaP);
    }
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

  writeOnPdfCliente({pdf:pw.Document, EmpresaModel empresaModel,ClienteProvider clienteProvider})async{
    int i=0;
    List<ClienteModel> listaCliente;
    if(clienteProvider.consultaP==null){
      listaCliente=await clienteProvider.mostrarClientes(empresaModel.idempresa);
    }else{
      listaCliente=await clienteProvider.buscarCliente(empresaModel.idempresa, clienteProvider.consultaP);
    }
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
            child: pw.Text("Clientes")),

            pw.Expanded(
              child: pw.Table(
                children:[
                  pw.TableRow(
                    children: [
                      pw.Text("No."),
                      pw.Text("Nombre"),
                      pw.Text("Apellido"),
                      pw.Text("Telefono"),
                      
                      pw.Text("Forma de pago"),
                      pw.Text("Limite de credito"),
                    ]
                  ),
                  ...listaCliente.map((cliente){
                    i++;
                    return pw.TableRow(children: [
                      pw.Text("${i}"),
                      pw.Text(cliente.nombre!=null?cliente.nombre:"-"),
                      pw.Text(cliente.apellido!=null?cliente.apellido:"-"),
                      pw.Text(cliente.telefono!=null?cliente.telefono:"-"),
                      
                      pw.Text(cliente.forma_pago!=null?cliente.forma_pago:"-"),
                      pw.Text(cliente.limite_credito.toString())

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

  Future<String> downloadExcelProducto({List<ProductoModel> listaProducto,BuildContext context})async{
    String hoja="Sheet1";
    String ruta=await obtenerFolderRuta(context);
    
    
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
    var estado=await Permission.storage.request();
    if(estado.isGranted){
     if(ruta!=null){
        excel.encode().then((onValue){
        File(join("${ruta}/excel_producto_${DateTime.now().toIso8601String()}.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
        });
        return "Guardado en: "+ruta;
     }
     return "No se pudo exportar el excel";
    }
    return "Solicite permisos de acceso";
    
    

  }

  Future<String> downloadExcelCliente({List<ClienteModel> listaCliente,BuildContext context})async{
    String hoja="Sheet1";
    String ruta=await this.obtenerFolderRuta(context);
  
    var excel=Excel.createExcel();
    String colorTexto="#252850";
    String colorFondo="#BDECB6";

    excel.updateCell(hoja, CellIndex.indexByString("A1"),"nombre",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("B1"), "apellido",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("C1"), "telefono",fontColorHex:colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("D1"), "celular",fontColorHex:colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("E1"), "telefono oficina",fontColorHex:colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("F1"), "email",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("G1"), "forma de pago",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    excel.updateCell(hoja, CellIndex.indexByString("H1"), "limite de credito",fontColorHex: colorTexto,backgroundColorHex: colorFondo);
    for(int i=0;i<listaCliente.length;i++){
      excel.updateCell(hoja, CellIndex.indexByString("A${i+2}"), listaCliente[i].nombre);
      excel.updateCell(hoja, CellIndex.indexByString("B${i+2}"), listaCliente[i].apellido);
      excel.updateCell(hoja, CellIndex.indexByString("C${i+2}"), listaCliente[i].telefono);
      excel.updateCell(hoja, CellIndex.indexByString("D${i+2}"), listaCliente[i].celular);
      excel.updateCell(hoja, CellIndex.indexByString("E${i+2}"), listaCliente[i].telefono_oficina);
      excel.updateCell(hoja, CellIndex.indexByString("F${i+2}"), listaCliente[i].email);
      excel.updateCell(hoja, CellIndex.indexByString("G${i+2}"), listaCliente[i].forma_pago);
      excel.updateCell(hoja, CellIndex.indexByString("H${i+2}"), listaCliente[i].limite_credito);
    }
    var estado=await Permission.storage.request();
    if(estado.isGranted){
      if(ruta!=null){
        excel.encode().then((onValue){
        File(join("${ruta}/excel_cliente_${DateTime.now().toIso8601String()}.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
        });
        return "Guardado en: "+ruta;
      }
      return "No se pudo exportar el archivo excel";
    }
    return "Solicite permisos";
    
    

  }



  List<CustomPopupMenu> choicesProducto({BuildContext context,ProductoProvider productoModel,EmpresaProvider empresaProvider}){
    List<CustomPopupMenu> choices=[
    CustomPopupMenu(title: "Imprimir",icono: Icons.print,funcion: ()async{
      EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
      List<ProductoModel> lista=await productoModel.obtenerTodosProductos(empresaModel.idempresa);
      bool estado=await Environment().confirmar(context, "Imprimir", "Desea imprmir los productos?");
      if(estado){
        Navigator.of(context).pop();
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
    CustomPopupMenu(title: "Importar",icono: FontAwesomeIcons.fileExcel, 
    funcion: ()async{
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('upload_producto');
    }),
    CustomPopupMenu(title:"Exportar", icono: FontAwesomeIcons.cloudDownloadAlt,
    funcion: ()async{
      Navigator.of(context).pop();
      EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
      List<ProductoModel> lista=new List();
      if(productoModel.consultaP==null){
        lista=await productoModel.obtenerTodosProductos(empresaModel.idempresa);
      }else{
        lista=await productoModel.buscarProducto(empresaModel.idempresa,productoModel.consultaP);
      }
      
      if(lista.length>0){
        String texto=await Environment().downloadExcelProducto(listaProducto:lista,context: context );
        BotToast.showNotification(
        leading: (_)=>(!texto.contains("No"))?Icon(Icons.file_download):Icon(Icons.do_not_disturb),
        title: (_)=>Text(texto)
      );
      }else{
        BotToast.showText(text: "No hay productos disponibles");
      }

    })
    ];
    return choices;
  }



  List<CustomPopupMenu> choicesCliente({BuildContext context,ClienteProvider clienteProvider,EmpresaProvider empresaProvider}){
    List<CustomPopupMenu> choices=[
    CustomPopupMenu(title: "Imprimir",icono: Icons.print,funcion: ()async{
      EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
      List<ClienteModel> lista=await clienteProvider.mostrarClientes(empresaModel.idempresa);
      bool estado=await Environment().confirmar(context, "Imprimir", "Desea imprmir los clientes?");
      if(estado){
        Navigator.of(context).pop();
        var status=await Permission.storage.request();
        if(lista.length>0 && status.isGranted){
          pw.Document pdf=pw.Document();
          Directory documentDirectory=await getApplicationDocumentsDirectory();
          String documentPath=documentDirectory.path;
          String fullPath="$documentPath/${DateTime.now().year}_${DateTime.now().month}_"
          "${DateTime.now().day}_${DateTime.now().hour}${DateTime.now().minute}_example.pdf";
          File file=File(fullPath);
          clienteProvider.notifyListeners();
          await Environment().writeOnPdfCliente(pdf: pdf,empresaModel: empresaModel,
          clienteProvider: clienteProvider);
          await Environment().savePdf(pdf: pdf,file: file );
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>PdfPreviweScreen(path: fullPath,),
            settings: RouteSettings(arguments: pdf)
          )
          );
          //await Printing.layoutPdf(onLayout: (PdfPageFormat format)async=>pdf.save());
          pdf=null;
        }else{
          BotToast.showText(text: "No hay clientes disponibles");
        }

      }else{
        BotToast.showText(text: "Cancelado");
      }
      
    }),
    CustomPopupMenu(title: "Importar",icono: FontAwesomeIcons.fileExcel, 
    funcion: ()async{
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('upload_cliente');
    }),
    CustomPopupMenu(title:"Exportar", icono: FontAwesomeIcons.cloudDownloadAlt,
    funcion: ()async{
      Navigator.of(context).pop();
      EmpresaModel empresaModel=await empresaProvider.obtenerEmpresa();
      List<ClienteModel> lista;
      if(clienteProvider.consultaP==null){
        lista=await clienteProvider.mostrarClientes(empresaModel.idempresa);
      }else{
        lista=await clienteProvider.buscarCliente(empresaModel.idempresa, clienteProvider.consultaP);
      }
      
      if(lista.length>0){
        String texto=await Environment().downloadExcelCliente(listaCliente: lista,context: context );
        BotToast.showNotification(
        leading: (_)=>Icon(Icons.file_download),
        title: (_)=>Text(texto)
      );
      }else{
        BotToast.showText(text: "No hay productos disponibles");
      }

    })
    ];
    return choices;
  }

  bool isNumeric(String s){
    if(s.isEmpty){
      return false;
    }
    final n=num.tryParse(s);
    return (n==null)?false:true;
  }

  Future<String>obtenerFolderRuta(BuildContext context)async{
    final alto=MediaQuery.of(context).size.height*.3;
    String ruta;
    await showDialog(context: context,
    barrierDismissible: false,
    builder: (context){
      return AlertDialog(
        content: FutureBuilder<List<RutaExternal>>(
          future: RutaExternal().obtenerListaDirectorio(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Container(
                height: alto,
                child: Center(
                  child: CircularProgressIndicator(),));
            }
            if(snapshot.data.length==0){
              return Container(
                height: alto,
                child: Center(
                  child: Text("No hay carpetas disponibles"),));
            }

            return Container(
              height: MediaQuery.of(context).size.height*.4,
              child: Column(
                children: <Widget>[
                  Text("Seleccione la carpeta donde exportar el excel"),
                  Divider(color: Theme.of(context).textSelectionColor,),
                  Container(
                    height: alto,
                    child: ListView.builder(
                      itemBuilder: (context,index){
                        return ListTile(
                          leading: Icon(FontAwesomeIcons.folder),
                          title: Text(snapshot.data[index].ruta),
                          subtitle: Text(snapshot.data[index].rutaNativa),
                          onTap: (){
                            ruta=snapshot.data[index].rutaNativa;
                            Navigator.pop(context);
                          },
                        );
                    },
                    itemCount: snapshot.data.length,
                    ),
                  ),
                ],
              ),
            );
          }),
      );
    }

    );
    return ruta;
  }

  void launchWhatsApp({@required String phone,@required String message })async{
    String url(){
      if(Platform.isIOS){
        return "whatsapp:://wa.me/$phone/?text=${Uri.parse(message)}";
      }
      else{
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }
    if(await canLaunch(url())){
      await launch(url());
    }else{
      throw "Could not launc ${url()}";
    }
  }

  void launcCorreo({@required String correo,@required String message })async{
    String url(){
      return "mailto:$correo?subject=Promociones&body=$message";
    }
    if(await canLaunch(url())){
      await launch(url());
    }else{
      throw "Could not launch ${url()}";
    }
  }

  void launcPhone({@required String telefono})async{
    String url(){
      return "tel:$telefono";
    }
    if(await canLaunch(url())){
      await launch(url());
    }else{
      throw "Could not launch ${url()}";
    }
  }

  String listaProductoString({@required List<ProductoModel> listado,@required String empresa="Empresa"}){
    String texto="";
    final now=new TimeOfDay.fromDateTime(DateTime.now());
    
    if(now.hour>=6 && now.hour<=12){
      texto+="Buen dia, ";
    }
    else if(now.hour>=13 && now.hour<=18){
      texto+="Buenas Tardes, ";
    }
    else{
      texto+="Buenas noches, ";
    }
    texto+="es un gusto poder saludarlo; ahora en *${empresa}*, estamos con la \n¡¡¡SUPER PROMOCIÒN!!!\n\n";
    listado.forEach((pro) {
      texto+="${pro.nombre} | *\$ ${pro.precio.toStringAsFixed(2)} c/u*\n";
     });
     texto+="\nQuedamos a su disposicion para ayudarle ante cualquier solicitud.";
     return texto;
  }

  String listaProductoStringCorreo({@required List<ProductoModel> listado,@required String empresa="Empresa"}){
    String texto="";
    final now=new TimeOfDay.fromDateTime(DateTime.now());
    
    if(now.hour>=6 && now.hour<=12){
      texto+="Buen dia, ";
    }
    else if(now.hour>=13 && now.hour<=18){
      texto+="Buenas Tardes, ";
    }
    else{
      texto+="Buenas noches, ";
    }
    texto+="es un gusto poder saludarlo; ahora en ${empresa.toUpperCase()}, estamos con la \n¡¡¡SUPER PROMOCIÒN!!!\n\n";
    listado.forEach((pro) {
      texto+="${pro.nombre} | \$ ${pro.precio.toStringAsFixed(2)} c/u\n";
     });
     texto+="\nQuedamos a su disposicion para ayudarle ante cualquier solicitud.";
     return texto;
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



