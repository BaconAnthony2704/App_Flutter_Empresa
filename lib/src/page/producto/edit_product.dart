import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/models/tipo_producto_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:provider/provider.dart';
class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with AutomaticKeepAliveClientMixin{
  String nombre="",detalle="",descripcion="",tipo;
  EmpresaProvider empresaProvider;
  double precio=0.0, existencia=0.0;
  List<String> listaTipo=["Computadora","Rayado","Azul"];
  List<String>listaCategoria=["Escolar","Tecnologia","Materia prima","Utensilios"];
  bool favorito=false,oferta=false;
  File foto;
  String tituloInterfaz;
  double cantidad;
  ProductoProvider productoProvider;
  TextEditingController txtNombre=new TextEditingController();
  TextEditingController txtDescripcion=new TextEditingController();
  TextEditingController txtPrecio=new TextEditingController();
  TextEditingController txtTipo=new TextEditingController();
  TextEditingController txtCategoria=new TextEditingController();
  TextEditingController txtCantidad=new TextEditingController();
  int idempresa;
  @override
  Widget build(BuildContext context) {
    productoProvider=
    Provider.of<ProductoProvider>(context);
  
    idempresa=Provider.of<EmpresaProvider>(context).idempresa;
    ProductoModel productoEdit=ModalRoute.of(context).settings.arguments;
    
    if(productoEdit==null){
      
      tituloInterfaz="Crear producto";
    }else{
      tituloInterfaz="Actualizar producto";
      txtNombre.value=new TextEditingController.fromValue(new TextEditingValue(text: productoEdit.nombre)).value;
      txtNombre.selection=TextSelection.fromPosition(TextPosition(offset: txtNombre.text.length));

      txtDescripcion.value=new TextEditingController.fromValue(new TextEditingValue(text: productoEdit.descripcion)).value;
      txtDescripcion.selection=TextSelection.fromPosition(TextPosition(offset: txtDescripcion.text.length));

      txtPrecio.value=new TextEditingController.fromValue(new TextEditingValue(text: productoEdit.precio.toString())).value;
      txtPrecio.selection=TextSelection.fromPosition(TextPosition(offset: txtPrecio.text.length));

      txtCantidad.value=new TextEditingController.fromValue(new TextEditingValue(text: productoEdit.cantidad.toString())).value;
      txtCantidad.selection=TextSelection.fromPosition(TextPosition(offset: txtCantidad.text.length));

      txtTipo.value=new TextEditingController.fromValue(new TextEditingValue(text: productoEdit.tipo.toString())).value;
      txtTipo.selection=TextSelection.fromPosition(TextPosition(offset: txtTipo.text.length));
       
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(tituloInterfaz),
        actions: <Widget>[
          IconButton(icon: Icon(FontAwesomeIcons.camera), onPressed: ()async{
            await _tomarFoto();
          }),
          IconButton(icon: Icon(Icons.perm_media), onPressed: ()async{
            await _seleccionarFoto();
          })
        ],
      ),
      body: Container(
        margin: Environment().metMargen5All,
        child: ListView(
          children: <Widget>[
            _obtenerImagen(productoEdit: productoEdit),
            Divider(),
            _crearNombre(),
            Divider(),
            _crearDetalle(),
            Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(child: _crearNuevoTipoProducto()),
                Expanded(
                  flex: 3,
                  child: _crearTipo(),
                ),
                
                Expanded(
                  flex: 3,
                  child: _crearCategoria()
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                _crearPrecio(),
               _crearCantidad()
              ],
            ),
            Divider(),
            _crearBoton(context,productoProvider,idempresa,productoEdit)
          ],
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: "Nombre del producto",
        labelText: "Nombre",
        suffixIcon: Icon(Icons.store_mall_directory)
      ),
      autofocus: false,
      onChanged: (valor){
        nombre=txtNombre.text;
        nombre=valor;
        print(nombre);
      },
      controller: txtNombre,
    );
  }

  Widget _crearDetalle() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: "Detalle del producto",
        labelText: "Detalle",
        suffixIcon: Icon(FontAwesomeIcons.info)
      ),
      maxLength: 100,
      maxLines: 2,
      onChanged: (valor){
        descripcion=txtDescripcion.text;
        descripcion=valor;
      },
      controller: txtDescripcion,
    );
  }

  Widget _crearPrecio() {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          hintText: "Precio",
          labelText: "Precio",
          suffixIcon: Icon(Icons.monetization_on)
        ),
        maxLength: 7,
        autofocus: false,
        onChanged: (valor){
          precio=double.parse(txtPrecio.text);
          precio=double.parse(valor);
        },
        controller: txtPrecio,
      ),
    );
  }

  Widget _crearCantidad() {
    return Expanded(
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0)
          ),
          hintText: "Cantidad",
          labelText: "Cantidad",
          suffix: Text("Unidad(es)")
        ),
        maxLength: 7,
        autofocus: false,
        onChanged: (valor){
          existencia=double.parse(txtCantidad.text);
          existencia=double.parse(valor);
        },
        controller: txtCantidad,
      ),
    );
  }

  Widget _crearOferta(){
    return Flexible(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.local_offer),
        title: Switch(value: oferta, onChanged: (valor){
          oferta=valor;
          setState(() {
            
          });
        }),
        subtitle: Text("Oferta"),
      ),
    );
  }

  Widget _crearBoton(BuildContext context, ProductoProvider productoProvider,
  int idempresa, ProductoModel productoEdit) {
    String btnString;
    if(productoEdit==null){
      btnString="Ingresar";
    }else{
      btnString="Actualizar";
      if(nombre.isEmpty){
        nombre=txtNombre.text;
      }
      if(precio==0.0){
        precio=double.parse(txtPrecio.text);
      }
      if(descripcion.isEmpty){
        descripcion=txtDescripcion.text;
      }

    }
    return OutlineButton(
      child: Text(btnString),
      color: Theme.of(context).primaryColor,
      onPressed: (foto==null)?
      (){
        ProductoModel productoModel=new ProductoModel(
                activo: 1,
                descripcion: this.descripcion,
                idempresa: idempresa,
                isoferta: Environment().parseEntero(this.favorito),
                nombre: this.nombre,
                cantidad: existencia,
                precio: this.precio,
                categoria: txtCategoria.text,
                tipo: txtTipo.text,
                create_at: DateTime.now().toIso8601String(),
                urlimagen: ""
              );
              if(productoEdit==null){
                productoProvider.insertarProducto(productoModel);
                Navigator.of(context).pop();
                BotToast.showText(text: "Producto agregado correctamente");
              }else{
                //Actualizar
                productoModel.idproducto=productoEdit.idproducto;
                productoModel.upload_at=DateTime.now().toIso8601String();
                productoProvider.actualizarProducto(productoModel);
                Navigator.of(context).pop();
                BotToast.showText(text: "Producto actualizado con exito");
              }
      }
      :()async{
        String fotoUrl="";
        await showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return FutureBuilder<String>(
            future: (foto==null)?null:productoProvider.subirImagen(foto),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              if(snapshot.data.length==0){
                return Center(child: Text("No hay imagen"),);
              }
              //Setear producto
              fotoUrl=snapshot.data;
              ProductoModel productoModel=new ProductoModel(
                activo: 1,
                descripcion: this.descripcion,
                idempresa: idempresa,
                isoferta: Environment().parseEntero(this.favorito),
                nombre: this.nombre,
                precio: this.precio,
                tipo: txtTipo.text,
                cantidad: double.parse(txtCantidad.text),
                create_at: DateTime.now().toIso8601String(),
                urlimagen: fotoUrl
              );
              if(productoEdit==null){
                productoProvider.insertarProducto(productoModel);
                return AlertDialog(
                  content: Text("Producto guardado correctamente "),
                  title: Text("Guardado"),
                  actions: <Widget>[
                    RaisedButton(onPressed: (){
                      Navigator.of(context).pop();
                    },child: Text("Aceptar"),),
                  ],
                );
              }else{
                //Actualizar
                productoModel.idproducto=productoEdit.idproducto;
                productoModel.upload_at=DateTime.now().toIso8601String();
                productoProvider.actualizarProducto(productoModel);
                return AlertDialog(
                  content: Text("Producto actualizado correctamente "),
                  title: Text("Actualizado"),
                  actions: <Widget>[
                    RaisedButton(onPressed: (){
                      Navigator.of(context).pop();
                    },child: Text("Aceptar"),),
                  ],
                );
              }
              //Fin de set de producto
            }
          );
        }
        );
        //print("Foto: "+fotoUrl);
         //*Limipiar producto */
              txtNombre.clear();
              txtPrecio.clear();
              txtDescripcion.clear(); 
              oferta=false;
              foto=null;
              /*Fin */
      });
  }

  Widget _obtenerImagen({ProductoModel productoEdit=null}) {
    if(productoEdit!=null){
      return FadeInImage(placeholder: AssetImage('assets/img/silver_balls.gif'), 
      image: NetworkImage(productoEdit.urlimagen),
      height: 180,
      fit: BoxFit.cover,);
    }else{
      if(foto!=null){
        return Container(
          height: 180,
          child: Image.file(
            foto,
            fit: BoxFit.cover,
          ),
        );
      }
    }
    return Container(
      height: 180,
      color: Colors.blue,
      child: Image(
        image: AssetImage('assets/img/no_product.png'),
        fit: BoxFit.cover,),
    );
  }

  void _seleccionarFoto()async{
    await _procesarImagen(ImageSource.gallery);
  }
  void _tomarFoto()async{
    await _procesarImagen(ImageSource.camera);
  }
  _procesarImagen(ImageSource origen)async{
    foto=await ImagePicker.pickImage(source: origen,imageQuality: 100,maxHeight: 500,maxWidth: 500);
    if(foto!=null){

    }
    setState(() {
      
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _crearTipo() {
    return TextField(
      autofocus: false,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: "Tipo",
        labelText: "Tipo", 
      ),
      onTap: ()async{
        FocusScope.of(context).requestFocus(new FocusNode());
        await showDialog(context: context,
        builder: (context)=>AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height*.3,
            child: FutureBuilder<List<TipoProductoModel>>(
              future: productoProvider.getTodosTipoProducto(idempresa),
              builder: (context,snapshot){
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(),);
                }
                if(snapshot.data.length==0){
                  return Center(child: Text("No hay tipo de producto ingresados"),);
                }
                return ListView.builder(
                  itemBuilder: (context,index){
                    return ListTile(
                      leading: Icon(Icons.store),
                      title: Text(snapshot.data[index].tipo),
                      subtitle: Table(
                        children: [
                          Environment().generarFila("Arancel", snapshot.data[index].arancel.toStringAsFixed(2))
                        ],
                      ),
                      onTap: (){
                        txtTipo.text=snapshot.data[index].tipo;
                        Navigator.pop(context);
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              }
            ),
          ),
        ));
      },
      controller: txtTipo,
    );
  }

  Widget _crearCategoria() {
    return TextField(
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: "Categoria",
        labelText: "Categoria"
      ),
      onTap: ()async{
        FocusScope.of(context).requestFocus(new FocusNode());
        await showDialog(context: context,
        builder: (context)=>AlertDialog(
          content: Container(
            height: MediaQuery.of(context).size.height*.3,
            child: ListView.builder(
              itemBuilder: (context,index){
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text("${listaCategoria[index]}"),
                  onTap: (){
                    txtCategoria.text=listaCategoria[index];
                    Navigator.of(context).pop();
                  },
                );
              },
              itemCount: listaCategoria.length,
            ),
          ),
        ));
      },
      controller: txtCategoria,
    );
  }

  Widget _crearNuevoTipoProducto() {
    return IconButton(
      icon: Icon(Icons.add), onPressed: ()async{
          BotToast.showText(text: "Agregar nuevo tipo de producto");
          await showDialog(context: context,
          builder: (context){
            String tipo;
            double arancel;
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Nuevo tipo producto"),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: "Tipo de producto",
                        labelText: "Tipo",
                      ),
                      onChanged: (value){
                        tipo=value;
                      },
                    ),
                    Divider(),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: "Arancel",
                        labelText: "Arancel"
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        arancel=double.parse(value);
                      },
                    ),
                    RaisedButton.icon(
                      icon: Icon(Icons.check),
                      label: Text("Ingresar tipo"),
                      onPressed: ()async{
                        var tipoProductoModel=TipoProductoModel(
                          tipo: tipo,
                          arancel: arancel,
                          create_at: DateTime.now().toIso8601String(),
                          en_uso: 1,
                          factor1: 0.1,
                          factor2: 0,
                          factor3: 0,
                          factor4: 0,
                          factor5: 0,
                          foto: "",
                          idempresa: idempresa,
                          preferido: 0,
                          principal: 0,
                          upload_at: ""
                        );
                        int valor=await productoProvider.ingresarTipoProducto(tipoProductoModel);
                        if(valor>0){
                          BotToast.showText(text: "Se agrego con exito");
                          txtTipo.clear();
                          txtTipo.text=tipo;
                          Navigator.pop(context);
                        }else{
                          BotToast.showText(text: "No se pudo agregar, verifique integridad");
                        }
                      }
                    )
                  ],
                ),
              ),
            );
          });
      });
  }
}
