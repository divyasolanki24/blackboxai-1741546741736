import 'package:get/get.dart';
import 'package:shop_management_app/models/shop.dart';
import 'package:shop_management_app/repositories/shop_repository.dart';
import 'package:shop_management_app/core/controllers/auth_controller.dart';

class ShopController extends GetxController {
  // Dependencies
  final _shopRepository = Get.find<ShopRepository>();
  final _authController = Get.find<AuthController>();

  // Observable state
  final shops = <Shop>[].obs;
  final filteredShops = <Shop>[].obs;
  final isLoading = false.obs;
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;

  // Analytics
  final totalRevenue = 0.0.obs;
  final activeShopCount = 0.obs;
  final totalProducts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadShops();
    // Listen to repository changes
    ever(_shopRepository.items, (_) => updateShopList());
  }

  Future<void> loadShops() async {
    try {
      isLoading.value = true;
      await _shopRepository.getAll();
      updateShopList();
      updateAnalytics();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load shops: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateShopList() {
    // Apply filters and search
    var result = List<Shop>.from(_shopRepository.items);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      result = _shopRepository.searchShops(searchQuery.value);
    }

    // Apply status filter
    switch (selectedFilter.value) {
      case 'Active':
        result = result.where((shop) => shop.isActive).toList();
        break;
      case 'Inactive':
        result = result.where((shop) => !shop.isActive).toList();
        break;
    }

    // Sort shops by name
    result.sort((a, b) => a.name.compareTo(b.name));

    shops.assignAll(result);
  }

  void searchShops(String query) {
    searchQuery.value = query;
    updateShopList();
  }

  void filterShops(String? filter) {
    if (filter != null) {
      selectedFilter.value = filter;
      updateShopList();
    }
  }

  Future<void> createShop(Shop shop) async {
    try {
      if (!_hasPermission('shop.write')) {
        throw 'Insufficient permissions';
      }

      isLoading.value = true;
      await _shopRepository.create(shop);
      Get.snackbar(
        'Success',
        'Shop created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back(); // Return to shop list
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create shop: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateShop(String id, Shop shop) async {
    try {
      if (!_hasPermission('shop.write')) {
        throw 'Insufficient permissions';
      }

      isLoading.value = true;
      await _shopRepository.update(id, shop);
      Get.snackbar(
        'Success',
        'Shop updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back(); // Return to shop list or detail
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update shop: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteShop(String id) async {
    try {
      if (!_hasPermission('shop.delete')) {
        throw 'Insufficient permissions';
      }

      isLoading.value = true;
      await _shopRepository.delete(id);
      Get.snackbar(
        'Success',
        'Shop deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete shop: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleShopStatus(String id, bool isActive) async {
    try {
      if (!_hasPermission('shop.write')) {
        throw 'Insufficient permissions';
      }

      final shop = shops.firstWhere((shop) => shop.id == id);
      await _shopRepository.updateShopStatus(id, isActive);
      
      Get.snackbar(
        'Success',
        'Shop status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update shop status: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateAnalytics() async {
    try {
      activeShopCount.value = shops.where((shop) => shop.isActive).length;
      
      // Calculate total revenue and products
      var revenue = 0.0;
      var products = 0;
      
      for (final shop in shops) {
        final analytics = await _shopRepository.getShopAnalytics(shop.id);
        revenue += (analytics['totalSales'] ?? 0.0) as double;
        products += (analytics['totalProducts'] ?? 0) as int;
      }
      
      totalRevenue.value = revenue;
      totalProducts.value = products;
    } catch (e) {
      print('Error updating analytics: $e');
    }
  }

  // Permission helpers
  bool _hasPermission(String permission) {
    return _authController.user.value?.hasPermission(permission) ?? false;
  }

  bool get canCreateShop => _hasPermission('shop.write');
  bool get canEditShop => _hasPermission('shop.write');
  bool get canDeleteShop => _hasPermission('shop.delete');
  bool get canViewAnalytics => _hasPermission('shop.read');
}
