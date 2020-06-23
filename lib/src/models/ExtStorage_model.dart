import 'package:ext_storage/ext_storage.dart';

class RutaExternal{

  final String ruta;
  final String rutaNativa;

  RutaExternal({this.ruta, this.rutaNativa});

  Future<List<RutaExternal>> obtenerListaDirectorio()async{

    final ruta1=new RutaExternal(
      ruta: "Musica",
      rutaNativa: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_MUSIC),
    );

    final ruta2=new RutaExternal(
      ruta: "Alarma",
      rutaNativa: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_ALARMS)
    );

    final ruta3=new RutaExternal(
      ruta: "Imagenes",
      rutaNativa: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_PICTURES)
    );

    final ruta4=new RutaExternal(
      ruta: "Descargas",
      rutaNativa: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS)
    );

    final ruta5=new RutaExternal(
      ruta: "DCIM",
      rutaNativa: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DCIM)
    );

    final ruta6=new RutaExternal(
      ruta: "Documentos",
      rutaNativa: await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOCUMENTS)
    );

    List<RutaExternal> lista=new List();
    lista.addAll([
      ruta1,ruta2,ruta3,ruta4,ruta5,ruta6
    ]);
    return lista;
  }

}