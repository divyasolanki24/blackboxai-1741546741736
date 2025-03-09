import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shop_management_app/core/controllers/theme_controller.dart';
import 'package:shop_management_app/models/shop.dart';
import 'package:shop_management_app/modules/shop/controllers/shop_controller.dart';

class ShopDetailView extends GetView<ShopController> {
  final String shopId;

  const ShopDetailView({
    Key? key,
    required this.shopId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final shop = controller.shops.firstWhere((s) => s.id == shopId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          shop.name,
          style: TextStyle(color: themeController.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: themeController.primaryColor),
            onPressed: () => Get.toNamed('/shops/$shopId/edit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Info Card
            _buildInfoCard(shop, themeController),

            // Statistics Cards
            _buildStatisticsSection(themeController),

            // Revenue Chart
            _buildRevenueChart(themeController),

            // Product List
            _buildProductList(themeController),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Shop shop, ThemeController themeController) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.store,
                  size: 24,
                  color: themeController.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  shop.name,
                  style: TextStyle(
                    color: themeController.textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: shop.isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    shop.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: shop.isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              Icons.location_on,
              'Address',
              shop.address,
              themeController,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.phone,
              'Phone',
              shop.phone,
              themeController,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.email,
              'Email',
              shop.email,
              themeController,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ThemeController themeController,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: themeController.textColor.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: themeController.textColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: themeController.textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: TextStyle(
              color: themeController.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Products',
                '${controller.totalProducts}',
                Icons.inventory,
                Colors.blue,
                themeController,
              ),
              _buildStatCard(
                'Total Revenue',
                '\$${controller.totalRevenue.toStringAsFixed(2)}',
                Icons.attach_money,
                Colors.green,
                themeController,
              ),
              _buildStatCard(
                'Orders Today',
                '25',
                Icons.shopping_cart,
                Colors.orange,
                themeController,
              ),
              _buildStatCard(
                'Active Users',
                '156',
                Icons.people,
                Colors.purple,
                themeController,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeController themeController,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: themeController.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: themeController.textColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(ThemeController themeController) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue',
              style: TextStyle(
                color: themeController.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: TextStyle(
                              color: themeController.textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            'Day ${value.toInt()}',
                            style: TextStyle(
                              color: themeController.textColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3000),
                        FlSpot(2.6, 2000),
                        FlSpot(4.9, 5000),
                        FlSpot(6.8, 3100),
                        FlSpot(8, 4000),
                        FlSpot(9.5, 3000),
                        FlSpot(11, 4000),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(ThemeController themeController) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products',
                style: TextStyle(
                  color: themeController.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/shops/$shopId/products'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Show only top 3 products
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.inventory,
                      color: themeController.primaryColor,
                    ),
                  ),
                  title: Text(
                    'Product ${index + 1}',
                    style: TextStyle(
                      color: themeController.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Stock: ${50 - index * 10}',
                    style: TextStyle(
                      color: themeController.textColor.withOpacity(0.7),
                    ),
                  ),
                  trailing: Text(
                    '\$${99.99 - index * 10}',
                    style: TextStyle(
                      color: themeController.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
