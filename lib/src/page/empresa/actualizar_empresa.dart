import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/codigo_postal.dart';
import 'package:mantenimiento_empresa/src/models/departamento_model.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/municipio_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/usuario_provider.dart';
import 'package:mantenimiento_empresa/src/providers/valida_bloc.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:mantenimiento_empresa/src/service/preferencias_usuario.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class ActualizarEmpresa extends StatefulWidget {
  @override
  _ActualizarEmpresaState createState() => _ActualizarEmpresaState();
}

class _ActualizarEmpresaState extends State<ActualizarEmpresa>{
  //["idempresa","nombre","giro","nit","telefono","email","direccion","isdomicilio","activo"];
  String nombre,nit,telefono,email,direccion,giro,departamento,municipio;
  String cp;
  String opcionSel,depaSel,muniSel;
  List<String> giros;
  bool isFavorite=false,isdelivery=false,isdomicilio;
  String interfaz="Actualizar Empresa";
  int index,idempresa;
  Position _currentPosition;
  List<CodigoPostal> codigoPostal=new CodigoPostal().obtenerListaCodigoPostal();
  TextEditingController txtCodigoPostal, textNombre,txtNit,txtTelefono,txtEmail,txtDireccion,txtGiro,txtDepartamento,txtMunicipio;
  File foto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombre="";
    nit="";
    telefono="";
    email="";
    direccion="";
    giro="";
    depaSel="San Salvador";
    muniSel="San Salvador SS";
    opcionSel="Seleccione";
    giros=["Seleccione","Comida","Servicios","Fabricacion","Construccion","Fab de Camisas","Tecnologia","Electronica"];
    //codigoPostal=[new CodigoPostal(idCodigo: 1,codigoPostal: "+503",pais: "El Salvador"),];
    textNombre=new TextEditingController();
    txtNit=new TextEditingController();
    txtTelefono=new TextEditingController();
    txtEmail=new TextEditingController();
    txtDireccion=new TextEditingController();
    txtGiro=new TextEditingController();
    txtDepartamento=new TextEditingController();
    txtMunicipio=new TextEditingController();
    txtCodigoPostal=new TextEditingController();
    isdomicilio=false;
  }
  @override
  Widget build(BuildContext context) {
    DepartamentoProvider departamentoProvider=Provider.of<DepartamentoProvider>(context);
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    UsuarioProvider usuarioProvider=Provider.of<UsuarioProvider>(context);
    EmpresaModel empresa=ModalRoute.of(context).settings.arguments;
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    ValidaBloc bloc=Provider.of<ValidaBloc>(context);
    if(empresa==null){
      interfaz="Nueva Empresa";
    }else{
      idempresa=empresa.idempresa;
      /*Nombre */
      textNombre.value=new TextEditingController.fromValue(new TextEditingValue(text: empresa.nombre)).value;
      textNombre.selection=TextSelection.fromPosition(TextPosition(offset: textNombre.text.length));
      /*Nit */
      txtNit.value=new TextEditingController.fromValue(new TextEditingValue(text: empresa.nit)).value;
      txtNit.selection=TextSelection.fromPosition(TextPosition(offset: txtNit.text.length));
      /*Telefono */
      txtTelefono.value=new TextEditingController.fromValue(new TextEditingValue(text: empresa.telefono)).value;
      txtTelefono.selection=TextSelection.fromPosition(TextPosition(offset: txtTelefono.text.length));
      /*Email */
      txtEmail.value=new TextEditingController.fromValue(new TextEditingValue(text: empresa.email)).value;
      txtEmail.selection=TextSelection.fromPosition(TextPosition(offset: txtEmail.text.length));
      /*Descripcion */
      // txtDireccion.value=new TextEditingController.fromValue(new TextEditingValue(text: empresa.direccion)).value;
      // txtDireccion.selection=TextSelection.fromPosition(TextPosition(offset: txtDireccion.text.length));
      /*Departamento */
      // txtDepartamento.value=new TextEditingController.fromValue(new TextEditingValue(text: depaSel)).value;
      // txtDepartamento.selection=TextSelection.fromPosition(TextPosition(offset: txtDepartamento.text.length));
      /*Municipio */
      // txtMunicipio.value=new TextEditingController.fromValue(new TextEditingValue(text: muniSel)).value;
      // txtMunicipio.selection=TextSelection.fromPosition(TextPosition(offset: txtMunicipio.text.length));
    }
    
        //depaSel=snapshot.data.first.nombre;
        return Scaffold(
        appBar: AppBar(
          title: Text(interfaz),
          actions: <Widget>[
            IconButton(icon: Icon(FontAwesomeIcons.camera), onPressed: ()async{
              await _tomarFoto();
            }),
            IconButton(icon: Icon(FontAwesomeIcons.fileImage), onPressed: ()async{
              await _seleccionarFoto();
            })
          ],
        ),
        body: Container(
          margin: Environment().metMargen5All,
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child:crearLogo(empresaModel: empresa) 
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width*.40,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: _crearSwitch(icono: Icons.motorcycle,subtitulo: "Domicilio",bandera: 2,estado:Environment().parseEntero(this.isdomicilio)))
                ],
              ),
              Divider(),
              _crearNombre(bloc),
              Divider(),
                _crearNit(bloc),
                Divider(),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*.2,
                      child: _crearCodigoPostal()
                    ),
                    Expanded(child: _crearTelefono(bloc)),
                  ],
                ),
                _crearGiro(giro),
                Divider(),
                _crearEmail(bloc),
                
                Divider(),
                _crearDireccion(geolocator),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: _crearDepartamento(departamentoProvider)),
                    (departamentoProvider.progreso)?Expanded(child: _crearMunicipio(departamentoProvider))
                    :(departamentoProvider.listaMunicipios.length>=0)?Container()
                    :CircularProgressIndicator(),
                  ],
                ),
                
                Divider(),
                _crearBoton(context,empresaProvider,idempresa,bloc,empresa,usuarioProvider)
            ],
          ),
        ),
        
      );
      
  }

  Widget crearLogo({EmpresaModel empresaModel=null}) {
    if(empresaModel!=null){
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
  Widget _crearNombre(ValidaBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.nombreEmpresaStream,
      builder: (context,snapshot){
        return TextFormField(
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: "Nombre de la empresa",
            labelText: "Empresa",
            errorText: snapshot.error,
            suffixIcon: IconButton(onPressed: (){
              setState(() {
                textNombre.text="";
              });
            }, icon: Icon(Icons.clear)),
            
          ),
          onChanged: bloc.changeNombreEmpresa,
          initialValue: textNombre.text,
        );
      },
    );
  }

  Widget _crearNit(ValidaBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.nitStream,
      builder: (context,snapshot){
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
          initialValue: txtNit.text,
          onChanged: bloc.changeNit,
        );
      }
    );
  }

  Widget _crearTelefono(ValidaBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.telefonoStream,
      builder: (context,snapshot){
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
            errorText: snapshot.error,
          ),
          initialValue: txtTelefono.text,
          maxLength: 15,
          onChanged: bloc.changeTelefono,
        );
      }
    );
  }

  Widget _crearCodigoPostal() {
    return TextField(
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
              content: Container(
                height: MediaQuery.of(context).size.height*.25,
                child: Column(
                  children: <Widget>[
                    Text("Seleccione el codigo postal"),
                    Container(
                      height: MediaQuery.of(context).size.height*.2,
                      child: ListView.builder(
                        itemBuilder: (context,index){
                          return ListTile(
                            leading: Icon(FontAwesomeIcons.city),
                            title: Text(codigoPostal[index].codigoPostal),
                            subtitle: Text(codigoPostal[index].pais),
                            onTap: (){
                              Navigator.of(context).pop();
                              cp=codigoPostal[index].codigoPostal;
                              txtCodigoPostal.text=codigoPostal[index].codigoPostal;
                              setState(() {
                              });
                            },
                          );
                        },
                        itemCount: codigoPostal.length,
                        ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
      controller: txtCodigoPostal,
    );
  }
  Widget _crearEmail(ValidaBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.emailStream,
      builder:(context,snapshot){
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
            errorText: snapshot.error
          ),
          
          maxLength: 25,
          onChanged: bloc.changeEmail,
          initialValue: txtEmail.text,
        );
      },
    );
  }

  Widget _crearGiro(String giro) {
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
        print("Cambio");
        FocusScope.of(context).requestFocus(new FocusNode());
        await showDialog(context: context,
        builder: (context)=>AlertDialog(
          content: DropdownButton(
            value: this.opcionSel,
            items: _getOpcionesDropDown(), 
            onChanged: (opt){
              setState(() {
                txtGiro.clear();
                opcionSel=opt;
                txtGiro.text=opt;
                giro=txtGiro.text;
                Navigator.of(context).pop();
              });
              
            }
          ),
        ) 
        );
      },
      controller: (!txtGiro.value.text.isEmpty)?txtGiro:null,
      initialValue: (txtGiro.value.text.isEmpty)?giro:null,
    );
  }

  List<DropdownMenuItem<String>>_getOpcionesDropDown() {
    List<DropdownMenuItem<String>> lista=new List();
    giros.forEach((g) {
      lista.add(DropdownMenuItem(
        value: g,
        child: Text(g),
      ));
     });
     return lista;
  }

  Widget _crearDireccion(Geolocator geolocator) {
    return TextField(
      maxLines: 3,
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        counter: Text("${txtDireccion.text.length}"),
        hintText: "Direccion",
        labelText: "Direccion",
        suffixIcon: IconButton(
          icon: Icon(Icons.location_on),
          onPressed: ()async{
            
            try{
              txtDireccion.clear();
              _currentPosition= await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
              List<Placemark> p=await geolocator.placemarkFromCoordinates(
                _currentPosition.latitude,_currentPosition.longitude);
                Placemark place=p[0];
                setState(() {
                  direccion="${place.thoroughfare}, ${place.subThoroughfare}, ${place.locality}, ${place.country}";
                  //txtDireccion.text=direccion;
                  txtDireccion.value=new TextEditingController.fromValue(new TextEditingValue(text: direccion)).value;
                  txtDireccion.selection=TextSelection.fromPosition(TextPosition(offset: txtDireccion.text.length));
                  print(direccion);
                });
            }catch(e){
              print("Error en location: $e");
            }
          },
        ),
      ),
      onChanged: (valor){
        setState(() {
        //   txtDireccion.clear();
        //   direccion=_currentPosition.latitude.toString();
        //   direccion+=txtDireccion.text;
        //  direccion=valor;

        // descripcion=txtDescripcion.text;
        // descripcion=valor;

        direccion=txtDireccion.text;
        direccion=valor;
         print(direccion);
        });
      },
     controller: txtDireccion,
    );
  }

  Widget _crearSwitch({String subtitulo,IconData icono,int bandera,int estado}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icono),
      title: Switch(value: (bandera==1)?isFavorite:isdelivery, 
      onChanged: (valor){
        setState(() {
          switch(bandera){
            case 1:
            isFavorite=valor;
            break;
            case 2:
            estado=Environment().parseEntero(valor);
            //isdelivery=false;
            isdelivery=valor;
            print(estado);
            break;
          }
        });
      }),
      subtitle: Text(subtitulo),
    );
  }

  Widget _crearBoton(BuildContext context, EmpresaProvider empresaProvider,
   int idempresa, ValidaBloc bloc, EmpresaModel empresa,UsuarioProvider usuarioProvider) {
     String btn;
     String urlImagen;
     if(empresa==null){
       btn="Ingresar";
       if(foto==null){
         urlImagen="";
       }
       return StreamBuilder<bool>(
        stream: bloc.formValidStream,
        builder: (context,snapshot){
          return RaisedButton(
            color: Theme.of(context).textSelectionColor,
            splashColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text(btn),
            hoverColor: Colors.green.withOpacity(0.8),

            onPressed: (snapshot.hasData)
            ?()async{
              int valor;
              EmpresaModel empresaModel=new EmpresaModel(
                activo: 1,
                nombre: bloc.nombreEmpresa,
                nit: (bloc.nit!=null)?bloc.nit:"-",
                telefono: (txtCodigoPostal.text.isNotEmpty)?txtCodigoPostal.text+bloc.telefono:bloc.telefono,
                direccion: this.direccion,
                email:bloc.email,
                giro: this.txtGiro.text,
                create_at: DateTime.now().toIso8601String(),
                departamento: this.departamento,
                municipio: this.municipio,
                url_imagen: await empresaProvider.subirImagen(foto),
                upload_at: "",
                isdomicilio: Environment().parseEntero(this.isdelivery),
              );
              valor=await empresaProvider.
              ingresarEmpresa(empresaModel);
              PreferenciasUsuario prefs=PreferenciasUsuario();
              var usr=await usuarioProvider.obtenerUnUsuarioParaMenu(prefs.idusuario);
              
                usr.idempresa=valor;
                int estado=await usuarioProvider.actualizarUsuarioEmpresa(prefs.idusuario, usr);
                if(estado==1){
                  BotToast.showText(text: "Actualizado");
                  //usuarioProvider.notifyListeners();
                  empresaProvider.obtenerEmpresaFi();
                  empresaProvider.notifyListeners();
                }else{
                  BotToast.showText(text: "No se pudo actualizar");
                }
              
              Navigator.pop(context);

              // print(bloc.nombreEmpresa);
              // print(bloc.email);
              // print(bloc.nit);
              // print(bloc.telefono);
              // print(this.direccion);
              // print(this.departamento);
              // print(this.municipio);
              // print(this.txtGiro.text);

              //String urlImagen=await empresaProvider.subirImagen(foto);
              //print(urlImagen);
          }
          :null,
          );
        }
      );
     }else{
       btn="Actualizar";
       
          return RaisedButton(
            color: Theme.of(context).textSelectionColor,
            splashColor: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text(btn),
            hoverColor: Colors.green.withOpacity(0.8),
            onPressed: 
            ()async{
              EmpresaModel empresaModel=new EmpresaModel(
                idempresa: idempresa,
                activo: 1,
                nombre: bloc.nombreEmpresa,
                nit: bloc.nit,
                telefono: bloc.telefono,
                direccion: this.direccion,
                email:bloc.email,
                giro: this.txtGiro.text,
                create_at: "",
                departamento: this.departamento,
                municipio: this.municipio,
                url_imagen: (foto==null)
                ?empresa.url_imagen
                :await empresaProvider.subirImagen(foto),
                upload_at: DateTime.now().toIso8601String(),
                isdomicilio: Environment().parseEntero(this.isdelivery),
              );
              int valor=await empresaProvider.
              actualizarEmpresa(empresaModel);
              Navigator.pop(context);

              // print(bloc.nombreEmpresa);
              // print(bloc.email);
              // print(bloc.nit);
              // print(bloc.telefono);
              // print(this.direccion);
              // print(this.departamento);
              // print(this.municipio);
              // print(this.txtGiro.text);

              //String urlImagen=await empresaProvider.subirImagen(foto);
              //print(urlImagen);
          }
          
          );
        
     }
    
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
        return TextField(
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
                      //departamentoProvider.notifyListeners();
                      txtDepartamento.clear();
                      txtMunicipio.clear();
                      txtDepartamento.text=snapshot.data[index].nombre;
                      departamento=txtDepartamento.text;
                    });
                    Navigator.of(context).pop(true);
                    //print(departamentoLista[index].id);
                    
                  },
                );
              },
              itemCount: snapshot.data.length,
            ),
          ) 
          );
        },
        controller: txtDepartamento,
      );
      },
    );
  }

  Widget _crearMunicipio(DepartamentoProvider departamentoProvider) {
        return TextField(
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
                    txtMunicipio.clear();
                    txtMunicipio.text=departamentoProvider.listaMunicipios[index].nombre;
                    municipio=txtMunicipio.text;
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
        controller: txtMunicipio,
      );
      
  }

  void _seleccionarFoto()async{
    await _procesarImagen(ImageSource.gallery);
  }
  void _tomarFoto()async{
    await _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen)async{
    foto=await ImagePicker.pickImage(source: origen,imageQuality: 75,maxHeight: 300,maxWidth: 300);
    
    setState(() {
      
    });
  }

  
  

  

}