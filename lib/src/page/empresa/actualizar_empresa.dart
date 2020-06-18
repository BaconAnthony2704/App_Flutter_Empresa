import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/codigo_postal.dart';
import 'package:mantenimiento_empresa/src/models/departamento_model.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';
class ActualizarEmpresa extends StatefulWidget {
  @override
  _ActualizarEmpresaState createState() => _ActualizarEmpresaState();
}

class _ActualizarEmpresaState extends State<ActualizarEmpresa>{
  final formKey=GlobalKey<FormState>();
  final scafoldkey=GlobalKey<ScaffoldState>();
  EmpresaModel empresaModel;
  bool _guardando=false,domicilio=false;
  File foto;
  String _postal;
  String _direccion="",_departamento="",_municipio="",_giro="",_imagenUrl="";
  List<CodigoPostal> codigoPostal;
  TextEditingController txtCodigoPostal=new TextEditingController();
  TextEditingController txtDireccion=new TextEditingController();
  TextEditingController txtDepartamento=new TextEditingController();
  TextEditingController txtMunicipio=new TextEditingController();
  TextEditingController txtGiro=new TextEditingController();
  Position _currentPosition;
  EmpresaModel empresaData;
  List<String> giros=["Comida","Servicios","Fabricacion","Construccion","Fab de Camisas","Tecnologia","Electronica"];
  EmpresaProvider empresaProvider;
  PreferenciasUsuario prefs=PreferenciasUsuario();
  UsuarioProvider usuarioProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    empresaModel=new EmpresaModel();
  }
  


  @override
  Widget build(BuildContext context) {
    empresaData=ModalRoute.of(context).settings.arguments;
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    DepartamentoProvider departamentoProvider=Provider.of<DepartamentoProvider>(context);
    empresaProvider=Provider.of<EmpresaProvider>(context);
    usuarioProvider=Provider.of<UsuarioProvider>(context);
    codigoPostal=new CodigoPostal().obtenerListaCodigoPostal();
    if(empresaData==null){
      //empresaModel=new EmpresaModel();
      empresaModel.url_imagen=_imagenUrl;
      empresaModel.create_at=DateTime.now().toIso8601String();
    }else{
      txtDireccion.value=new TextEditingController.fromValue(new TextEditingValue(text: _direccion)).value;
        txtDireccion.selection=TextSelection.fromPosition(TextPosition(offset: txtDireccion.text.length));
      //Editar la empresa
      // // empresaModel=new EmpresaModel(
      // //   activo: empresaData.activo,
      // //   create_at: empresaData.create_at,
      // //   data_facturacion: empresaData.data_facturacion,
      // //   departamento: empresaData.data_facturacion,
      // //   direccion: empresaData.direccion,
      // //   email: empresaData.email,
      // //   giro: empresaData.giro,
      // //   idempresa: empresaData.idempresa,
      // //   isdomicilio: empresaData.isdomicilio,
      // //   municipio: empresaData.municipio,
      // //   nit: empresaData.nit,
      // //   nombre: empresaData.nombre,
      // //   nombre_comercial: empresaData.nombre_comercial,
      // //   nrc: empresaData.nrc,
      // //   telefono: empresaData.telefono,
      // //   url_imagen: empresaData.url_imagen,
      // //   upload_at: DateTime.now().toIso8601String(),

      // );
      empresaModel.activo=empresaData.activo;
      empresaModel.create_at=empresaData.create_at;
      empresaModel.data_facturacion=empresaData.data_facturacion;
      empresaModel.departamento=empresaData.departamento;
      empresaModel.municipio=empresaData.municipio;
      empresaModel.direccion=empresaData.direccion;
      empresaModel.email=empresaData.email;
      empresaModel.giro=empresaData.giro;
      empresaModel.idempresa=empresaData.idempresa;
      empresaModel.isdomicilio=empresaData.isdomicilio;
      empresaModel.nit=empresaData.nit;
      empresaModel.nombre=empresaData.nombre;
      empresaModel.nombre_comercial=empresaData.nombre_comercial;
      empresaModel.nrc=empresaData.nrc;
      empresaModel.telefono=empresaData.telefono;
      empresaModel.url_imagen=empresaData.url_imagen;
      empresaModel.upload_at=DateTime.now().toIso8601String();
    }
    return Scaffold(
      key: scafoldkey,
      appBar: AppBar(
        actions: <Widget>[
            IconButton(icon: Icon(FontAwesomeIcons.camera), onPressed: ()async{
              await _tomarFoto();
            }),
            IconButton(icon: Icon(FontAwesomeIcons.fileImage), onPressed: ()async{
              await _seleccionarFoto();
            })
          ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Expanded(
                      child:GestureDetector(
                        child: crearLogo(),
                        onTap: (){
                          empresaModel.url_imagen+="";
                          setState(() {
                            
                          });
                        },
                      ) 
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width*.40,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: _crearSwitch(icono: Icons.motorcycle,subtitulo: "Domicilio",
                        bandera: 2,estado:Environment().parseEntero(this.domicilio)
                      ),
                    )
                  ],
                ),
                Divider(),
                _crearNombre(),
                Divider(),
                _crearNombreComercial(),
                Divider(),
                _crearNit(),
                Divider(),
                _crearNRC(),
                Divider(),
                _crearGiro(),
                Divider(),
                Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*.2,
                        child: _crearCodigoPostal()
                      ),
                      Expanded(child: _crearTelefono()),
                    ],
                  ),
                Divider(),
                _crearEmail(),
                Divider(),
                _crearDireccion(geolocator),
                Divider(),
                Row(
                    children: <Widget>[
                      Expanded(child: _crearDepartamento(departamentoProvider)),
                      (departamentoProvider.progreso || _municipio=="")?Expanded(child: _crearMunicipio(departamentoProvider))
                      :(departamentoProvider.listaMunicipios.length>=0)?Container()
                      :CircularProgressIndicator(),
                    ],
                  ),
                Divider(),
                _crearDataFacturacion(),
                Divider(),
                _crearBoton(),
                
            ],
          ),
        ),
      ),
    );
  }

  Widget crearLogo() {
    if(empresaModel.url_imagen!=null && empresaModel.url_imagen!=""){
      return Container(
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/silver_balls.gif'), 
            image: (empresaModel.url_imagen!=null)
            ?NetworkImage(empresaModel.url_imagen)
            :AssetImage('assets/img/logo_placeholder.png'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }else{
      if(foto!=null){
        return Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.file(
              foto,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }
    
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image(image: AssetImage('assets/img/logo_placeholder.png'),
        fit: BoxFit.cover,),
      ),
    );
  }

  Widget _crearSwitch({String subtitulo,IconData icono,int bandera,int estado}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icono),
      title: Switch(value: domicilio, 
      onChanged: (valor){
        setState(() {
          switch(bandera){
            case 1:
            domicilio=valor;
            break;
            case 2:
            estado=Environment().parseEntero(valor);
            //isdelivery=false;
            domicilio=valor;
            print(estado);
            break;
          }
        });
      }),
      subtitle: Text(subtitulo),
    );
  }

  Widget _crearNombre() {

    return TextFormField(
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Nombre de la empresa",
            labelText: "Empresa",
          ),
          onSaved: (value)=>empresaModel.nombre=value,
          initialValue: empresaModel.nombre,
          validator: (value){
            if(value.length<2){
              return "Ingrese una empresa correcta";
            }else{
              return null;
            }
          },
    );
  }

  Widget _crearNombreComercial() {

    return TextFormField(
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Nombre de la empresa comercial",
            labelText: "Nombre comercial",
          ),
          onSaved: (value)=>empresaModel.nombre_comercial=value,
          initialValue: empresaModel.nombre_comercial,
          validator: (value){
            if(value.length<2){
              return "Ingrese una empresa comercial correcta";
            }else{
              return null;
            }
          },
    );
  }
  
  Widget _crearNit() {
    
      return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Identificacion tributaria",
            labelText: "Identiticacion tributaria",
          ),
          initialValue: empresaModel.nit,
          onSaved: (value)=>empresaModel.nit=value,
    );
  }

  Widget _crearNRC() {
    
      return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Numero de registro de contribuyente",
            labelText: "N.R.C.",
          ),
          initialValue: empresaModel.nrc,
          onSaved: (value)=>empresaModel.nrc=value,
    );
  }

  Widget _crearCodigoPostal() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        labelText: "Postal",
        hintText: "Postal",
      ),
      autofocus: false,
      maxLength: 5,
      onTap: ()async{
        FocusScope.of(context).requestFocus(new FocusNode());
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              content: ListView.builder(
                itemBuilder: (context,index){
                  return ListTile(
                    leading: Icon(FontAwesomeIcons.city),
                    title: Text(codigoPostal[index].codigoPostal),
                    subtitle: Text(codigoPostal[index].pais),
                    onTap: (){
                      Navigator.of(context).pop();
                      setState(() {
                        _postal=codigoPostal[index].codigoPostal;
                        txtCodigoPostal.text=_postal;
                      });
                    },
                  );
                },
                itemCount: codigoPostal.length,
                ),
            );
          }
        );
      },
      initialValue: (_postal=="")?"+503":null,
      controller: txtCodigoPostal,
    );
  }

  Widget _crearTelefono() {
    
      return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Telefono",
            labelText: "Telefono",
          ),
          initialValue: empresaModel.telefono,
          maxLength: 15,
          onSaved: (value)=>empresaModel.telefono=value,
    );
  }

  Widget _crearEmail() {
    
      return TextFormField(
          autofocus: false,
          keyboardType: TextInputType.emailAddress,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Email",
            labelText: "Email",
            suffixIcon: Icon(Icons.alternate_email),
          ),
          
          maxLength: 50,
          initialValue: empresaModel.email,
          onSaved: (value)=>empresaModel.email=value,
          validator: (value){
            if(value.length<10){
              return "Ingrese un email correcto";
            }else{
              return null;
            }
          },
    );
  }

  Widget _crearDireccion(Geolocator geolocator) {
    return TextFormField(
      maxLines: 3,
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: "Direccion",
        labelText: "Direccion",
        suffixIcon: IconButton(
          icon: Icon(Icons.location_on),
          onPressed: ()async{
            
            try{
              
              _currentPosition= await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
              List<Placemark> p=await geolocator.placemarkFromCoordinates(
                _currentPosition.latitude,_currentPosition.longitude);
                Placemark place=p[0];
                setState(() {
                  
                  empresaModel.direccion="${place.thoroughfare}, ${place.subThoroughfare}, ${place.locality}, ${place.country}";
                  _direccion=empresaModel.direccion;
                  txtDireccion.value=new TextEditingController.fromValue(new TextEditingValue(text: empresaModel.direccion)).value;
                  txtDireccion.selection=TextSelection.fromPosition(TextPosition(offset: txtDireccion.text.length));
                  print(empresaModel.direccion);
                });
            }catch(e){
              print("Error en location: $e");
              BotToast.showText(text: "No se pudo obtener la ubicacion, intente de nuevo");
            }
          },
        ),
      ),
      onChanged: (valor){
        setState(() {
        
        txtDireccion.text=valor;
        _direccion=valor;
         print(_direccion);
        });
      },
     controller: (txtDireccion.text.isNotEmpty)?txtDireccion:null,
     initialValue: (_direccion=="")?empresaModel.direccion:null,
    );
  }

  Widget _crearDepartamento(DepartamentoProvider departamentoProvider) {
    return FutureBuilder<List<DepartamentoModel>>(
      future: departamentoProvider.getCargarDepartamentos(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.data.length==0){
          return Center(child: Text("No hay departamentos"),);
        }
        return TextFormField(
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: "Departamento",
          labelText: "Departamento"
        ),
        onTap: ()async{
          FocusScope.of(context).requestFocus(new FocusNode());
          await showDialog(context: context,
          builder: (context)=>AlertDialog(
            content: ListView.builder(
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(snapshot.data[index].nombre),
                  subtitle: Text(snapshot.data[index].iso31662),
                  onTap: (){
                    setState(() {
                      departamentoProvider.obtenerMunicipios(snapshot.data[index].id);
                      empresaModel.departamento=snapshot.data[index].nombre;
                      _departamento=empresaModel.departamento;
                      txtDepartamento.text=_departamento;
                    });
                    Navigator.of(context).pop(true);
                    
                  },
                );
              },
              itemCount: snapshot.data.length,
            ),
          ) 
          );
        },
        initialValue: (_departamento=="")?empresaModel.departamento:null,
        controller: (txtDepartamento.text.isNotEmpty)?txtDepartamento:null,
      );
      },
    );
  }

  Widget _crearMunicipio(DepartamentoProvider departamentoProvider) {
      return TextFormField(
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: "Municipio",
          labelText: "Municipio"
        ),
        onTap: ()async{
          FocusScope.of(context).requestFocus(new FocusNode());
          await showDialog(context: context,
          builder: (context)=>AlertDialog(
            content: ListView.builder(
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(departamentoProvider.listaMunicipios[index].nombre),
                  onTap: (){
                    empresaModel.municipio=departamentoProvider.listaMunicipios[index].nombre;
                    _municipio=empresaModel.municipio;
                    txtMunicipio.text=_municipio;
                    setState(() {
                      
                    });
                    Navigator.of(context).pop(true);
                  },
                );
              },
              itemCount:departamentoProvider.listaMunicipios.length,
            ),
          ) 
          );
        },
        initialValue: (_municipio=="")?empresaModel.municipio:null,
        controller: (txtMunicipio.text.isNotEmpty)?txtMunicipio:null,
      );
      
  }

  Widget _crearGiro() {
      return TextFormField(
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          hintText: "Giro",
          labelText: "Giro"
        ),
        onTap: ()async{
          FocusScope.of(context).requestFocus(new FocusNode());
          await showDialog(context: context,
          builder: (context)=>AlertDialog(
            content: ListView.builder(
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(giros[index]),
                  onTap: (){     
                    // empresaModel.giro=giros[index];
                    // _giro=empresaModel.giro;
                    // txtGiro.text=_giro;
                    setState(() {
                      empresaModel.giro=null;
                      _giro=giros[index];
                      empresaModel.giro=_giro;
                      txtGiro.text=_giro;
                    });
                    Navigator.pop(context);
                  },
                );
              },
              itemCount:giros.length,
            ),
          ) 
          );
        },
        initialValue: (_giro=="")?empresaModel.giro:null,
        controller: (txtGiro.text.isNotEmpty)?txtGiro:null,
      );
      
  }

  Widget _crearDataFacturacion() {

    return TextFormField(
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Data facturacion",
            labelText: "Data factuacion",
          ),
          onSaved: (value)=>empresaModel.data_facturacion=value,
          initialValue: empresaModel.data_facturacion,
          validator: (value){
            if(value.length<2){
              return "Ingrese una empresa correcta";
            }else{
              return null;
            }
          },
    );
  }

  Widget _crearBoton(){
    
    return RaisedButton.icon(
      label: Text("Guardar"),
      icon: Icon(Icons.save),
      onPressed: (_guardando)?null:_submit,
    );
  }

  void _submit()async{
    String accion;
    if(!formKey.currentState.validate()){
      return;
    }
    if(foto!=null){
      empresaModel.url_imagen=await empresaProvider.subirImagen(foto);
      print(_imagenUrl);
    }
    
    (_giro!="")?empresaModel.giro=txtGiro.text:_giro;
    (txtDireccion.text.isNotEmpty)?empresaModel.direccion=txtDireccion.text:_direccion;
    (_departamento!="")?empresaModel.departamento=txtDepartamento.text:_departamento;
    (_municipio!="")?empresaModel.municipio=txtMunicipio.text:_municipio;
    formKey.currentState.save();

    setState(() {
      _guardando=true;
    });

    
    if(empresaModel.idempresa==null){
      //Agregar empresa
      accion="Ingresado";
      
      empresaModel.upload_at="";
      empresaModel.activo=1;
      //empresaModel.url_imagen=_imagenUrl;
      int valor=await empresaProvider.ingresarEmpresa(empresaModel);
      var usr=await usuarioProvider.obtenerUnUsuarioParaMenu(prefs.idusuario);
      usr.idempresa=valor;
      int estado=await usuarioProvider.actualizarUsuarioEmpresa(prefs.idusuario,usr);
      if(estado==1){
        BotToast.showText(text: "Ingresado");
        empresaProvider.obtenerEmpresaFi();
        empresaProvider.notifyListeners();
      }else{
        BotToast.showText(text: "No se pudo actualizar");
      }
      

      // print("Nombre: "+ empresaModel.nombre);
      // print("Nombre comercial: "+empresaModel.nombre_comercial);
      // print("NIT: "+empresaModel.nit);
      // print("NRC: "+empresaModel.nrc);
      // print("Giro: "+empresaModel.giro);
      // print("Telefono: "+empresaModel.telefono);
      // print("Direccion: "+empresaModel.direccion);
      // print("Departamento: "+empresaModel.departamento);
      // print("Municipio: "+empresaModel.municipio);
      // print("Data Fac.: "+empresaModel.data_facturacion);
      // print("Foto url: "+empresaModel.url_imagen);
    }else{
      //Actualizar empresa
      //empresaModel.url_imagen=_imagenUrl;
      // int estado=
      
      await empresaProvider.actualizarEmpresa(empresaModel);
      empresaProvider.obtenerEmpresaFi();
      // if(estado==1){
      //   //BotToast.showText(text: "Actualizado");
      empresaProvider.notifyListeners();
        
      // }else{
      //   BotToast.showText(text: "No se pudo actualizar");
      // }
    }
    setState(() {
      _guardando=false;
    });
    
    mostrarSnackbar('Registro $accion');
   // Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje){
    final snackbar=SnackBar(content: Text(mensaje),
    duration: Duration(milliseconds: 1500),);
    scafoldkey.currentState.showSnackBar(snackbar);
    Navigator.pop(context);
  }

  void _seleccionarFoto()async{
    await _procesarImagen(ImageSource.gallery);
  }
  void _tomarFoto()async{
    await _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen)async{
    foto=await ImagePicker.pickImage(source: origen,imageQuality: 75,maxHeight: 300,maxWidth: 300);
    print(foto);
    setState(() {
      if(foto!=null || empresaModel.url_imagen!=""){
      empresaModel.url_imagen=null;
    }
    });
  }
}