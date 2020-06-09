import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/departamento_model.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/municipio_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class ActualizarEmpresa extends StatefulWidget {
  @override
  _ActualizarEmpresaState createState() => _ActualizarEmpresaState();
}

class _ActualizarEmpresaState extends State<ActualizarEmpresa>{
  //["idempresa","nombre","giro","nit","telefono","email","direccion","isdomicilio","activo"];
  String nombre,nit,telefono,email,direccion,giro,departamento,municipio;
  String opcionSel,depaSel,muniSel;
  List<String> giros;
  bool isFavorite=false,isdelivery=false,isdomicilio;
  String interfaz="Actualizar Empresa";
  int index,idempresa;
  Position _currentPosition;
  TextEditingController textNombre,txtNit,txtTelefono,txtEmail,txtDireccion,txtGiro,txtDepartamento,txtMunicipio;
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
    textNombre=new TextEditingController();
    txtNit=new TextEditingController();
    txtTelefono=new TextEditingController();
    txtEmail=new TextEditingController();
    txtDireccion=new TextEditingController();
    txtGiro=new TextEditingController();
    txtDepartamento=new TextEditingController();
    txtMunicipio=new TextEditingController();
    isdomicilio=false;
  }
  @override
  Widget build(BuildContext context) {
    DepartamentoProvider departamentoProvider=Provider.of<DepartamentoProvider>(context);
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    EmpresaModel empresa=ModalRoute.of(context).settings.arguments;
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
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
      txtDireccion.value=new TextEditingController.fromValue(new TextEditingValue(text: empresa.direccion)).value;
      txtDireccion.selection=TextSelection.fromPosition(TextPosition(offset: txtDireccion.text.length));
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
            IconButton(icon: Icon(FontAwesomeIcons.camera), onPressed: (){

            }),
            IconButton(icon: Icon(FontAwesomeIcons.fileImage), onPressed: (){
              
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
                    child:Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image(image: AssetImage('assets/img/logo_placeholder.png'),
                        fit: BoxFit.cover,),
                      ),
                    ) 
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width*.40,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: _crearSwitch(icono: Icons.motorcycle,subtitulo: "Domicilio",bandera: 2,estado:Environment().parseEntero(this.isdomicilio)))
                ],
              ),
              Divider(),
              _crearNombre(),
              Divider(),
                _crearNit(),
                Divider(),
                Table(
                  children: [
                    TableRow(
                      children: [
                        _crearTelefono(),
                        _crearGiro(giro)
                      ]
                    )
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
                    (departamentoProvider.progreso)?Expanded(child: _crearMunicipio(departamentoProvider))
                    :(departamentoProvider.listaMunicipios.length>=0)?Container()
                    :CircularProgressIndicator(),
                  ],
                ),
                
                Divider(),
                _crearBoton(context,empresaProvider,idempresa)
            ],
          ),
        ),
        
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
        suffixIcon: IconButton(onPressed: (){
          setState(() {
            textNombre.text="";
          });
        }, icon: Icon(Icons.clear)),
        
      ),
      onChanged: (valor){
        nombre=textNombre.text;
        nombre=valor;

        setState(() {
        });
      },
      initialValue: textNombre.text,
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
        hintText: "NIT",
        labelText: "NIT",
        
      ),
      initialValue: txtNit.text,
      maxLength: 17,
      onChanged: (valor){
        nit=txtNit.text;
        nit=valor;
        setState(() {
        });
      },
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
        suffixIcon: Icon(Icons.phone),
        
      ),
      initialValue: txtTelefono.text,
      maxLength: 9,
      onChanged: (valor){
        setState(() {
          telefono=txtTelefono.text;
          telefono=valor;
        });
      },
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
      
      maxLength: 25,
      onChanged: (valor){
        setState(() {
          email=txtEmail.text;
          email=valor;
        });
      },
      initialValue: txtEmail.text,
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
          direccion=_currentPosition.latitude.toString();
          direccion+=txtDireccion.text;
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

  Widget _crearBoton(BuildContext context, EmpresaProvider empresaProvider, int idempresa) {
    return OutlineButton(
      splashColor: Theme.of(context).primaryColor,
      child: Text("Actualizar"),
      hoverColor: Colors.green.withOpacity(0.8),

      onPressed: ()async{
        EmpresaModel empresaModel=new EmpresaModel(
          idempresa: idempresa,
          activo: 1,
          nombre: (this.nombre.isEmpty)?textNombre.text:this.nombre,
          nit: (this.nit.isEmpty)?txtNit.text:this.nit,
          telefono: (this.telefono.isEmpty)?txtTelefono.text:this.telefono,
          direccion: (this.direccion.isEmpty)?txtDireccion.text:this.direccion,
          email:(this.email.isEmpty)?txtEmail.text:this.email,
          giro: (this.giro.isEmpty)?txtGiro.text:this.giro,
          isdomicilio: Environment().parseEntero(this.isdelivery),
        );
        int valor=await empresaProvider.
        actualizarEmpresa(empresaModel);
        print(valor);

        Navigator.pop(context);
    });
  }
  TableRow tableRow(String titulo,String descripcion) {
    return TableRow(
        children: [
          Text(titulo),
          Text("${descripcion}")
        ]
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

  

}