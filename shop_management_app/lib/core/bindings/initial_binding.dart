import 'package:get/get.dart';
import 'package:shop_management_app/core/controllers/auth_controller.dart';
import 'package:shop_management_app/core/controllers/theme_controller.dart';
import 'package:shop_management_app/repositories/shop_repository.dart';
import 'package:shop_management_app/repositories/product_repository.dart';
import 'package:shop_management_app/repositories/inventory_repository.dart';
import 'package:shop_management_app/repositories/user_repository.dart';
import 'package:shop_management_app/repositories/role_repository.dart';
import 'package:shop_management_app/repositories/module_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register core controllers
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);

    // Register repositories
    Get.put(ShopRepository(), permanent: true);
    Get.put(ProductRepository(), permanent: true);
    Get.put(InventoryRepository(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(RoleRepository(), permanent: true);
    Get.put(ModuleRepository(), permanent: true);

    // Initialize repositories
    _initializeRepositories();
  }

  Future<void> _initializeRepositories() async {
    try {
      // Initialize repositories in order of dependencies
      await Get.find<RoleRepository>().getAll();
      await Get.find<UserRepository>().getAll();
      await Get.find<ShopRepository>().getAll();
      await Get.find<ProductRepository>().getAll();
      await Get.find<InventoryRepository>().getAll();
      await Get.find<ModuleRepository>().getAll();
    } catch (e) {
      print('Error initializing repositories: $e');
    }
  }
}
