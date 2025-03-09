import 'package:get/get.dart';
import 'package:shop_management_app/models/inventory.dart';
import 'package:shop_management_app/repositories/base_repository.dart';

class InventoryRepository extends BaseRepository<Inventory> {
  // Singleton instance
  static final InventoryRepository _instance = InventoryRepository._internal();
  factory InventoryRepository() => _instance;
  InventoryRepository._internal();

  // Additional inventory-specific state
  final RxMap<String, List<Inventory>> shopInventories = <String, List<Inventory>>{}.obs;
  final RxMap<String, InventoryStatus> productStockStatus = <String, InventoryStatus>{}.obs;
  final RxList<InventoryTransaction> recentTransactions = <InventoryTransaction>[].obs;

  @override
  String getItemId(Inventory item) => item.id;

  @override
  Future<void> create(Inventory inventory) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      addToCache(inventory);
      updateInventoryLists(inventory);
    });
  }

  @override
  Future<void> update(String id, Inventory inventory) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      updateInCache(id, inventory);
      updateInventoryLists(inventory);
    });
  }

  @override
  Future<void> delete(String id) async {
    await withLoading(() async {
      final inventory = await getById(id);
      if (inventory != null) {
        // TODO: Implement API call
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        removeFromCache(id);
        removeFromInventoryLists(inventory);
      }
    });
  }

  @override
  Future<Inventory?> getById(String id) async {
    try {
      setLoading(true);
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return items.firstWhereOrNull((inventory) => inventory.id == id);
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<List<Inventory>> getAll() async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simulated data
      final inventories = [
        Inventory(
          id: '1',
          shopId: '1',
          productId: '1',
          quantity: 100,
          minimumStock: 10,
          maximumStock: 200,
          lastRestockDate: DateTime.now(),
          transactions: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      updateCache(inventories);
      updateAllInventoryLists();
      return inventories;
    });
    return items;
  }

  // Inventory-specific methods
  Future<void> initializeInventory(
    String productId,
    String shopId, {
    int initialQuantity = 0,
    int minimumStock = 10,
    int maximumStock = 100,
  }) async {
    final inventory = Inventory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      shopId: shopId,
      productId: productId,
      quantity: initialQuantity,
      minimumStock: minimumStock,
      maximumStock: maximumStock,
      lastRestockDate: DateTime.now(),
      transactions: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await create(inventory);
  }

  Future<void> adjustInventory(
    String productId,
    String shopId,
    int adjustment,
    String reason, {
    String? reference,
    String? notes,
    String? userId,
  }) async {
    final inventory = await getProductInventory(productId, shopId);
    if (inventory != null) {
      final transaction = InventoryTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: adjustment > 0 ? TransactionType.adjustment : TransactionType.adjustment,
        quantity: adjustment.abs(),
        reference: reference,
        notes: notes,
        date: DateTime.now(),
        userId: userId ?? 'system',
      );

      final updatedInventory = inventory.copyWith(
        quantity: inventory.quantity + adjustment,
        transactions: [...inventory.transactions, transaction],
        lastRestockDate: adjustment > 0 ? DateTime.now() : inventory.lastRestockDate,
      );

      await update(inventory.id, updatedInventory);
      recentTransactions.insert(0, transaction);
      if (recentTransactions.length > 100) {
        recentTransactions.removeLast();
      }
    }
  }

  Future<void> deleteProductInventory(String productId) async {
    final inventories = items.where((inv) => inv.productId == productId).toList();
    for (final inventory in inventories) {
      await delete(inventory.id);
    }
  }

  // Inventory list management
  void updateInventoryLists(Inventory inventory) {
    // Update shop inventories
    final shopInventoryList = shopInventories[inventory.shopId] ?? [];
    final existingIndex = shopInventoryList.indexWhere((inv) => inv.id == inventory.id);
    
    if (existingIndex >= 0) {
      shopInventoryList[existingIndex] = inventory;
    } else {
      shopInventoryList.add(inventory);
    }
    shopInventories[inventory.shopId] = shopInventoryList;

    // Update product stock status
    productStockStatus[inventory.productId] = inventory.status;
  }

  void removeFromInventoryLists(Inventory inventory) {
    // Remove from shop inventories
    final shopInventoryList = shopInventories[inventory.shopId] ?? [];
    shopInventoryList.removeWhere((inv) => inv.id == inventory.id);
    shopInventories[inventory.shopId] = shopInventoryList;

    // Remove product stock status
    productStockStatus.remove(inventory.productId);
  }

  void updateAllInventoryLists() {
    // Group inventories by shop
    shopInventories.clear();
    productStockStatus.clear();
    
    for (final inventory in items) {
      final shopInventoryList = shopInventories[inventory.shopId] ?? [];
      shopInventoryList.add(inventory);
      shopInventories[inventory.shopId] = shopInventoryList;
      
      productStockStatus[inventory.productId] = inventory.status;
    }
  }

  // Query methods
  Future<Inventory?> getProductInventory(String productId, String shopId) async {
    return items.firstWhereOrNull(
      (inventory) => inventory.productId == productId && inventory.shopId == shopId,
    );
  }

  Future<List<Inventory>> getShopInventory(String shopId) async {
    return items.where((inventory) => inventory.shopId == shopId).toList();
  }

  List<Inventory> getLowStockInventories() {
    return items.where((inventory) => inventory.needsRestock).toList();
  }

  // Analytics
  Map<String, dynamic> getInventoryAnalytics(String shopId) {
    final shopInventoryList = shopInventories[shopId] ?? [];
    
    return {
      'totalItems': shopInventoryList.length,
      'lowStockItems': shopInventoryList.where((inv) => inv.needsRestock).length,
      'outOfStockItems': shopInventoryList.where((inv) => inv.quantity <= 0).length,
      'overstockedItems': shopInventoryList.where((inv) => inv.isOverstocked).length,
    };
  }

  // Transaction history
  List<InventoryTransaction> getTransactionHistory(
    String productId,
    String shopId, {
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
  }) {
    final inventory = items.firstWhhere(
      (inv) => inv.productId == productId && inv.shopId == shopId,
    );

    if (inventory == null) return [];

    var transactions = inventory.transactions;

    if (startDate != null) {
      transactions = transactions.where((t) => t.date.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      transactions = transactions.where((t) => t.date.isBefore(endDate)).toList();
    }

    if (type != null) {
      transactions = transactions.where((t) => t.type == type).toList();
    }

    return transactions;
  }

  // Export/Import
  Future<String> exportToJson() async {
    try {
      final exportData = items.map((inventory) => inventory.toJson()).toList();
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
