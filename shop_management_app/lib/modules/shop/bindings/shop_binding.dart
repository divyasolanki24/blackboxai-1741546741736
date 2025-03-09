import 'package:get/get.dart';
import 'package:shop_management_app/modules/shop/controllers/shop_controller.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopController>(() => ShopController());
  }
}
