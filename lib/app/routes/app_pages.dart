

import 'package:correiobarcode/app/modules/home/home.dart';
import 'package:correiobarcode/app/modules/home/home_binding.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

abstract class AppPages {
  static final pages = [
     GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBindding() ,transition: Transition.zoom),
  ];
  }