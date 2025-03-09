import 'package:get/get.dart';

abstract class BaseRepository<T> {
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // CRUD operations
  Future<void> create(T item);
  Future<void> update(String id, T item);
  Future<void> delete(String id);
  Future<T?> getById(String id);
  Future<List<T>> getAll();

  // Loading and error handling
  void setLoading(bool value) => isLoading.value = value;
  void setError(String message) => error.value = message;
  void clearError() => error.value = '';

  // Helper methods
  bool get hasError => error.value.isNotEmpty;
  bool get isEmpty => items.isEmpty;
  int get count => items.length;

  // Stream getters
  Stream<List<T>> get stream => items.stream;
  Stream<bool> get loadingStream => isLoading.stream;
  Stream<String> get errorStream => error.stream;

  // Lifecycle methods
  void onInit() {
    // Initialize repository
  }

  void onClose() {
    // Cleanup repository
  }

  // Error handling
  void handleError(dynamic error) {
    print('Error in ${T.toString()}: $error');
    setError(error.toString());
  }

  // Success handling
  void handleSuccess() {
    clearError();
  }

  // Loading state management
  Future<void> withLoading(Future<void> Function() operation) async {
    try {
      setLoading(true);
      await operation();
      handleSuccess();
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  // Search and filter
  List<T> search(String query, bool Function(T item, String query) filter) {
    if (query.isEmpty) return items;
    return items.where((item) => filter(item, query)).toList();
  }

  // Pagination support
  List<T> paginate({required int page, required int limit}) {
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= items.length) return [];
    
    return items.sublist(
      startIndex,
      endIndex > items.length ? items.length : endIndex,
    );
  }

  // Sorting support
  void sort(int Function(T a, T b) compare) {
    items.sort(compare);
  }

  // Batch operations
  Future<void> batchCreate(List<T> newItems) async {
    await withLoading(() async {
      for (final item in newItems) {
        await create(item);
      }
    });
  }

  Future<void> batchUpdate(Map<String, T> updates) async {
    await withLoading(() async {
      for (final entry in updates.entries) {
        await update(entry.key, entry.value);
      }
    });
  }

  Future<void> batchDelete(List<String> ids) async {
    await withLoading(() async {
      for (final id in ids) {
        await delete(id);
      }
    });
  }

  // Cache management
  void clearCache() {
    items.clear();
  }

  void updateCache(List<T> newItems) {
    items.assignAll(newItems);
  }

  void addToCache(T item) {
    items.add(item);
  }

  void removeFromCache(String id) {
    items.removeWhere((item) => getItemId(item) == id);
  }

  void updateInCache(String id, T item) {
    final index = items.indexWhere((element) => getItemId(element) == id);
    if (index != -1) {
      items[index] = item;
    }
  }

  // Abstract method to get item ID
  String getItemId(T item);
}
