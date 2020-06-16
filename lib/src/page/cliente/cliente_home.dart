import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/models/forma_pago_model.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
import 'package:mantenimiento_empresa/src/page/menu/search_delegate_cliente.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:provider/provider.dart';
class ClienteHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClienteProvider clienteProvider=Provider.of<ClienteProvider>(context);
    final idempresa=Provider.of<EmpresaProvider>(context).idempresa;
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            clienteProvider.filterC=null;
            showSearch(context: context, delegate: DataSearchCliente());
          }),
          (clienteProvider.consultaP!=null || clienteProvider.filterC!=null)
          ?IconButton(icon: Icon(Icons.close), onPressed: (){
            clienteProvider.consultaP=null;
            clienteProvider.filterC=null;
            clienteProvider.notifyListeners();
          })
          :Container(),
          IconButton(icon: Icon(Icons.filter_list), onPressed: ()async{
            await BotToast.showNotification(
              duration: Duration(seconds: 5),
              title: (_){
                return FutureBuilder<List<FormaPagoModel>>(
                  future: clienteProvider.obtenerFormaPago(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }
                    if(snapshot.data.length==0){
                      return Center(child: Text("No hay forma de pago disponible"),);
                    }
                    return Container(
                      height: 120.0,
                      child: ListView.builder(
                        itemBuilder: (context,index){
                          return ListTile(
                            leading: Icon(Icons.filter_list),
                            title: Text(snapshot.data[index].forma_pago),
                            onTap: (){
                              clienteProvider.filterC=snapshot.data[index].forma_pago;
                              clienteProvider.notifyListeners();
                            },
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                    );
                  },
                );
              }
            );
          }),
          Environment().mostrarPopupMenu(choices: Environment().choicesCliente(
            context: context,
            clienteProvider: clienteProvider,
            empresaProvider: empresaProvider
          )
        )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        margin: Environment().metMargen5All,
        child: FutureBuilder<List<ClienteModel>>(
          future:(clienteProvider.consultaP==null && clienteProvider.filterC==null)
          ? clienteProvider.mostrarClientes(idempresa)
          :(clienteProvider.filterC!=null)
          ?clienteProvider.filtrarPorFormaPago(idempresa, clienteProvider.filterC)
          :clienteProvider.buscarCliente(idempresa, clienteProvider.consultaP),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            if(snapshot.data.length==0){
              return Center(child: Text("Agregar clientes"),);
            }
            return ListView.builder(
              physics: BouncingScrollPhysics(),
                itemBuilder: (context,index){
                  return Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text("${snapshot.data[index].nombre}, ${snapshot.data[index].apellido}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${snapshot.data[index].email}"),
                                  Table(
                                    children: [
                                      Environment().generarFila("Telefono", snapshot.data[index].telefono),
                                      Environment().generarFila("Celular", snapshot.data[index].celular),
                                      Environment().generarFila("Oficina", snapshot.data[index].telefono_oficina),
                                      Environment().generarFila("Limite de credito", "\$ ${snapshot.data[index].limite_credito}"),
                                      Environment().generarFila("Forma de pago", snapshot.data[index].forma_pago)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              (snapshot.data[index].activo==1)
                              ?IconButton(icon: Icon(FontAwesomeIcons.userTie,color: Colors.green,), onPressed: ()=>BotToast.showText(text: "Activo"))
                              :IconButton(icon: Icon(FontAwesomeIcons.userTie,color: Colors.grey,), onPressed: ()=>BotToast.showText(text: "Desactivado")),
                              IconButton(icon: Icon(Icons.edit,color: Colors.yellow,), onPressed: (){
                                Navigator.of(context).pushNamed('edit_cliente',arguments: snapshot.data[index]);
                              }),
                            ],
                          )
                        ],
                      ),
                      Divider(),
                    ],
                  );
                },
                itemCount: snapshot.data.length,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).textSelectionColor,
        onPressed: (){
          Navigator.of(context).pushNamed('edit_cliente');
        }
      ),
      drawer: MenuLateral(),
    );
  }
}