class CodigoPostal{
  int idCodigo;
  String codigoPostal;
  String pais;

  CodigoPostal({
    this.idCodigo,
    this.codigoPostal,
    this.pais
  });

  List<CodigoPostal> obtenerListaCodigoPostal(){
    List<CodigoPostal> lista=[];
    final cod1=new CodigoPostal(
      idCodigo: 1,
      codigoPostal: "+503",
      pais: "El Salvador",
    );

    final cod2=new CodigoPostal(
      idCodigo: 2,
      codigoPostal: "+502",
      pais: "Guatemala"
    );

    final cod3=new CodigoPostal(
      idCodigo: 3,
      codigoPostal: "+501",
      pais: "Belize"
    );

    final cod4=new CodigoPostal(
      idCodigo: 4,
      codigoPostal: "+504",
      pais: "Honduras"
    );
    final cod5=new CodigoPostal(
      idCodigo: 5,
      codigoPostal: "+505",
      pais: "Nicaragua"
    );
    final cod6=new CodigoPostal(
      idCodigo: 6,
      codigoPostal: "+506",
      pais: "Costa Rica"
    );

    final cod7=new CodigoPostal(
      idCodigo: 7,
      codigoPostal: "+507",
      pais: "Panama"
    );
    lista.addAll([
      cod1,
      cod2,
      cod3,
      cod4,
      cod5,
      cod6,
      cod7
    ]);
    return lista;
  }
}