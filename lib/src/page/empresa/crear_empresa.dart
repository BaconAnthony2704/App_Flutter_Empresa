import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:provider/provider.dart';
class EditCompany extends StatefulWidget {
  @override
  _EditCompanyState createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> with AutomaticKeepAliveClientMixin{
  //["idempresa","nombre","giro","nit","telefono","email","direccion","isdomicilio","activo"];
  TextEditingController textEditingNombreController,textEditingDescripcionController,textEditingDireccionController;
  String nombre,descripcion,direccion,nit,telefono,email;
  String opcionSel;
  List<String> giros;
  bool isFavorite,isdelivery;
  String interfaz="Nueva Empresa";
  int index;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nombre="";
    descripcion="";
    direccion="";
    opcionSel="Seleccione";
    giros=["Seleccione","Comida","Servicios","Fabricacion","Construccion","Fab de Camisas","Tecnologia","Electronica"];
    isFavorite=false;
    isdelivery=false;
  }
  @override
  Widget build(BuildContext context) {
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    final departamentoProvider=Provider.of<DepartamentoProvider>(context).listaDepartamentos;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(interfaz),
      ),
      body: Container(
        margin: Environment().metMargen5All,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _crearNombre(),
              Divider(),
              _crearNit(),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _crearTelefono(),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: _crearEmail()
                  )
                ],
              ),
              Divider(),
              _crearGiro(),
              Divider(),
              _crearDescripcion(),
              Divider(),
              _crearDireccion(),
              Divider(),
              Row(
                children: <Widget>[
                  Container(width: MediaQuery.of(context).size.width*.2,),
                  Flexible(child: _crearSwitch(icono: Icons.motorcycle,subtitulo: "Domicilio",bandera: 2)),
                ],
              ),
              Divider(),
              _crearBoton(context,empresaProvider)
            ],
          ),
        ),
      ),
      
    ); 
  }
  Widget _crearNombre() {
    return TextFormField(
      autofocus: false,
      textCapitalization: TextCapitalization.sentences,
      controller: textEditingNombreController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //counter: Text("${nombre.length}"),
        hintText: "Nombre de la empresa",
        labelText: "Empresa",
        suffixIcon: Icon(Icons.business),
        
      ),
      onChanged: (valor){
        setState(() {
          //textEditingNombreController.text=valor;
          nombre=valor;
        });
      },
    );
  }
  Widget _crearNit() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.sentences,
      controller: textEditingNombreController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //counter: Text("${nombre.length}"),
        hintText: "NIT",
        labelText: "NIT",
        suffixIcon: Icon(Icons.assignment),
        
      ),
      maxLength: 17,
      onChanged: (valor){
        setState(() {
          //textEditingNombreController.text=valor;
          nit=valor;
        });
      },
    );
  }

  Widget _crearTelefono() {
    return TextFormField(
      autofocus: false,
      keyboardType: TextInputType.number,
      textCapitalization: TextCapitalization.sentences,
      controller: textEditingNombreController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //counter: Text("${nombre.length}"),
        hintText: "Telefono",
        labelText: "Telefono",
        suffixIcon: Icon(Icons.phone),
        
      ),
      maxLength: 9,
      onChanged: (valor){
        setState(() {
          //textEditingNombreController.text=valor;
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
      controller: textEditingNombreController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //counter: Text("${nombre.length}"),
        hintText: "Email",
        labelText: "Email",
        suffixIcon: Icon(Icons.alternate_email),
        
      ),
      maxLength: 25,
      onChanged: (valor){
        setState(() {
          //textEditingNombreController.text=valor;
          email=valor;
        });
      },
    );
  }

  Widget _crearGiro() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          //color:Theme.of(context).textSelectionColor
        )
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.select_all),
          SizedBox(width: 30.0,),
          Container(
            padding: EdgeInsets.only(right: 20.0),
            child: Text("Giro")
          ),
          Flexible(
            child: DropdownButton(
              value: this.opcionSel,
              items: _getOpcionesDropDown(), 
              onChanged: (opt){
                setState(() {
                  opcionSel=opt;
                });
              }
            )
          ),
        ],
      ),
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

  Widget _crearDescripcion() {
    return TextField(
      maxLines: 2,
      autofocus: false,
      controller: textEditingDescripcionController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        counter: Text("${descripcion.length}"),
        hintText: "Descripcion",
        labelText: "Descripcion",
        suffixIcon: Icon(Icons.description),
      ),
      onChanged: (valor){
        setState(() {
          descripcion=valor;
          
        });
      },
    );
  }

  Widget _crearDireccion() {
    return TextField(
      maxLines: 3,
      autofocus: false,
      controller: textEditingDireccionController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        counter: Text("${direccion.length}"),
        hintText: "Direccion",
        labelText: "Direccion",
        suffixIcon: Icon(Icons.my_location),
      ),
      onChanged: (valor){
        setState(() {
          direccion=valor;
        });
      },
    );
  }

  Widget _crearSwitch({String subtitulo,IconData icono,int bandera}) {
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
            isdelivery=valor;
            break;
          }
        });
      }),
      subtitle: Text(subtitulo),
    );
  }

  Widget _crearBoton(BuildContext context, EmpresaProvider empresaProvider) {
    return OutlineButton(
      splashColor: Theme.of(context).primaryColor,
      child: Text("Guardar"),
      hoverColor: Colors.green.withOpacity(0.8),

      onPressed: ()async{
        EmpresaModel empresaModel=new EmpresaModel(
          activo: 1,
          nombre: this.nombre,
          nit: this.nit,
          telefono: this.telefono,
          direccion: this.direccion,
          email: this.email,
          giro: this.opcionSel,
          isdomicilio: Environment().parseEntero(this.isdelivery),
        );
        int valor=await empresaProvider.ingresarEmpresa(empresaModel);
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
  @override
  void dispose() { 
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}