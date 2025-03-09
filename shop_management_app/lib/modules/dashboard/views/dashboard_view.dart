import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_app/core/controllers/auth_controller.dart';
import 'package:shop_management_app/core/controllers/theme_controller.dart';
import 'package:shop_management_app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:shop_management_app/modules/dashboard/widgets/server_request_chart.dart';
import 'package:shop_management_app/modules/dashboard/widgets/server_status_chart.dart';
import 'package:shop_management_app/modules/dashboard/widgets/stat_card.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final authController = Get.find<AuthController>();
    final user = authController.user.value;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            Container(
              width: 250,
              color: themeController.backgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo and Brand
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: themeController.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Geex',
                        style: TextStyle(
                          color: themeController.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Navigation Items
                  _NavItem(
                    icon: Icons.dashboard,
                    label: 'Dashboard',
                    isSelected: true,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.email,
                    label: 'Email',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.people,
                    label: 'Contacts',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.currency_bitcoin,
                    label: 'Crypto',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.view_kanban,
                    label: 'Kanban',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.receipt,
                    label: 'Invoicing',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.account_balance,
                    label: 'Banking',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.folder,
                    label: 'File Manager',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.calendar_today,
                    label: 'Calendar',
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.check_box,
                    label: 'Todo List',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                color: themeController.backgroundColor.withOpacity(0.95),
                child: Obx(() => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    color: themeController.textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Welcome to Geex Modern Admin Dashboard',
                                  style: TextStyle(
                                    color: themeController.textColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Search Bar
                            Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: themeController.backgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: themeController.textColor.withOpacity(0.1),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search here...',
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.search,
                                    color: themeController.textColor.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // User Profile
                            CircleAvatar(
                              backgroundColor: themeController.primaryColor,
                              child: Text(
                                user?.name.substring(0, 1) ?? 'U',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Stats Grid
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            StatCard(
                              title: 'Memory',
                              value: '${controller.totalMemory}TB',
                              percentage: controller.memoryGrowth.value,
                              chart: LineChart(
                                // Simple line chart for memory
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 3),
                                        FlSpot(2.6, 2),
                                        FlSpot(4.9, 5),
                                        FlSpot(6.8, 3.1),
                                        FlSpot(8, 4),
                                        FlSpot(9.5, 3),
                                        FlSpot(11, 4),
                                      ],
                                      isCurved: true,
                                      color: Colors.green,
                                      barWidth: 2,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.green.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StatCard(
                              title: 'Visitors',
                              value: '${controller.usedMemory}k',
                              percentage: controller.visitorGrowth.value,
                              chart: LineChart(
                                // Simple line chart for visitors
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 4),
                                        FlSpot(2.6, 3),
                                        FlSpot(4.9, 2),
                                        FlSpot(6.8, 4),
                                        FlSpot(8, 3),
                                        FlSpot(9.5, 2),
                                        FlSpot(11, 3),
                                      ],
                                      isCurved: true,
                                      color: Colors.red,
                                      barWidth: 2,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.red.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            StatCard(
                              title: 'New Users',
                              value: '${controller.newUsers}',
                              percentage: controller.userGrowth.value,
                              chart: LineChart(
                                // Simple line chart for new users
                                LineChartData(
                                  gridData: FlGridData(show: false),
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 2),
                                        FlSpot(2.6, 4),
                                        FlSpot(4.9, 3),
                                        FlSpot(6.8, 5),
                                        FlSpot(8, 4),
                                        FlSpot(9.5, 3),
                                        FlSpot(11, 5),
                                      ],
                                      isCurved: true,
                                      color: Colors.purple,
                                      barWidth: 2,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.purple.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Server Request Chart
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Server Request',
                                  style: TextStyle(
                                    color: themeController.textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 300,
                                  child: ServerRequestChart(
                                    serverASpots: controller.serverASpots,
                                    serverBSpots: controller.serverBSpots,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Bottom Section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chart Summary
                            Expanded(
                              flex: 2,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Chart Summary',
                                            style: TextStyle(
                                              color: themeController.textColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text('Download Report'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        height: 200,
                                        child: ServerStatusChart(
                                          fleetServers: controller.serverData.value.fleetServers,
                                          downServers: controller.serverData.value.downServers,
                                          running: controller.serverData.value.running,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const ServerStatusLegend(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Recent Problems
                            Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Recent Problems',
                                        style: TextStyle(
                                          color: themeController.textColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...controller.recentProblems.map((problem) => _ProblemItem(
                                        problem: problem,
                                        textColor: themeController.textColor,
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? themeController.primaryColor
              : themeController.textColor.withOpacity(0.7),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? themeController.primaryColor
                : themeController.textColor.withOpacity(0.7),
          ),
        ),
        onTap: onTap,
        selected: isSelected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _ProblemItem extends StatelessWidget {
  final Problem problem;
  final Color textColor;

  const _ProblemItem({
    Key? key,
    required this.problem,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (problem.status) {
      case ProblemStatus.stable:
        statusColor = Colors.green;
        break;
      case ProblemStatus.warning:
        statusColor = Colors.orange;
        break;
      case ProblemStatus.down:
        statusColor = Colors.red;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.warning, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  problem.service,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  problem.url,
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              problem.status.name.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
