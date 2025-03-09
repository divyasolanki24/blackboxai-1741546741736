class Product {
  final String id;
  final String shopId;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final String category;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.category,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.metadata,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      shopId: json['shop_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      stockQuantity: json['stock_quantity'],
      category: json['category'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'name': name,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'category': category,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'metadata': metadata,
    };
  }

  Product copyWith({
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    String? category,
    String? imageUrl,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Product(
      id: id,
      shopId: shopId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper method to check if product is in stock
  bool get isInStock => stockQuantity > 0;

  // Helper method to check if product needs restock
  bool needsRestock(int minimumStock) => stockQuantity <= minimumStock;

  // Helper method to format price
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  // Helper method to get stock status
  StockStatus get stockStatus {
    if (stockQuantity > 20) return StockStatus.good;
    if (stockQuantity > 5) return StockStatus.warning;
    if (stockQuantity > 0) return StockStatus.critical;
    return StockStatus.outOfStock;
  }
}

enum StockStatus {
  good,
  warning,
  critical,
  outOfStock
}

extension StockStatusExtension on StockStatus {
  String get label {
    switch (this) {
      case StockStatus.good:
        return 'In Stock';
      case StockStatus.warning:
        return 'Low Stock';
      case StockStatus.critical:
        return 'Critical Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  String get color {
    switch (this) {
      case StockStatus.good:
        return '#4CAF50'; // Green
      case StockStatus.warning:
        return '#FFC107'; // Yellow
      case StockStatus.critical:
        return '#FF9800'; // Orange
      case StockStatus.outOfStock:
        return '#F44336'; // Red
    }
  }
}
