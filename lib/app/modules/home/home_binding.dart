import 'package:correiobarcode/app/modules/home/home_controller.dart';
import 'package:get/get.dart';

class HomeBindding extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
  }

}