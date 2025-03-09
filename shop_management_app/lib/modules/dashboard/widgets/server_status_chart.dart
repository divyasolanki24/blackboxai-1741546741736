import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_app/core/controllers/theme_controller.dart';

class ServerStatusChart extends StatelessWidget {
  final int fleetServers;
  final int downServers;
  final int running;

  const ServerStatusChart({
    Key? key,
    required this.fleetServers,
    required this.downServers,
    required this.running,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: Colors.purple,
            value: fleetServers.toDouble(),
            title: 'Fleet\n$fleetServers',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: themeController.textColor,
            ),
          ),
          PieChartSectionData(
            color: Colors.red,
            value: downServers.toDouble(),
            title: 'Down\n$downServers',
            radius: 45,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: themeController.textColor,
            ),
          ),
          PieChartSectionData(
            color: Colors.orange,
            value: running.toDouble(),
            title: 'Running\n$running',
            radius: 55,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: themeController.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ServerStatusLegend extends StatelessWidget {
  const ServerStatusLegend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: Colors.purple,
          label: 'Fleet Servers',
          textColor: themeController.textColor,
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: Colors.red,
          label: 'Down Servers',
          textColor: themeController.textColor,
        ),
        const SizedBox(width: 16),
        _LegendItem(
          color: Colors.orange,
          label: 'Running',
          textColor: themeController.textColor,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final Color textColor;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
