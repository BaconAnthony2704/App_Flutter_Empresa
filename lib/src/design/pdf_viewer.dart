import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPreviweScreen extends StatefulWidget{
  final String path;

  const PdfPreviweScreen({Key key, this.path}) : super(key: key);

  @override
  _PdfPreviweScreenState createState() => _PdfPreviweScreenState();
}

class _PdfPreviweScreenState extends State<PdfPreviweScreen> {
  @override
  Widget build(BuildContext context) {
    final pw.Document pdf=ModalRoute.of(context).settings.arguments;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Vista previa"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.print), onPressed: ()async{
            await Printing.layoutPdf(onLayout: (PdfPageFormat format)async=>pdf.save());
          }),
          IconButton(icon: Icon(Icons.share), onPressed: ()async{
            await Printing.sharePdf(bytes: pdf.save(),filename: "document_${DateTime.now().toIso8601String()}.pdf");
          }),
        ],
      ),
      body: PDFView(filePath: widget.path),
    );
  }
}