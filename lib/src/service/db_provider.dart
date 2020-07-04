import 'dart:io';
import 'package:mantenimiento_empresa/src/models/categoria_model.dart';
import 'package:mantenimiento_empresa/src/models/cliente_model.dart';
import 'package:mantenimiento_empresa/src/models/empresa_model.dart';
import 'package:mantenimiento_empresa/src/models/existencia_model.dart';
import 'package:mantenimiento_empresa/src/models/existencia_tipo.dart';
import 'package:mantenimiento_empresa/src/models/forma_pago_model.dart';
import 'package:mantenimiento_empresa/src/models/producto_model.dart';
import 'package:mantenimiento_empresa/src/models/rol_model.dart';
import 'package:mantenimiento_empresa/src/models/tipo_producto_model.dart';
import 'package:mantenimiento_empresa/src/models/usuario_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider{
  /*Indicamos las variables estaticas para saber si creamos una tabla, si la tabla
  existe, escribir, en ella y no estar generando muchas tablas del mismo tipo  */
  //Instancia privada .()
  static Database _database;
  static final DBProvider db=DBProvider._();

  //Tablas
  final String tabla_empresa="empresa";
  final String tabla_usuario="usuario";
  final String tabla_rol="rol";
  final String tabla_producto="producto";
  final String tabla_existencia="existencia";
  final String tabla_cliente="cliente";
  final String tabla_tipo_producto="tipo_producto";

  //Columnas
  List<String> columna_empresa=["idempresa","nombre","giro","nit","telefono","email","direccion","isdomicilio",
                                "activo","departamento","municipio","create_at","upload_at","url_imagen","nrc","nombre_comercial","data_facturacion"];

  List<String> columna_usuario=["idusuario","nombre","email","password","idrol","idempresa","activo",
                                "docreate","doread","doupdate","dodelete"];

  List<String> columna_rol=["idrol","accion","activo"];

  List<String> columna_producto=["idproducto","nombre","precio","urlimagen","isoferta","idempresa",
                                  "descripcion","activo","tipo","categoria","cantidad","create_at","upload_at"];

  List<String> columna_existencia=["idexistencia","idproducto","idempresa","cantidad","activo"];

  List<String> columna_cliente=["idcliente","nombre","apellido","email","telefono","limite_credito",
                                "forma_pago","activo","idempresa","celular","telefono_oficina"];

  List<String> columna_tipo_producto=["tipo","arancel","foto","en_uso","preferido",
                                      "factor1","factor2","factor3","factor4",
                                      "factor5","principal","create_at","upload_at",
                                      "idempresa"];

  DBProvider._();
  //Creamos el metodo para verificar si la tabla existe
  Future<Database> get database async{
    if(_database!=null){
      return _database;
    }
    //Creamos el constructor asincrono
    _database=await initDB();
    return _database;
  }
  initDB() async{
    Directory directory=await getApplicationDocumentsDirectory();
    final path=join(directory.path,"manttoDB3.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (db,version)async{
        //Iniciaiizacion de la base de datos
        await db.execute(
          '''CREATE TABLE ${tabla_empresa}
          (
          ${columna_empresa[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${columna_empresa[1]} TEXT,
          ${columna_empresa[2]} TEXT,
          ${columna_empresa[3]} TEXT,
          ${columna_empresa[4]} TEXT,
          ${columna_empresa[5]} TEXT,
          ${columna_empresa[6]} TEXT,
          ${columna_empresa[7]} INTEGER,
          ${columna_empresa[8]} INTEGER,
          ${columna_empresa[9]} TEXT,
          ${columna_empresa[10]} TEXT,
          ${columna_empresa[11]} TEXT,
          ${columna_empresa[12]} TEXT,
          ${columna_empresa[13]} TEXT,
          ${columna_empresa[14]} TEXT,
          ${columna_empresa[15]} TEXT,
          ${columna_empresa[16]} TEXT
          )
         ''');
         print("Tabla empresa creada");
         await db.execute(
          '''CREATE TABLE ${tabla_usuario}
          (
          ${columna_usuario[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${columna_usuario[1]} TEXT,
          ${columna_usuario[2]} TEXT,
          ${columna_usuario[3]} TEXT,
          ${columna_usuario[4]} INTEGER,
          ${columna_usuario[5]} INTEGER,
          ${columna_usuario[6]} INTEGER,
          ${columna_usuario[7]} INTEGER,
          ${columna_usuario[8]} INTEGER,
          ${columna_usuario[9]} INTEGER,
          ${columna_usuario[10]} INTEGER
          )
         ''');


         await db.execute(
          '''CREATE TABLE ${tabla_tipo_producto}
          (
          ${columna_tipo_producto[0]} VARCHAR(20) PRIMARY KEY UNIQUE,
          ${columna_tipo_producto[1]} REAL,
          ${columna_tipo_producto[2]} TEXT,
          ${columna_tipo_producto[3]} INTEGER,
          ${columna_tipo_producto[4]} INTEGER,
          ${columna_tipo_producto[5]} REAL,
          ${columna_tipo_producto[6]} REAL,
          ${columna_tipo_producto[7]} REAL,
          ${columna_tipo_producto[8]} REAL,
          ${columna_tipo_producto[9]} REAL,
          ${columna_tipo_producto[10]} INTEGER,
          ${columna_tipo_producto[11]} TEXT,
          ${columna_tipo_producto[12]} TEXT,
          ${columna_tipo_producto[13]} INTEGER
          
          )
         ''');
         print("Tabla tipo producto creada");
         print("Tabla usuario creada");
         await db.execute(
          '''CREATE TABLE ${tabla_rol}
          (
          ${columna_rol[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${columna_rol[1]} TEXT,
          ${columna_rol[2]} INTEGER
          )
         ''');
         print("Tabla rol creada");
         await db.execute(
          '''CREATE TABLE ${tabla_producto}
          (
          ${columna_producto[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${columna_producto[1]} TEXT,
          ${columna_producto[2]} REAL,
          ${columna_producto[3]} TEXT,
          ${columna_producto[4]} INTEGER,
          ${columna_producto[5]} INTEGER,
          ${columna_producto[6]} TEXT,
          ${columna_producto[7]} INTEGER,
          ${columna_producto[8]} TEXT,
          ${columna_producto[9]} TEXT,
          ${columna_producto[10]} REAL,
          ${columna_producto[11]} TEXT,
          ${columna_producto[12]} TEXT
          )
         ''');
         print("Tabla producto creada");
         await db.execute(
          '''CREATE TABLE ${tabla_existencia}
          (
          ${columna_existencia[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${columna_existencia[1]} INTEGER,
          ${columna_existencia[2]} INTEGER,
          ${columna_existencia[3]} REAL,
          ${columna_existencia[4]} INTEGER
          )
         ''');
         print("Tabla existencia creada");
         await db.execute(
           '''CREATE TABLE ${tabla_cliente}
          (
          ${columna_cliente[0]} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${columna_cliente[1]} TEXT,
          ${columna_cliente[2]} TEXT,
          ${columna_cliente[3]} TEXT,
          ${columna_cliente[4]} TEXT,
          ${columna_cliente[5]} REAL,
          ${columna_cliente[6]} TEXT,
          ${columna_cliente[7]} INTEGER,
          ${columna_cliente[8]} INTEGER,
          ${columna_cliente[9]} TEXT,
          ${columna_cliente[10]} TEXT
          )
         '''
         );
         print("Tabla cliente creada");
         //["idrol","accion","activo"];
         await db.execute('''
         INSERT INTO ${tabla_rol} 
         (accion,activo) 
         VALUES('Super Administrador',1)
         ''');
         print("Consulta realizada No1");
         await db.execute('''
         INSERT INTO ${tabla_rol} 
         (accion,activo)  
         VALUES('Usuario',1)
         ''');
        print("Consulta realizada No2");
        //["idusuario","nombre","email","password","idrol","idempresa","activo"];
        await db.execute('''
         INSERT INTO ${tabla_usuario} 
         (nombre,email,password,idrol,idempresa,activo,docreate,doread,doupdate,dodelete) 
         VALUES('root','usuario@root.com','diprocad1',1,0,1,1,1,1,1)
         ''');
         print("Consulta realizada No.3");
         await db.execute('''
         INSERT INTO ${tabla_usuario} 
         (nombre,email,password,idrol,idempresa,activo,docreate,doread,doupdate,dodelete) 
         VALUES('superRoot','usuario2@root.com','diprocad2',1,0,1,1,1,1,1)
         ''');
         print("Consulta realizada No.4");

      }
    );
      
  }
  //Crear cliente
  Future<int> crearCliente(ClienteModel clienteModel)async{
    final db=await database;
    final res=await db.insert(tabla_cliente, clienteModel.toJson());
    return res;
  }

  //Crear Empresa
  Future<int> crearEmpresa(EmpresaModel empresaModel)async{
    final db=await database;
    final res=await db.insert(tabla_empresa, empresaModel.toJson());
    return res;
  }
  //Crear Usuario
  Future<int>crearUsuario(UsuarioModel usuarioModel)async{
    final db=await database;
    final res=await db.insert(tabla_usuario, usuarioModel.toJson());
    return res;
  }
  //Crear rol
  crearRoles()async{
    RolModel rolModel0=new RolModel(accion: "Super Administrador",activo: 1);
    RolModel rolModel1=new RolModel(accion: "Administrador",activo: 1);
    RolModel rolModel2=new RolModel(accion: "Usuario",activo: 1);
    final db=await database;
    await db.insert(tabla_rol, rolModel0.toJson());
    await db.insert(tabla_rol, rolModel1.toJson());
    await db.insert(tabla_rol, rolModel2.toJson());
  }
  //Crear producto
  crearProducto(ProductoModel productoModel)async{
    final db=await database;
    final res=await db.insert(tabla_producto, productoModel.toJson());
    return res;
  }
  //Crear Existencia
  crearExistencia(ExistenciaModel existenciaModel)async{
    final db=await database;
    final res=await db.insert(tabla_existencia, existenciaModel.toJson());
    return res;
  }

  //Eliminar empresa
  Future<int> eliminarEmpresa(int idempresa)async{
    final db=await database;
    final res=await db.delete(tabla_empresa,where: "${columna_empresa[0]}=?",whereArgs: [idempresa]);
    return res;
  }
  Future<List<EmpresaModel>> getTodosEmpresas()async{
    final db=await database;
    final res=await db.query(tabla_empresa);
    List<EmpresaModel> lista=res.isNotEmpty?res.map((empresa) => EmpresaModel.fromJson(empresa)).toList()
                              :[];
    return lista;
  }

  //Obtener TODOS productos
  Future<List<ProductoModel>> getTodosProductos(int idempresa)async{
    final db=await database;
    final res=await db.query(tabla_producto,where: "${columna_producto[5]}=?",whereArgs: [idempresa]);
    List<ProductoModel> list=res.isNotEmpty
                            ?res.map((producto) => ProductoModel.fromJson(producto)).toList()
                            :[];
    return list;
  }

  //Obtener TODOS usuarios
  Future<List<UsuarioModel>> getTodosUsuarios(int idempresa)async{
    final db=await database;
    final res=await db.query(tabla_usuario,where:"${columna_usuario[5]}=? AND ${columna_usuario[4]}=2",whereArgs: [idempresa]);
    List<UsuarioModel> list=res.isNotEmpty
                            ?res.map((usuario) => UsuarioModel.fromJson(usuario)).toList()
                            :[];
    return list;
  }

  //Obtener TODOS existencias
  Future<List<ExistenciaModel>> getTodosExistencias(int idempresa)async{
    final db=await database;
    final res=await db.query(tabla_existencia,where: "${columna_existencia[2]}=?",whereArgs: [idempresa]);
    List<ExistenciaModel> list=res.isNotEmpty
                              ?res.map((existencia) => ExistenciaModel.fromJson(existencia)).toList()
                              :[];
    return list;
  }

  //Obtener UN usuario
  Future<UsuarioModel> getUsuario(int idusuario)async{
    final db=await database;
    final res=await db.query(tabla_usuario,where: "${columna_usuario[0]}=?",whereArgs: [idusuario]);
    return res.isNotEmpty?UsuarioModel.fromJson(res.first):null;
  }
  Future<UsuarioModel> getUsuarioIntegridad(String email)async{
    final db=await database;
    final res=await db.query(tabla_usuario,where:"${columna_usuario[2]}=?",whereArgs: [email]);
    return res.isNotEmpty?UsuarioModel.fromJson(res.first):null;
  }
  //Obtener Usuario registrado
  Future<UsuarioModel> getUsuarioRegistrado(String email,String password)async{
    final db=await database;
    final res=await db.query(tabla_usuario,where: "${columna_usuario[2]}=? AND ${columna_usuario[3]}=? AND ${columna_usuario[6]}=1",whereArgs: [email,password]);
    return res.isNotEmpty?UsuarioModel.fromJson(res.first):null;
  }

  //Obtener UNA empresa
  Future<EmpresaModel> getEmpresa(int idempresa)async{
    final db=await database;
    final res=await db.query(tabla_empresa,where: "${columna_empresa[0]}=?",whereArgs: [idempresa]);
    return res.isNotEmpty?EmpresaModel.fromJson(res.first):null;
  }

  Future<EmpresaModel> getEmpresaUsuario(int idusuario)async{
    /*SELECT e.nombre,e.giro,e.nit,e.telefono,e.email,e.direccion,e.isdomicilio,e.activo FROM empresa AS e
      INNER JOIN usuario AS u
      ON e.idempresa=1 */
      /* AND u.${columna_usuario[10]}=1 AND u.${columna_usuario[9]}=1 
    AND u.${columna_usuario[8]}=1 AND u.${columna_usuario[7]}=1 AND u.${columna_usuario[4]}=1 */
    final db=await database;
    final String query='''
    SELECT e.${columna_empresa[0]},e.${columna_empresa[1]}, e.${columna_empresa[2]}, 
    e.${columna_empresa[3]},e.${columna_empresa[4]}, 
    e.${columna_empresa[5]},e.${columna_empresa[6]}, e.${columna_empresa[7]},
    e.${columna_empresa[8]},e.${columna_empresa[9]},e.${columna_empresa[10]},e.${columna_empresa[11]},
    e.${columna_empresa[12]},e.${columna_empresa[13]},e.${columna_empresa[14]},e.${columna_empresa[15]},
    e.${columna_empresa[16]}       
    FROM ${tabla_empresa} AS e 
    INNER JOIN ${tabla_usuario} AS u 
    ON u.${columna_usuario[5]}=e.${columna_empresa[0]} AND u.${columna_usuario[0]}=$idusuario
    ''';
    final res=await db.rawQuery(query);
    return res.isNotEmpty?EmpresaModel.fromJson(res.first):null;
  }

  Future<bool> getEsAdministrador(int idusuario)async{
    final db=await database;
    final res=await db.query(tabla_usuario,where: "${columna_usuario[0]}=? AND ${columna_usuario[4]}=1",whereArgs: [idusuario]);
    UsuarioModel usuarioModel=res.isNotEmpty?UsuarioModel.fromJson(res.first):null;
    if(usuarioModel!=null){
      return true;
    }else{
      return false;
    }
  }

  //Actualizar empresa
  Future<int>updateEmpresa(EmpresaModel empresaModel)async{
    final db=await database;
    final res=await db.update(tabla_empresa, empresaModel.toJson(),
    where: "${columna_empresa[0]}=?",whereArgs: [empresaModel.idempresa]);
    return res;
  }

  //Actualizar usuario
  Future<int>updateUsuario(String email,String password,int id)async{
    final db=await database;
    final res=await db.query(tabla_usuario,
    where: "${columna_usuario[2]}=? AND ${columna_usuario[3]}=?",
    whereArgs: [email,password]);
    UsuarioModel usuarioModel=res.isNotEmpty?UsuarioModel.fromJson(res.first):null;
    if(usuarioModel!=null){
      usuarioModel.idempresa=id;
      final resp=db.update(tabla_usuario,usuarioModel.toJson(),
      where: "${columna_usuario[0]}=?",whereArgs: [usuarioModel.idusuario]);
      return resp;
    }
    return 0;
  }
  Future<int> updateUsuarioAdministrador(UsuarioModel usuarioModel)async{
    final db=await database;
    final res=await db.update(tabla_usuario, usuarioModel.toJson(),where: "${columna_usuario[0]}=?",whereArgs: [usuarioModel.idusuario]);
    return res;
  }
  //Actualizar permisos de usuario
  Future<int> updatePermisoUsuario(UsuarioModel usuarioModel)async{
    final db=await database;
    final res=await db.update(tabla_usuario, usuarioModel.toJson(),where: "${columna_usuario[0]}=?",whereArgs: [usuarioModel.idusuario]);
    return res;

  }

  //Eliminar usuario
  Future<int> deleteUsuario(UsuarioModel usuarioModel)async{
    final db=await database;
    final res=await db.delete(tabla_usuario,where: "${columna_usuario[0]}=?",whereArgs: [usuarioModel.idusuario]);
    return res;
  }
  Future<int> updateProducto(ProductoModel productoModel)async{
    final db=await database;
    final res=await db.update(tabla_producto, productoModel.toJson(),where: "${columna_producto[0]}=?",whereArgs: [productoModel.idproducto]);
    return res;
  }

  //Obtener TODOS los clientes
  Future<List<ClienteModel>> obtenerClientes(int idempresa)async{
    final db=await database;
    final res=await db.query(tabla_cliente,where: "${columna_cliente[8]}=?",whereArgs: [idempresa]);
    return res.isNotEmpty?res.map((cliente) => ClienteModel.fromJson(cliente)).toList()
                        :[];
  }

  Future<List<ProductoModel>> searchProducto(int idEmpresa,String query)async{
    /*columna_producto=["idproducto","nombre","precio","urlimagen","isoferta","idempresa",
    "descripcion","activo","tipo","categoria","cantidad","create_at","upload_at"] */
    final db=await database;
    final res=await db.query(tabla_producto,where: "${columna_usuario[5]}=? AND ${columna_usuario[1]} LIKE ?",whereArgs: [idEmpresa,"%${query}%"]);
    return res.isNotEmpty?res.map((producto) => ProductoModel.fromJson(producto)).toList()
                          :[];
  }

  Future<List<ClienteModel>> searchCliente(int idEmpresa,String query)async{
    /*columna_cliente=["idcliente","nombre","apellido","email","telefono","limite_credito",
    "forma_pago","activo","idempresa","celular","telefono_oficina"];*/
    final db=await database;
    final res=await db.query(tabla_cliente,
    where: "${columna_cliente[8]}=? AND ${columna_cliente[1]} LIKE ? OR ${columna_cliente[2]} LIKE ?",whereArgs: [idEmpresa,"%${query}%","%${query}%"]);
    return res.isNotEmpty?res.map((cliente) => ClienteModel.fromJson(cliente)).toList()
                        :[];
  }

  Future<int> updateCliente(ClienteModel cliente)async{
    final db=await database;
    final res=await db.update(tabla_cliente,cliente.toJson(),where: "${columna_cliente[0]}=?",whereArgs: [cliente.idcliente]);
    return res;
  }

  Future<int> deleteCliente(int idCliente)async{
    final db=await database;
    final res=await db.delete(tabla_cliente,where: "${columna_cliente[0]}=?",whereArgs: [idCliente]);
    return res;
  }

  Future<List<CategoriaModel>> obtenerCategorias()async{

    final db=await database;
    final res=await db.query(tabla_producto,columns: ["${columna_producto[9]}"],groupBy: "${columna_producto[9]}");
    return res.isNotEmpty?res.map((categoria) => CategoriaModel.fromJson(categoria)).toList()
    :[];
  }

  Future<List<ProductoModel>> filterToCategory(int idEmpresa,String filtro)async{
    /*columna_producto=["idproducto","nombre","precio","urlimagen","isoferta","idempresa",
    "descripcion","activo","tipo","categoria","cantidad","create_at","upload_at"] */
    final db=await database;
    final res=await db.query(tabla_producto,
    where: "${columna_producto[5]}=? AND ${columna_producto[9]} LIKE ?",whereArgs: [idEmpresa,"%${filtro}%"]);
    return res.isNotEmpty?res.map((producto) => ProductoModel.fromJson(producto)).toList()
                        :[];
  }

  Future<List<FormaPagoModel>> obtenerPayment()async{
    /*columna_cliente=["idcliente","nombre","apellido","email","telefono","limite_credito",
    "forma_pago","activo","idempresa","celular","telefono_oficina"];*/
    final db=await database;
    final res=await db.query(tabla_cliente,columns: ["${columna_cliente[6]}"],
    groupBy: "${columna_cliente[6]}");
    return res.isNotEmpty?res.map((pago) => FormaPagoModel.fromJson(pago)).toList()
    :[];
  }

  Future<List<ClienteModel>> filterToPayment(int idEmpresa,String filter)async{
    final db=await database;
    final res=await db.query(tabla_cliente,where: "${columna_cliente[8]}=? AND ${columna_cliente[6]} LIKE ?",
    whereArgs: [idEmpresa,"%${filter}%"]);
    return res.isNotEmpty?res.map((cliente) => ClienteModel.fromJson(cliente)).toList()
    :[];
  }


  Future<List<ProductoModel>> filterAdvance(String query)async{
    final db=await database;
    final res=await db.rawQuery(query);
    return res.isNotEmpty?res.map((producto) => ProductoModel.fromJson(producto)).toList()
    :[];
  }

  Future<List<ClienteModel>> filterAdvanceCliente(String query)async{
    final db=await database;
    final res=await db.rawQuery(query);
    return res.isNotEmpty?res.map((cliente) => ClienteModel.fromJson(cliente)).toList()
    :[];
  }

  Future<double> getProductoStock(int idEmpresa)async{
    double stock=0.0;
    final res=await db.getTodosProductos(idEmpresa);
    if(res!=[]){
      res.forEach((producto) {
        stock++;
       });
    return stock;
    }else{
      return 0;
    }
  }

  Future<double> getProductoPrecioStock(int idEmpresa)async{
    double stock=0.0;
    final res=await db.getTodosProductos(idEmpresa);
    if(res!=[]){
      res.forEach((producto) {
        stock+=producto.cantidad*producto.precio;
       });
    return stock;
    }else{
      return 0;
    }
  }

  Future<double> getClientePotenciales(int idEmpresa)async{
    double cantidad=0.0;
    final res=await db.obtenerClientes(idEmpresa);
    if(res!=[]){
      res.forEach((cliente) {
        cantidad++;
       });
       return cantidad;
    }
    else{
      return 0;
    }
  }

  Future<List<ExistenciaPorTipoModel>> getExistenciaPorTipo(int idEmpresa)async{
    final db=await database;
    final res=await db.rawQuery("SELECT tipo,count(tipo) as valor FROM ${tabla_producto} WHERE idEmpresa=$idEmpresa GROUP BY tipo");
    return res.isNotEmpty?res.map((existencia) => ExistenciaPorTipoModel.fromJson(existencia)).toList()
    :[];
  }

  //Crear tipo producto
  Future<int> crearTipoProducto(TipoProductoModel tipoProductoModel)async{
    /*columna_tipo_producto=["tipo","arancel","foto","en_uso","preferido",
     "factor1","factor2","factor3","factor4",
     "factor5","principal","create_at","upload_at",
      "idempresa"]; */
    try{
      if(tipoProductoModel.tipo.isNotEmpty){
        final db=await database;
        final res=await db.insert(tabla_tipo_producto, tipoProductoModel.toJson());
        return res;
      }else{
        return 0;
      }
    }catch(Exception){
      return 0;
    }
  }

  //Obtener TODOS  tipo productos
  Future<List<TipoProductoModel>> getTodosTipoProductos(int idempresa)async{
    final db=await database;
    final res=await db.query(tabla_tipo_producto,where: "${columna_tipo_producto[13]}=?",whereArgs: [idempresa]);
    List<TipoProductoModel> list=res.isNotEmpty
                            ?res.map((tipo) => TipoProductoModel.fromJson(tipo)).toList()
                            :[];
    return list;
  }

  
}