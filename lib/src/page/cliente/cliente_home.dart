import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mantenimiento_empresa/src/design/design_style.dart';
import 'package:mantenimiento_empresa/src/filters/filter_cliente.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/models/forma_pago_model.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/page/menu/menu_drawer.dart';
import 'package:mantenimiento_empresa/src/page/menu/search_delegate_cliente.dart';
import 'package:mantenimiento_empresa/src/providers/cliente_provider.dart';
import 'package:mantenimiento_empresa/src/providers/empresa_provider.dart';
import 'package:mantenimiento_empresa/src/providers/producto_provider.dart';
import 'package:provider/provider.dart';
class ClienteHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ClienteProvider clienteProvider=Provider.of<ClienteProvider>(context);
    final idempresa=Provider.of<EmpresaProvider>(context).idempresa;
    EmpresaProvider empresaProvider=Provider.of<EmpresaProvider>(context);
    FilterCliente filterCliente=Provider.of<FilterCliente>(context);
    ProductoProvider productoProvider=Provider.of<ProductoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            clienteProvider.filterC=null;
            showSearch(context: context, delegate: DataSearchCliente());
          }),
          (clienteProvider.consultaP!=null || filterCliente.status)
          ?IconButton(icon: Icon(Icons.close), onPressed: (){
            clienteProvider.consultaP=null;
            clienteProvider.filterC=null;
            filterCliente.limpirarFiltros();
            clienteProvider.notifyListeners();
          })
          :Container(),
          
          IconButton(icon: Icon(Icons.filter_list), onPressed: (){
            filterCliente.limpirarFiltros();
            Navigator.of(context).pushNamed('filter_cliente');
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
          future:(clienteProvider.consultaP==null && !filterCliente.status)
          ? clienteProvider.mostrarClientes(idempresa)
          :(!filterCliente.status)
          ?clienteProvider.buscarCliente(idempresa, clienteProvider.consultaP)
          :filterCliente.obtenerClienteFiltro(),
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
                              ?IconButton(icon: Icon(FontAwesomeIcons.whatsapp,color: Colors.green,), onPressed: ()async{
                                BotToast.showText(text: "Activo");
                                final empresa=await empresaProvider.obtenerEmpresa();
                                List<ProductoModel> productos=await productoProvider.obtenerTodosProductos(empresaProvider.idempresa);
                                await Environment().launchWhatsApp(phone: "+503"+snapshot.data[index].celular, message:Environment().listaProductoString(listado:productos,empresa: empresa.nombre ));
                              })
                              :IconButton(icon: Icon(FontAwesomeIcons.userTie,color: Colors.grey,), onPressed: ()=>BotToast.showText(text: "Desactivado")),
                              IconButton(icon: Icon(Icons.edit,color: Colors.orange,), onPressed: (){
                                Navigator.of(context).pushNamed('edit_cliente',arguments: snapshot.data[index]);
                              }),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              (snapshot.data[index].activo==1)
                              ?IconButton(icon: Icon(FontAwesomeIcons.googlePlusG,color: Colors.blue,), onPressed: ()async{
                                BotToast.showText(text: "Activo");
                                final empresa=await empresaProvider.obtenerEmpresa();
                                List<ProductoModel> productos=await productoProvider.obtenerTodosProductos(empresaProvider.idempresa);
                                await Environment().launcCorreo(correo: snapshot.data[index].email, message: Environment().listaProductoStringCorreo(listado: productos, empresa: empresa.nombre));
                              })
                              :IconButton(icon: Icon(FontAwesomeIcons.phone,color:Theme.of(context).textSelectionColor,), 
                              onPressed: ()async{
                                await Environment().launcPhone(telefono:snapshot.data[index].telefono);
                              }),
                              IconButton(icon: Icon(Icons.close,color: Colors.red,), onPressed: ()async{
                                bool estado=await Environment().confirmar(context, "Eliminar", "Desea eliminar el cliente?");
                                if(estado){
                                  clienteProvider.eliminarCliente(snapshot.data[index].idcliente);
                                  BotToast.showText(text: "Eliminado");
                                  clienteProvider.notifyListeners();
                                  //clienteProvider.
                                }
                              }),
                            ],
                          ),
                          
                        ],
                      ),
                      Divider(color: Theme.of(context).textSelectionColor,),
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