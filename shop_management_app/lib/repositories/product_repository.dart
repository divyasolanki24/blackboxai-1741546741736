import 'package:get/get.dart';
import 'package:shop_management_app/models/product.dart';
import 'package:shop_management_app/models/inventory.dart';
import 'package:shop_management_app/repositories/base_repository.dart';
import 'package:shop_management_app/repositories/inventory_repository.dart';

class ProductRepository extends BaseRepository<Product> {
  // Singleton instance
  static final ProductRepository _instance = ProductRepository._internal();
  factory ProductRepository() => _instance;
  ProductRepository._internal();

  // Dependencies
  final _inventoryRepository = Get.find<InventoryRepository>();

  // Additional product-specific state
  final RxMap<String, List<Product>> shopProducts = <String, List<Product>>{}.obs;
  final RxMap<String, int> categoryProductCounts = <String, int>{}.obs;
  final RxList<String> categories = <String>[].obs;

  @override
  String getItemId(Product item) => item.id;

  @override
  Future<void> create(Product product) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      addToCache(product);
      updateProductLists(product);
      
      // Create initial inventory for the product
      await _inventoryRepository.initializeInventory(
        product.id,
        product.shopId,
        initialQuantity: product.stockQuantity,
      );
    });
  }

  @override
  Future<void> update(String id, Product product) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      updateInCache(id, product);
      updateProductLists(product);
      
      // Update inventory if stock quantity changed
      final oldProduct = items.firstWhere((p) => p.id == id);
      if (oldProduct.stockQuantity != product.stockQuantity) {
        await _inventoryRepository.adjustInventory(
          product.id,
          product.shopId,
          product.stockQuantity - oldProduct.stockQuantity,
          'Product Update',
        );
      }
    });
  }

  @override
  Future<void> delete(String id) async {
    await withLoading(() async {
      final product = await getById(id);
      if (product != null) {
        // TODO: Implement API call
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        removeFromCache(id);
        removeFromProductLists(product);
        
        // Delete associated inventory
        await _inventoryRepository.deleteProductInventory(id);
      }
    });
  }

  @override
  Future<Product?> getById(String id) async {
    try {
      setLoading(true);
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return items.firstWhereOrNull((product) => product.id == id);
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<List<Product>> getAll() async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simulated data
      final products = [
        Product(
          id: '1',
          shopId: '1',
          name: 'Sample Product 1',
          description: 'Description for product 1',
          price: 99.99,
          stockQuantity: 100,
          category: 'Electronics',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Product(
          id: '2',
          shopId: '1',
          name: 'Sample Product 2',
          description: 'Description for product 2',
          price: 149.99,
          stockQuantity: 50,
          category: 'Electronics',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      updateCache(products);
      updateAllProductLists();
      return products;
    });
    return items;
  }

  // Product-specific methods
  Future<List<Product>> getShopProducts(String shopId) async {
    return items.where((product) => product.shopId == shopId).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    return items.where((product) => product.category == category).toList();
  }

  Future<void> updateStock(String productId, int quantity) async {
    final product = await getById(productId);
    if (product != null) {
      await update(
        productId,
        product.copyWith(stockQuantity: quantity),
      );
    }
  }

  // Category management
  void updateCategories() {
    final uniqueCategories = items.map((p) => p.category).toSet().toList();
    categories.assignAll(uniqueCategories);
    
    // Update category counts
    categoryProductCounts.clear();
    for (final category in uniqueCategories) {
      categoryProductCounts[category] = items
          .where((p) => p.category == category)
          .length;
    }
  }

  // Product list management
  void updateProductLists(Product product) {
    // Update shop products
    final shopProductList = shopProducts[product.shopId] ?? [];
    final existingIndex = shopProductList.indexWhere((p) => p.id == product.id);
    
    if (existingIndex >= 0) {
      shopProductList[existingIndex] = product;
    } else {
      shopProductList.add(product);
    }
    shopProducts[product.shopId] = shopProductList;

    updateCategories();
  }

  void removeFromProductLists(Product product) {
    // Remove from shop products
    final shopProductList = shopProducts[product.shopId] ?? [];
    shopProductList.removeWhere((p) => p.id == product.id);
    shopProducts[product.shopId] = shopProductList;

    updateCategories();
  }

  void updateAllProductLists() {
    // Group products by shop
    shopProducts.clear();
    for (final product in items) {
      final shopProductList = shopProducts[product.shopId] ?? [];
      shopProductList.add(product);
      shopProducts[product.shopId] = shopProductList;
    }

    updateCategories();
  }

  // Search and filter methods
  List<Product> searchProducts(String query) {
    return search(query, (product, query) {
      final searchTerm = query.toLowerCase();
      return product.name.toLowerCase().contains(searchTerm) ||
          product.description.toLowerCase().contains(searchTerm) ||
          product.category.toLowerCase().contains(searchTerm);
    });
  }

  List<Product> filterByPriceRange(double minPrice, double maxPrice) {
    return items.where((product) =>
      product.price >= minPrice && product.price <= maxPrice
    ).toList();
  }

  List<Product> filterByStock(StockStatus status) {
    return items.where((product) => product.stockStatus == status).toList();
  }

  // Sorting methods
  void sortByPrice({bool ascending = true}) {
    sort((a, b) => ascending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
  }

  void sortByStock({bool ascending = true}) {
    sort((a, b) => ascending
        ? a.stockQuantity.compareTo(b.stockQuantity)
        : b.stockQuantity.compareTo(a.stockQuantity));
  }

  // Analytics
  Map<String, dynamic> getProductAnalytics() {
    return {
      'totalProducts': items.length,
      'totalCategories': categories.length,
      'averagePrice': items.isEmpty ? 0 : 
        items.map((p) => p.price).reduce((a, b) => a + b) / items.length,
      'lowStockProducts': items.where((p) => p.stockStatus == StockStatus.critical).length,
      'outOfStockProducts': items.where((p) => p.stockStatus == StockStatus.outOfStock).length,
    };
  }

  // Export/Import
  Future<String> exportToJson() async {
    try {
      final exportData = items.map((product) => product.toJson()).toList();
      // TODO: Implement actual export logic
      return '';
    } catch (e) {
      handleError(e);
      return '';
    }
  }

  Future<void> importFromJson(String jsonData) async {
    try {
      // TODO: Implement actual import logic
      await getAll(); // Refresh data after import
    } catch (e) {
      handleError(e);
    }
  }
}
