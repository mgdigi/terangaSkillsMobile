import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../../../modules/auth/controller/auth_controller.dart';
import '../../../modules/missing_docs/controller/missing_docs_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    // AuthController is now globally registered in InitialBinding
    // Register MissingDocsController for the carousel on home
    if (!Get.isRegistered<MissingDocsController>()) {
      Get.put<MissingDocsController>(MissingDocsController());
    }
  }
}
