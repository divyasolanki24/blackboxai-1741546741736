import 'package:get/get.dart';
import 'package:shop_management_app/routes/app_routes.dart';

class AuthController extends GetxController {
  final isLoggedIn = false.obs;
  final user = Rxn<User>();
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // TODO: Implement actual token/session check
    loading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    loading.value = false;
  }

  Future<bool> login(String email, String password) async {
    try {
      loading.value = true;
      // TODO: Implement actual login API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (email == 'admin@example.com' && password == 'admin123') {
        user.value = User(
          id: '1',
          email: email,
          name: 'Admin User',
          role: 'admin',
          permissions: ['all'],
        );
        isLoggedIn.value = true;
        Get.offAllNamed(Routes.DASHBOARD);
        return true;
      }
      Get.snackbar(
        'Error',
        'Invalid credentials',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      loading.value = false;
    }
  }

  void logout() {
    user.value = null;
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.LOGIN);
  }

  bool hasPermission(String permission) {
    if (user.value == null) return false;
    if (user.value!.role == 'admin') return true;
    return user.value!.permissions.contains(permission);
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final List<String> permissions;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      permissions: List<String>.from(json['permissions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'permissions': permissions,
    };
  }
}
