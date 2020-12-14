import 'package:barcode/barcode.dart';
import 'package:correiobarcode/app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
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
                        'Ultimo imprenso',
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
                        onChanged: (v) {
                          controller.dd.value = '';
                          controller.update();
                        },
                        onSubmitted: (v) {
                          controller.mudarUltimo(v);
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: 'Último número',
                          helperText:
                              'Digite o número do ultimo codigo de barra, se o que esta em cima não for o ultimo',
                          hintText: 'Número do ultimo codigo de barra',
                          // contentPadding: EdgeInsets.all(5)
                        ),
                      ),
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
                            var parse = int.parse(v);
                            controller.quantidade = parse;
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
                          onPressed: () {
                            controller.buildBarcode(
                              Barcode.code93(),
                              filename: 'RR000339006ST',
                            );
                          },
                          child: Text('Gerar codigo'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Container(
                      //   height: 100,
                      //   child: PdfPreview(build: (PdfPageFormat format) {
                      //     return controller.img1.readAsBytesSync();
                      //   },),
                      // ),
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
