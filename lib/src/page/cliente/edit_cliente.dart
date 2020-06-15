import 'package:flutter/material.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:provider/provider.dart';

class EditClientePage extends StatefulWidget {
  //crear la clave para el formulario [ara que se pueda ocupar en el submit
  @override
  _EditClientePageState createState() => _EditClientePageState();
}

class _EditClientePageState extends State<EditClientePage> {
  TextEditingController texto=new TextEditingController();
  final formKey=GlobalKey<FormState>();
  final scafoldKey=GlobalKey<ScaffoldState>();
  List<String> formaPago=["Efectivo","Tarjeta"];
  ClienteModel cliente;
  ClienteProvider clienteProvider;
  EmpresaProvider empresaProvider;
  bool _guardando=false;
  String _pago="";
  @override
  Widget build(BuildContext context) {
    clienteProvider=Provider.of<ClienteProvider>(context);
    empresaProvider=Provider.of<EmpresaProvider>(context);
    ClienteModel clienteData=ModalRoute.of(context).settings.arguments;
    if(clienteData==null){
      cliente=new ClienteModel();
    }
    else{
      cliente=new ClienteModel(
        idcliente: clienteData.idcliente,
        nombre: clienteData.nombre,
        apellido: clienteData.apellido,
        email: clienteData.email,
        telefono: clienteData.telefono,
        celular: clienteData.celular,
        telefono_oficina: clienteData.telefono_oficina,
        limite_credito: clienteData.limite_credito,
        forma_pago: clienteData.forma_pago,
        activo: clienteData.activo,
        idempresa: clienteData.idempresa
      );
    }
    
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              _crearNombre(),
              Divider(),
              _crearApellido(),
              Divider(),
              _crearEmail(),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(child: _crearTelefono(),),
                  Expanded(child: _crearCelular(),)
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(child: _crearTelefonoOficina()),
                  Expanded(child: _crearLimiteCredito()),
                ],
              ),
              Divider(),
              _crearFormaPago(),
              Divider(),
              _crearBoton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: cliente.nombre,
      decoration: InputDecoration(
        labelText: "Nombre",
        hintText: "Nombre",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.nombre=value,
      validator: (value){
        if(value.length<3){
          return "Ingrese el nombre completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }
  Widget _crearApellido() {
    return TextFormField(
      initialValue: cliente.apellido,
      decoration: InputDecoration(
        labelText: "Apellido",
        hintText: "Apellido",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.apellido=value,
      validator: (value){
        if(value.length<3){
          return "Ingrese el apellido completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }
  Widget _crearEmail() {
    return TextFormField(
      initialValue: cliente.email,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.email=value,
      validator: (value){
        if(value.length<3){
          return "Ingrese el email completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _crearTelefono() {
    return TextFormField(
      initialValue: cliente.telefono,
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Telefono",
        hintText: "Telefono",
        suffix: Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.telefono=value,
      validator: (value){
        if(value.length<3){
          return "Ingrese el telefono completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _crearCelular() {
    return TextFormField(
      initialValue: cliente.celular,
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Celular",
        hintText: "Celular",
        suffix: Icon(Icons.phone_android),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.celular=value,
      validator: (value){
        if(value.length<3){
          return "Ingrese el celular completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _crearTelefonoOficina() {
    return TextFormField(
      initialValue: cliente.telefono_oficina,
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Oficina",
        hintText: "Oficina",
        suffix: Icon(Icons.business),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.telefono_oficina=value,
      validator: (value){
        if(value.length<3){
          return "Ingrese el telefono oficina completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }
  Widget _crearLimiteCredito() {
    return TextFormField(
      initialValue: (cliente.limite_credito==null)?"0.0":cliente.limite_credito.toString(),
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Lim credito",
        hintText: "Lim credito",
        suffix: Icon(Icons.monetization_on),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      onSaved: (value)=>cliente.limite_credito=double.parse(value),
      validator: (value){
        if(Environment().isNumeric(value)){
          return null;
        }else{
          return "Solo numeros";
        }
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _crearFormaPago() {
    
    return TextFormField(
      initialValue:(_pago=="")? cliente.forma_pago:null,
      controller:(texto.text.isNotEmpty) ?texto:null,
      textInputAction: TextInputAction.go,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Forma de pago",
        hintText: "Forma de pago",
        suffix: Icon(Icons.attach_money),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
      ),
      enableInteractiveSelection: false,
      onTap: ()async{
        FocusScope.of(context).requestFocus(new FocusNode());
        await showDialog(context: context,
        barrierDismissible: false,
        builder: (context)=>AlertDialog(
          content: Container(
            height: 180,
            child: ListView.builder(
              itemBuilder: (context,index){
                return ListTile(
                  leading: Icon(Icons.payment),
                  title: Text(formaPago[index]),
                  onTap: (){
                    
                    setState(() {
                      cliente.forma_pago=null;
                      _pago=formaPago[index];
                      cliente.forma_pago=_pago;
                      texto.text=_pago;
                    });
                    Navigator.of(context).pop();
                    print(cliente.forma_pago);
                  },
                );
              },
              itemCount: formaPago.length,
            ),
          ),
        ));

      },
      //onSaved: (value)=>cliente.forma_pago,
      validator: (value){
        if(value.length<3){
          return "Ingrese limite credito completo";
        }else{
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
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
    formKey.currentState.save();
    print(cliente.nombre);
    print(cliente.apellido);
    print(cliente.email);
    print(cliente.telefono);
    print(cliente.celular);
    print(cliente.telefono_oficina);
    print(cliente.limite_credito);
    print((cliente.forma_pago==null)?_pago:texto.text);
    setState(() {
      _guardando=true;
    });
    if(cliente.idcliente==null){
      //Agregar cliente
      accion="Guardado";
      cliente.idempresa=empresaProvider.idempresa;
      (cliente.forma_pago==null)?cliente.forma_pago=_pago:cliente.forma_pago=texto.text;
      clienteProvider.ingresarCliente(cliente);
      clienteProvider.notifyListeners();
    }else{
      accion="Actualizado";
      //Actualizar cliente
      (cliente.forma_pago==null)?cliente.forma_pago=_pago:cliente.forma_pago=texto.text;
      clienteProvider.actualizarCliente(cliente);
      clienteProvider.notifyListeners();
    }

    setState(() {
      _guardando=false;
    });
    mostrarSnackbar('Registro $accion');

  }

  void mostrarSnackbar(String mensaje){
    final snackbar=SnackBar(content: Text(mensaje),
    duration: Duration(milliseconds: 1500),);
    scafoldKey.currentState.showSnackBar(snackbar);
    Navigator.pop(context);
  }
}
