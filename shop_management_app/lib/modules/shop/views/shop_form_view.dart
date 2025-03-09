import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_management_app/core/controllers/theme_controller.dart';
import 'package:shop_management_app/models/shop.dart';
import 'package:shop_management_app/modules/shop/controllers/shop_controller.dart';

class ShopFormView extends GetView<ShopController> {
  final bool isEditing;
  final Shop? shop;

  const ShopFormView({
    Key? key,
    this.isEditing = false,
    this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final formKey = GlobalKey<FormState>();
    
    final nameController = TextEditingController(text: shop?.name);
    final addressController = TextEditingController(text: shop?.address);
    final phoneController = TextEditingController(text: shop?.phone);
    final emailController = TextEditingController(text: shop?.email);

    void handleSubmit() {
      if (formKey.currentState!.validate()) {
        final shopData = Shop(
          id: shop?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          name: nameController.text,
          address: addressController.text,
          phone: phoneController.text,
          email: emailController.text,
          createdAt: shop?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
          isActive: shop?.isActive ?? true,
        );

        if (isEditing) {
          controller.updateShop(shop!.id, shopData);
        } else {
          controller.createShop(shopData);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Shop' : 'Create Shop',
          style: TextStyle(color: themeController.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeController.textColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name Field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Shop Name',
                    prefixIcon: Icon(Icons.store, color: themeController.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address Field
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on, color: themeController.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter shop address';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Phone Field
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone, color: themeController.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: themeController.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Shop' : 'Create Shop',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (isEditing) ...[
                  const SizedBox(height: 16),
                  // Delete Button
                  OutlinedButton(
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Delete Shop'),
                          content: Text(
                            'Are you sure you want to delete ${shop!.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                controller.deleteShop(shop!.id);
                                Get.back(); // Return to shop list
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
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Delete Shop',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
