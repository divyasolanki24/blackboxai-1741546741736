import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_app/core/controllers/theme_controller.dart';
import 'package:shop_management_app/models/shop.dart';
import 'package:shop_management_app/modules/shop/controllers/shop_controller.dart';

class ShopListView extends GetView<ShopController> {
  const ShopListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shops',
          style: TextStyle(color: themeController.textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: themeController.primaryColor),
            onPressed: () => Get.toNamed('/shops/create'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.searchShops,
                    decoration: InputDecoration(
                      hintText: 'Search shops...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: controller.selectedFilter.value,
                  items: [
                    'All',
                    'Active',
                    'Inactive',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: controller.filterShops,
                ),
              ],
            ),
          ),

          // Shop List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.shops.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_off,
                        size: 64,
                        color: themeController.textColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No shops found',
                        style: TextStyle(
                          color: themeController.textColor.withOpacity(0.5),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.shops.length,
                itemBuilder: (context, index) {
                  final shop = controller.shops[index];
                  return _ShopCard(
                    shop: shop,
                    onTap: () => Get.toNamed('/shops/${shop.id}'),
                    onEdit: () => Get.toNamed('/shops/${shop.id}/edit'),
                    onDelete: () => controller.deleteShop(shop.id),
                    onToggleStatus: (isActive) => 
                        controller.toggleShopStatus(shop.id, isActive),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Function(bool) onToggleStatus;

  const _ShopCard({
    Key? key,
    required this.shop,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      shop.name,
                      style: TextStyle(
                        color: themeController.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Switch(
                    value: shop.isActive,
                    onChanged: onToggleStatus,
                    activeColor: themeController.primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: themeController.textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      shop.address,
                      style: TextStyle(
                        color: themeController.textColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.email,
                    size: 16,
                    color: themeController.textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    shop.email,
                    style: TextStyle(
                      color: themeController.textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 16,
                    color: themeController.textColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    shop.phone,
                    style: TextStyle(
                      color: themeController.textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: themeController.primaryColor,
                    ),
                    onPressed: onEdit,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Delete Shop'),
                          content: Text(
                            'Are you sure you want to delete ${shop.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                onDelete();
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
