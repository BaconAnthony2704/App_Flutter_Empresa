import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:provider/provider.dart';
class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> with AutomaticKeepAliveClientMixin{
  String nombre="",detalle="",descripcion="";

  double precio=0.0, existencia=0.0;

  bool favorito=false,oferta=false;
  File foto;
  String tituloInterfaz;
  TextEditingController txtNombre=new TextEditingController();
  TextEditingController txtDescripcion=new TextEditingController();
  TextEditingController txtPrecio=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    ProductoProvider productoProvider=
    Provider.of<ProductoProvider>(context);
    final idempresa=Provider.of<EmpresaProvider>(context).idempresa;
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
              children: <Widget>[
                _crearPrecio(),
                SizedBox(width: MediaQuery.of(context).size.width*.1,),
               _crearOferta(),
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
        print(valor);
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
        onChanged: (valor){
          precio=double.parse(txtPrecio.text);
          precio=double.parse(valor);
        },
        controller: txtPrecio,
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
                precio: this.precio,
                urlimagen: ""
              );
              if(productoEdit==null){
                productoProvider.insertarProducto(productoModel);
                Navigator.of(context).pop();
                BotToast.showText(text: "Producto agregado correctamente");
              }else{
                //Actualizar
                productoModel.idproducto=productoEdit.idproducto;
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
}