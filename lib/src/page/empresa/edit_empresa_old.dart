import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/company_model.dart';
import 'package:mantenimiento_empresa/src/providers/company_provider.dart';
import 'package:mantenimiento_empresa/src/service/departamento_service.dart';
import 'package:provider/provider.dart';
class EditCompany extends StatefulWidget {
  @override
  _EditCompanyState createState() => _EditCompanyState();
}

class _EditCompanyState extends State<EditCompany> {
  TextEditingController textEditingNombreController,textEditingDescripcionController,textEditingDireccionController;
  String nombre,descripcion,direccion;
  String opcionSel;
  List<String> giros;
  bool isFavorite,isdelivery;
  String interfaz;
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
    textEditingNombreController=new TextEditingController();
    textEditingDireccionController=new TextEditingController();
    textEditingDescripcionController=new TextEditingController();
    interfaz="";
    //textEditingNombreController.value=textEditingNombreController.value.copyWith(text: nombre);
  }
  @override
  Widget build(BuildContext context) {
    CompanyModel companyEdit=ModalRoute.of(context).settings.arguments;
    CompanyProvider companyProvider=Provider.of<CompanyProvider>(context);
    final departamentoProvider=Provider.of<DepartamentoProvider>(context).listaDepartamentos;
    if(companyEdit==null){
      interfaz="Nueva Empresa";
    }else{
      index=companyProvider.indexCompany(companyEdit);
      interfaz="Actualizar empresa";
       textEditingNombreController.text=companyEdit.nombre;
      this.nombre=companyEdit.nombre;
       // nombre=companyEdit.nombre;
        textEditingDescripcionController.text=companyEdit.descripcion;
        textEditingDireccionController.text=companyEdit.direccion;
        giros.forEach((opcion) {
        if(opcion==companyEdit.giro){
          opcionSel=opcion;
        }
        });
        isdelivery=companyEdit.isdelivery;
        isFavorite=companyEdit.favorito;
        // setState(() {
         
        // });
    }
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
              _crearGiro(),
              Divider(),
              _crearDescripcion(),
              Divider(),
              _crearDireccion(),
              Divider(),
              Row(
                children: <Widget>[
                  Flexible(child: _crearSwitch(icono: Icons.star,subtitulo: "Favorito",bandera: 1)),
                  Container(width: MediaQuery.of(context).size.width*.2,),
                  Flexible(child: _crearSwitch(icono: Icons.motorcycle,subtitulo: "Domicilio",bandera: 2)),
                ],
              ),
              Divider(),
              _crearBoton(context,companyProvider,companyEdit)
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

  Widget _crearBoton(BuildContext context, CompanyProvider companyProvider, CompanyModel companyEdit) {
    String btn;
    if(companyEdit==null){
      btn="Guardar";
    }
    else{
      btn="Actualizar";
    }
    return OutlineButton(
      splashColor: Theme.of(context).primaryColor,
      child: Text(btn),
      hoverColor: Colors.green.withOpacity(0.8),

      onPressed: (){
        CompanyModel companyModel=new CompanyModel(
          categoria: 1,
          color: 0xFF101C42,
          descripcion: this.descripcion,
          direccion: this.direccion,
          favorito: this.isFavorite,
          giro: this.opcionSel,
          isdelivery: this.isdelivery,
          nombre: this.nombre,
          raiting: 0.0,
        );
        if(companyEdit==null){
        String opcion=companyProvider.saveCompany(companyModel);
        BotToast.showText(text: opcion);
        }else{
          print("Aqui va el actualizar");
          companyProvider.updateCompany(index, companyModel);
        }
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
    textEditingNombreController.dispose();
    textEditingDireccionController.dispose();
    textEditingDescripcionController.dispose();
    super.dispose();
  }
}