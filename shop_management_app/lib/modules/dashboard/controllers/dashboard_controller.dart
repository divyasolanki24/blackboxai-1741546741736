import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shop_management_app/repositories/shop_repository.dart';
import 'package:shop_management_app/repositories/product_repository.dart';
import 'package:shop_management_app/repositories/inventory_repository.dart';

class DashboardController extends GetxController {
  // Dependencies
  final _shopRepository = Get.find<ShopRepository>();
  final _productRepository = Get.find<ProductRepository>();
  final _inventoryRepository = Get.find<InventoryRepository>();

  // Observable state
  final isLoading = true.obs;
  final totalRevenue = 0.0.obs;
  final totalShops = 0.obs;
  final activeShops = 0.obs;
  final totalProducts = 0.obs;
  final lowStockProducts = 0.obs;

  // Server data for charts
  final serverASpots = <FlSpot>[].obs;
  final serverBSpots = <FlSpot>[].obs;
  final serverData = Rx<ServerData>(
    ServerData(fleetServers: 0, downServers: 0, running: 0),
  );
  final recentProblems = <Problem>[].obs;

  // Memory usage
  final totalMemory = 0.obs;
  final usedMemory = 0.obs;
  final memoryGrowth = 0.0.obs;
  final visitorGrowth = 0.0.obs;
  final userGrowth = 0.0.obs;
  final newUsers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    setupChartData();
    setupServerData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Load shop statistics
      final shops = await _shopRepository.getAll();
      totalShops.value = shops.length;
      activeShops.value = shops.where((shop) => shop.isActive).length;

      // Calculate total revenue
      var revenue = 0.0;
      for (final shop in shops) {
        final analytics = await _shopRepository.getShopAnalytics(shop.id);
        revenue += (analytics['totalSales'] ?? 0.0) as double;
      }
      totalRevenue.value = revenue;

      // Load product statistics
      final products = await _productRepository.getAll();
      totalProducts.value = products.length;

      // Load inventory statistics
      final inventories = await _inventoryRepository.getAll();
      lowStockProducts.value = inventories.where((inv) => inv.needsRestock).length;

      // Simulated growth rates
      memoryGrowth.value = 15.5;
      visitorGrowth.value = -2.3;
      userGrowth.value = 8.4;

      // Simulated memory usage
      totalMemory.value = 32;
      usedMemory.value = 24;
      newUsers.value = 156;

    } catch (e) {
      print('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setupChartData() {
    // Simulated server request data
    serverASpots.assignAll([
      const FlSpot(0, 30),
      const FlSpot(2, 45),
      const FlSpot(4, 35),
      const FlSpot(6, 50),
      const FlSpot(8, 40),
      const FlSpot(10, 55),
      const FlSpot(12, 45),
    ]);

    serverBSpots.assignAll([
      const FlSpot(0, 20),
      const FlSpot(2, 35),
      const FlSpot(4, 25),
      const FlSpot(6, 40),
      const FlSpot(8, 30),
      const FlSpot(10, 45),
      const FlSpot(12, 35),
    ]);
  }

  void setupServerData() {
    // Simulated server status data
    serverData.value = ServerData(
      fleetServers: 85,
      downServers: 15,
      running: 70,
    );

    // Simulated recent problems
    recentProblems.assignAll([
      Problem(
        service: 'Authentication Service',
        url: 'auth.example.com',
        status: ProblemStatus.stable,
      ),
      Problem(
        service: 'Payment Gateway',
        url: 'payments.example.com',
        status: ProblemStatus.warning,
      ),
      Problem(
        service: 'Storage Service',
        url: 'storage.example.com',
        status: ProblemStatus.down,
      ),
    ]);
  }

  void refreshData() {
    loadDashboardData();
  }
}

class ServerData {
  final int fleetServers;
  final int downServers;
  final int running;

  ServerData({
    required this.fleetServers,
    required this.downServers,
    required this.running,
  });
}

class Problem {
  final String service;
  final String url;
  final ProblemStatus status;

  Problem({
    required this.service,
    required this.url,
    required this.status,
  });
}

enum ProblemStatus {
  stable,
  warning,
  down,
}
