import 'package:barcode/barcode.dart';
import 'package:correiobarcode/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class HomePage extends GetView<HomeController> {
  String value = "";
  TextEditingController controler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2083D5),
        title: Text('Post Office Bar Code'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: Get.width * .3,
                  height: Get.height * .75,
                  alignment: Alignment.center,
                  child: ListView(
                    children: [
                      Text(
                        'Regularização',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Ultimo impresso',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      GetBuilder<HomeController>(
                        builder: (_) {
                          return Column(
                            children: [
                              Text(
                                controller.dd.value,
                                style: TextStyle(color: Colors.transparent),
                              ),
                              controller.barCodeImageUltimo,
                            ],
                          );
                          // return controller.dd.value!=0
                          //     ? controller.barCodeImageUltimo
                          //     : Text('');
                        },
                        id: 'barCodeImageUltimo',
                      ),
                      TextField(
                        controller: controler,
                        onChanged: (v) {
                          controller.dd.value = '';
                          value = v;
                          controller.update();
                        },
                        onSubmitted: (v) {
                          controller.mudarUltimo(v);
                          controler.text = '';
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: 'Último número',
                          helperText:
                              'Digite o número do ultimo codigo de barra, se o que esta em \ncima não for o ultimo',
                          hintText: 'Número do ultimo codigo de barra',
                          // contentPadding: EdgeInsets.all(5)
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          controller.mudarUltimo(value);
                          controler.text = '';
                        },
                        child: Container(
                          height: 30,
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Atualizar ultimo codigo')
                              ],
                            ),
                          ),
                        ),
                      ),
                      // RaisedButton(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: Get.width * .2, vertical: 600),
                      //   onPressed: () async {
                      //     controller.mudarUltimo(value);
                      //   },
                      //   child: Text('Atualizar ultimo codigo'),
                      // ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 1,
                    height: Get.height * .75,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF2083D5))),
                  ),
                ),
                Container(
                  width: Get.width * .45,
                  height: Get.height * .75,
                  alignment: Alignment.center,
                  child: ListView(
                    children: [
                      Text(
                        'Criar codigo',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          try {
                            if (v.isNotEmpty) {
                              var parse = int.parse(v);
                              controller.quantidade = parse;
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
                                  'Número invado, aqui só deve ser inserido números',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                borderRadius: 10,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 20));
                          }
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: 'Quantidade a ser gerado',
                          hintText: 'Quantidade',
                          // contentPadding: EdgeInsets.all(5)
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: Get.width * .1),
                        child: RaisedButton(
                          onPressed: () async {
                            controller.buildBarcode(
                              Barcode.code39(),
                              filename: 'RR000339006ST',
                            );
                          },
                          child: Text('Gerar codigo'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // GetBuilder<HomeController>(
                      //   builder: (_) {
                      //     return controller.savePdfS.value.isNotEmpty?Container(
                      //       height: 500,
                      //       child: PdfPreview(
                      //         build: (PdfPageFormat format) {
                      //           return controller.savePdf;
                      //         },
                      //       ),
                      //     ):Container();
                      //   },
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
