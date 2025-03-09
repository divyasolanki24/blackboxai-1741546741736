import 'package:get/get.dart';
import 'package:shop_management_app/models/module.dart';
import 'package:shop_management_app/repositories/base_repository.dart';

class ModuleRepository extends BaseRepository<Module> {
  // Singleton instance
  static final ModuleRepository _instance = ModuleRepository._internal();
  factory ModuleRepository() => _instance;
  ModuleRepository._internal();

  // Additional module-specific state
  final RxMap<ModuleType, List<Module>> modulesByType = <ModuleType, List<Module>>{}.obs;
  final RxInt enabledModules = 0.obs;
  final RxMap<String, Map<String, dynamic>> moduleSettings = <String, Map<String, dynamic>>{}.obs;

  @override
  String getItemId(Module item) => item.id;

  @override
  Future<void> create(Module module) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      addToCache(module);
      updateModuleLists(module);
    });
  }

  @override
  Future<void> update(String id, Module module) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      updateInCache(id, module);
      updateModuleLists(module);
    });
  }

  @override
  Future<void> delete(String id) async {
    await withLoading(() async {
      final module = await getById(id);
      if (module != null && module.type != ModuleType.core) {
        // TODO: Implement API call
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        removeFromCache(id);
        removeFromModuleLists(module);
      } else {
        throw Exception('Cannot delete core module');
      }
    });
  }

  @override
  Future<Module?> getById(String id) async {
    try {
      setLoading(true);
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return items.firstWhereOrNull((module) => module.id == id);
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<List<Module>> getAll() async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Initialize core modules
      final modules = [
        Module.shopManagement(),
        Module.inventoryManagement(),
        Module.userManagement(),
      ];
      
      updateCache(modules);
      updateAllModuleLists();
      return modules;
    });
    return items;
  }

  // Module management
  Future<void> toggleModule(String moduleId, bool enabled) async {
    final module = await getById(moduleId);
    if (module != null) {
      await update(
        moduleId,
        module.copyWith(isEnabled: enabled),
      );
    }
  }

  Future<void> updateModuleSettings(String moduleId, Map<String, dynamic> settings) async {
    final module = await getById(moduleId);
    if (module != null) {
      await update(
        moduleId,
        module.copyWith(settings: settings),
      );
      moduleSettings[moduleId] = settings;
    }
  }

  Future<void> toggleFeature(String moduleId, String featureId, bool enabled) async {
    final module = await getById(moduleId);
    if (module != null) {
      final updatedFeatures = module.features.map((feature) {
        if (feature.id == featureId) {
          return ModuleFeature(
            id: feature.id,
            name: feature.name,
            isEnabled: enabled,
            requiredPermissions: feature.requiredPermissions,
          );
        }
        return feature;
      }).toList();

      await update(
        moduleId,
        module.copyWith(features: updatedFeatures),
      );
    }
  }

  // Module list management
  void updateModuleLists(Module module) {
    // Update modules by type
    final typeModules = modulesByType[module.type] ?? [];
    final existingIndex = typeModules.indexWhere((m) => m.id == module.id);
    
    if (existingIndex >= 0) {
      typeModules[existingIndex] = module;
    } else {
      typeModules.add(module);
    }
    modulesByType[module.type] = typeModules;

    // Update module settings
    moduleSettings[module.id] = module.settings;

    updateModuleCounts();
  }

  void removeFromModuleLists(Module module) {
    // Remove from modules by type
    final typeModules = modulesByType[module.type] ?? [];
    typeModules.removeWhere((m) => m.id == module.id);
    modulesByType[module.type] = typeModules;

    // Remove module settings
    moduleSettings.remove(module.id);

    updateModuleCounts();
  }

  void updateAllModuleLists() {
    // Group modules by type
    modulesByType.clear();
    moduleSettings.clear();
    
    for (final module in items) {
      final typeModules = modulesByType[module.type] ?? [];
      typeModules.add(module);
      modulesByType[module.type] = typeModules;
      
      moduleSettings[module.id] = module.settings;
    }

    updateModuleCounts();
  }

  void updateModuleCounts() {
    enabledModules.value = items.where((module) => module.isEnabled).length;
  }

  // Query methods
  List<Module> getModulesByType(ModuleType type) {
    return modulesByType[type] ?? [];
  }

  List<Module> getEnabledModules() {
    return items.where((module) => module.isEnabled).toList();
  }

  List<ModuleFeature> getModuleFeatures(String moduleId) {
    final module = items.firstWhereOrNull((m) => m.id == moduleId);
    return module?.features ?? [];
  }

  // Permission checks
  bool hasRequiredPermissions(String moduleId, List<String> userPermissions) {
    final module = items.firstWhereOrNull((m) => m.id == moduleId);
    if (module == null) return false;
    
    return module.requiredPermissions.every(
      (permission) => userPermissions.contains(permission),
    );
  }

  bool canAccessFeature(String moduleId, String featureId, List<String> userPermissions) {
    final module = items.firstWhereOrNull((m) => m.id == moduleId);
    if (module == null) return false;

    final feature = module.features.firstWhereOrNull((f) => f.id == featureId);
    if (feature == null) return false;

    return feature.isEnabled && feature.requiredPermissions.every(
      (permission) => userPermissions.contains(permission),
    );
  }

  // Search and filter
  List<Module> searchModules(String query) {
    return search(query, (module, query) {
      final searchTerm = query.toLowerCase();
      return module.name.toLowerCase().contains(searchTerm) ||
          module.description.toLowerCase().contains(searchTerm);
    });
  }

  // Analytics
  Map<String, dynamic> getModuleAnalytics() {
    return {
      'totalModules': items.length,
      'enabledModules': enabledModules.value,
      'modulesByType': modulesByType.map(
        (type, modules) => MapEntry(type.toString(), modules.length),
      ),
      'featureUsage': items.fold<Map<String, bool>>({}, (map, module) {
        for (final feature in module.features) {
          map[feature.id] = feature.isEnabled;
        }
        return map;
      }),
    };
  }

  // Export/Import
  Future<String> exportToJson() async {
    try {
      final exportData = items.map((module) => module.toJson()).toList();
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
