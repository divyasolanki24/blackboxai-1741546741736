import 'package:get/get.dart';
import 'package:shop_management_app/models/user.dart';
import 'package:shop_management_app/models/role.dart';
import 'package:shop_management_app/repositories/base_repository.dart';
import 'package:shop_management_app/repositories/role_repository.dart';

class UserRepository extends BaseRepository<User> {
  // Singleton instance
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  // Dependencies
  final _roleRepository = Get.find<RoleRepository>();

  // Additional user-specific state
  final RxMap<String, List<User>> roleUsers = <String, List<User>>{}.obs;
  final RxInt activeUsers = 0.obs;
  final RxInt pendingUsers = 0.obs;

  @override
  String getItemId(User item) => item.id;

  @override
  Future<void> create(User user) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      addToCache(user);
      updateUserLists(user);
    });
  }

  @override
  Future<void> update(String id, User user) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      updateInCache(id, user);
      updateUserLists(user);
    });
  }

  @override
  Future<void> delete(String id) async {
    await withLoading(() async {
      final user = await getById(id);
      if (user != null) {
        // TODO: Implement API call
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        removeFromCache(id);
        removeFromUserLists(user);
      }
    });
  }

  @override
  Future<User?> getById(String id) async {
    try {
      setLoading(true);
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return items.firstWhereOrNull((user) => user.id == id);
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<List<User>> getAll() async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simulated data
      final users = [
        User(
          id: '1',
          email: 'admin@example.com',
          name: 'Admin User',
          roles: [Role.admin()],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        User(
          id: '2',
          email: 'manager@example.com',
          name: 'Manager User',
          roles: [Role.manager()],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      updateCache(users);
      updateAllUserLists();
      return users;
    });
    return items;
  }

  // Authentication methods
  Future<User?> authenticate(String email, String password) async {
    try {
      setLoading(true);
      // TODO: Implement actual authentication
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Simulated authentication
      if (email == 'admin@example.com' && password == 'admin123') {
        return User(
          id: '1',
          email: email,
          name: 'Admin User',
          roles: [Role.admin()],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> changePassword(String userId, String currentPassword, String newPassword) async {
    await withLoading(() async {
      // TODO: Implement password change
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    });
  }

  // Role management
  Future<void> assignRole(String userId, String roleId) async {
    final user = await getById(userId);
    final role = await _roleRepository.getById(roleId);
    
    if (user != null && role != null) {
      final updatedRoles = [...user.roles, role];
      await update(userId, user.copyWith(roles: updatedRoles));
    }
  }

  Future<void> removeRole(String userId, String roleId) async {
    final user = await getById(userId);
    if (user != null) {
      final updatedRoles = user.roles.where((role) => role.id != roleId).toList();
      await update(userId, user.copyWith(roles: updatedRoles));
    }
  }

  Future<void> updateRoles(String userId, List<Role> roles) async {
    final user = await getById(userId);
    if (user != null) {
      await update(userId, user.copyWith(roles: roles));
    }
  }

  // User list management
  void updateUserLists(User user) {
    // Update role users
    for (final role in user.roles) {
      final roleUserList = roleUsers[role.id] ?? [];
      final existingIndex = roleUserList.indexWhere((u) => u.id == user.id);
      
      if (existingIndex >= 0) {
        roleUserList[existingIndex] = user;
      } else {
        roleUserList.add(user);
      }
      roleUsers[role.id] = roleUserList;
    }

    updateUserCounts();
  }

  void removeFromUserLists(User user) {
    // Remove from role users
    for (final role in user.roles) {
      final roleUserList = roleUsers[role.id] ?? [];
      roleUserList.removeWhere((u) => u.id == user.id);
      roleUsers[role.id] = roleUserList;
    }

    updateUserCounts();
  }

  void updateAllUserLists() {
    // Group users by role
    roleUsers.clear();
    for (final user in items) {
      for (final role in user.roles) {
        final roleUserList = roleUsers[role.id] ?? [];
        roleUserList.add(user);
        roleUsers[role.id] = roleUserList;
      }
    }

    updateUserCounts();
  }

  void updateUserCounts() {
    activeUsers.value = items.where((user) => user.status == UserStatus.active).length;
    pendingUsers.value = items.where((user) => user.status == UserStatus.pending).length;
  }

  // Query methods
  List<User> getUsersByRole(String roleId) {
    return roleUsers[roleId] ?? [];
  }

  List<User> searchUsers(String query) {
    return search(query, (user, query) {
      final searchTerm = query.toLowerCase();
      return user.name.toLowerCase().contains(searchTerm) ||
          user.email.toLowerCase().contains(searchTerm);
    });
  }

  List<User> filterByStatus(UserStatus status) {
    return items.where((user) => user.status == status).toList();
  }

  // Analytics
  Map<String, dynamic> getUserAnalytics() {
    return {
      'totalUsers': items.length,
      'activeUsers': activeUsers.value,
      'pendingUsers': pendingUsers.value,
      'inactiveUsers': items.where((user) => user.status == UserStatus.inactive).length,
      'roleDistribution': roleUsers.map((roleId, users) => MapEntry(roleId, users.length)),
    };
  }

  // Export/Import
  Future<String> exportToJson() async {
    try {
      final exportData = items.map((user) => user.toJson()).toList();
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
