import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{
  static final PreferenciasUsuario _instancia=new PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){
    return _instancia;
  }
  PreferenciasUsuario._internal();

  SharedPreferences _prefs;
  initPrefs() async{
    this._prefs=await SharedPreferences.getInstance();
  }
  //set y get de la ultima pagina
  get ultimaPagina{
    return _prefs.getString('ultimaPagina')??'login';
  }
  set ultimaPagina(String value){
    _prefs.setString('ultimaPagina', value);
  }

  //set y get de color de tema
  get tema{
    return _prefs.getInt('tema')??0;
  }
  set tema(int value){
    _prefs.setInt('tema', value);
  }

  //set y get de idusuario
  get idusuario{
    return _prefs.getInt('idusuario')??0;
  }
  set idusuario(int value){
    _prefs.setInt('idusuario', value);
  }
}
