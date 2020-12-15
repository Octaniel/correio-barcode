// import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image/image.dart' as im;
import 'package:barcode_image/barcode_image.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:printing/printing.dart';

import 'widgets/share_js.dart';

class HomeController extends GetxController {
  var storage = GetStorage();

  // File img1;
  List<BarCodeImage<BarCodeParams>> barCodesImage = List();
  BarCodeImage<BarCodeParams> barCodeImage;
  Uint8List savePdf;
  var savePdfS = "".obs;
  var dd = ''.obs;
  int quantidade = 1;
  var _barCodeImageUltimo = BarCodeImage<BarCodeParams>(
    params: Code39BarCodeParams(
      'RRST',
      lineWidth: 2.0,
      barHeight: 80.0,
      withText: true,
    ),
  ).obs;

  BarCodeImage<BarCodeParams> get barCodeImageUltimo =>
      _barCodeImageUltimo.value;

  set barCodeImageUltimo(BarCodeImage<BarCodeParams> value) {
    _barCodeImageUltimo.value = value;
    update(['barCodeImageUltimo']);
  }

  Future<void> buildBarcode(
    Barcode bc, {
    String filename,
  }) async {
    GetStorage();
    String data = storage.read('ultimo');
    if (data == null) data = '000339006';
    var dataInt = int.parse(data) + 1;
    data = '$dataInt';
    for (int o = data.length; o < 9; o++) {
      data = '0' + data;
    }
    final pdf = pw.Document();
    // final Directory directory =
    //     await path_provider.getApplicationDocumentsDirectory();
    // final String path = directory.path;
    quantidade=quantidade%2==0?quantidade:quantidade+1;
    barCodesImage = List();
    for (int i = 0; i < quantidade; i++) {
      var dataInt = int.parse(data) + i;
      String data1 = '$dataInt';
      for (int o = data1.length; o < 9; o++) {
        data1 = '0' + data1;
      }
      barCodeImage = BarCodeImage(
        params: Code39BarCodeParams(
          'RR${data1}ST',
          lineWidth: 2.0,
          barHeight: 80.0,
          withText: true,
        ),
        onError: (error) {
          print('error = $error');
        },
      );
      barCodesImage.add(barCodeImage);
    }

    for (int i = 0; i < quantidade; i = i + 2) {
      var dataInt = int.parse(data) + i;
      var w = i + 1 >= quantidade ? -1 : i + 1;
      var dataInt1 = int.parse(data) + w;
      String data1 = '$dataInt';
      String data2 = '$dataInt1';
      for (int o = data1.length; o < 9; o++) {
        data1 = '0' + data1;
      }
      for (int o = data2.length; o < 9; o++) {
        data2 = '0' + data2;
      }

      // var fil = file(data1);
      var barcodeWidget =
          pw.BarcodeWidget(barcode: bc, data: data1, height: 50, width: 800);
      // var fil1 = file(data2);
      var barcodeWidget2 =
          pw.BarcodeWidget(barcode: bc, data: data2, height: 50, width: 800);

      // final image = PdfImage.file(
      //   pdf.document,
      //   bytes: fil.readAsBytesSync(),
      // );
      // final image1 = PdfImage.file(
      //   pdf.document,
      //   bytes: fil1.readAsBytesSync(),
      // );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context context) {
            return pw.ListView(children: [
              center('RR${data1}ST'),
              pw.Text('--------------------------------------------'),
              pw.SizedBox(height: 5),
              w > -1 ? center('RR${data2}ST') : pw.Text(''),
            ]); // Center
          },
        ),
      );
      storage.write('ultimo', w > -1 ? data2 : data1);
      pegarUltimo();
      dd.value = w > -1 ? data2 : data1;
    }

    // img1 = File('$path/$filename.pdf');
    // img1.writeAsBytesSync(pdf.save());
    // path = img1.path;
    // print('${img1.path}');


    savePdf = pdf.save();
    savePdfS.value = data;
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) {
        return savePdf;
      },
      name: 'RR000339006ST',
      format: PdfPageFormat.roll80,
    );
    share(
        bytes: savePdf,
        filename: '$filename.pdf',
        mimetype: 'application/pdf');
    update();
  }

  create(int quantidade) {
    for (int i = 0; i < quantidade; i++) {}
  }

  center(String data) {
    return pw.Center(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Container(
            padding: pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              borderRadius: 3,
              border:
                  pw.BoxBorder(width: 2, color: PdfColor.fromInt(0xFF2083D5)),
            ),
            child: pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.SizedBox(width: 12),
                    pw.Column(
                      children: [
                        pw.Text('B-Software:',
                            style: pw.TextStyle(fontSize: 8),
                            textAlign: pw.TextAlign.left),
                        pw.Text('www.b-software.st',
                            style: pw.TextStyle(fontSize: 8)),
                        pw.Text('info@b-software.st',
                            style: pw.TextStyle(fontSize: 8)),
                      ],
                    ),
                    pw.SizedBox(width: 5),
                    pw.Container(
                      height: 25,
                      decoration: pw.BoxDecoration(
                        border: pw.BoxBorder(
                          left: true,
                          width: 1,
                          color: PdfColor.fromInt(0xFF2083D5),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 5),
                    pw.Column(children: [
                      pw.Text(
                        'lettres - services spéciaux',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                      pw.Text(
                        'letters - special services',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                    ]),
                  ],
                ),
                // pw.SizedBox(height: 5),
                pw.BarcodeWidget(
                    barcode: Barcode.code39(),
                    data: data,
                    height: 40,
                    width: 800),
                pw.Text('--------------------------------------------'),
                pw.BarcodeWidget(
                    barcode: Barcode.code39(),
                    data: data,
                    height: 40,
                    width: 800),
                pw.Text('--------------------------------------------'),
                pw.BarcodeWidget(
                    barcode: Barcode.code39(),
                    data: data,
                    height: 40,
                    width: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // File file(String data) {
  //   final imag = im.Image(800, 150);
  //   im.fill(imag, im.getColor(255, 255, 255));
  //   drawBarcode(imag, Barcode.code39(), 'RR${data}ST', font: im.arial_48);
  //   var fil = File('$data.png');
  //   fil.writeAsBytesSync(im.encodePng(imag));
  //   return fil;
  // }

  pegarUltimo() {
    var read = storage.read<String>('ultimo');
    if (read != null)
      barCodeImageUltimo = BarCodeImage(
        params: Code39BarCodeParams(
          'RR${read}ST',
          lineWidth: 2.0,
          barHeight: 80.0,
          withText: true,
        ),
        onError: (error) {
          print('error = $error');
        },
      );
  }

  mudarUltimo(String ultimo) {
    try {
      int.parse(ultimo);
      if (ultimo.length != 9) {
        Get.rawSnackbar(
            icon: Icon(
              FontAwesomeIcons.times,
              color: Colors.white,
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFFFE3C3C),
            messageText: Text(
              'Número invado, o número deve ter 9 digitos',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            borderRadius: 10,
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20));
      } else {
        storage.write('ultimo', ultimo);
        barCodeImageUltimo = BarCodeImage(
          params: Code39BarCodeParams(
            'RR${ultimo}ST',
            lineWidth: 2.0,
            barHeight: 80.0,
            withText: true,
          ),
          onError: (error) {
            print('error = $error');
          },
        );
        dd.value = ultimo;
        update(['barCodeImageUltimo']);
      }
    } catch (e) {
      Get.rawSnackbar(
          icon: Icon(
            FontAwesomeIcons.times,
            color: Colors.white,
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFFFE3C3C),
          messageText: Text(
            'Número invado, por favor verifique o número e tente novamente',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          borderRadius: 10,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20));
    }
  }

  @override
  void onInit() {
    pegarUltimo();
    super.onInit();
  }
}
