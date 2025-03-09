class Inventory {
  final String id;
  final String shopId;
  final String productId;
  final int quantity;
  final int minimumStock;
  final int maximumStock;
  final DateTime lastRestockDate;
  final List<InventoryTransaction> transactions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  Inventory({
    required this.id,
    required this.shopId,
    required this.productId,
    required this.quantity,
    required this.minimumStock,
    required this.maximumStock,
    required this.lastRestockDate,
    required this.transactions,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      shopId: json['shop_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      minimumStock: json['minimum_stock'],
      maximumStock: json['maximum_stock'],
      lastRestockDate: DateTime.parse(json['last_restock_date']),
      transactions: (json['transactions'] as List)
          .map((transaction) => InventoryTransaction.fromJson(transaction))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'product_id': productId,
      'quantity': quantity,
      'minimum_stock': minimumStock,
      'maximum_stock': maximumStock,
      'last_restock_date': lastRestockDate.toIso8601String(),
      'transactions': transactions.map((transaction) => transaction.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  Inventory copyWith({
    int? quantity,
    int? minimumStock,
    int? maximumStock,
    DateTime? lastRestockDate,
    List<InventoryTransaction>? transactions,
    Map<String, dynamic>? metadata,
  }) {
    return Inventory(
      id: id,
      shopId: shopId,
      productId: productId,
      quantity: quantity ?? this.quantity,
      minimumStock: minimumStock ?? this.minimumStock,
      maximumStock: maximumStock ?? this.maximumStock,
      lastRestockDate: lastRestockDate ?? this.lastRestockDate,
      transactions: transactions ?? this.transactions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods
  bool get needsRestock => quantity <= minimumStock;
  bool get isOverstocked => quantity >= maximumStock;
  double get stockLevel => quantity / maximumStock;
  
  InventoryStatus get status {
    if (quantity <= 0) return InventoryStatus.outOfStock;
    if (quantity <= minimumStock) return InventoryStatus.low;
    if (quantity >= maximumStock) return InventoryStatus.overstocked;
    return InventoryStatus.normal;
  }

  // Transaction methods
  void addTransaction(InventoryTransaction transaction) {
    transactions.add(transaction);
  }

  List<InventoryTransaction> getTransactionsByType(TransactionType type) {
    return transactions.where((transaction) => transaction.type == type).toList();
  }

  List<InventoryTransaction> getTransactionsInDateRange(DateTime start, DateTime end) {
    return transactions.where((transaction) {
      return transaction.date.isAfter(start) && transaction.date.isBefore(end);
    }).toList();
  }
}

class InventoryTransaction {
  final String id;
  final TransactionType type;
  final int quantity;
  final String? reference;
  final String? notes;
  final DateTime date;
  final String userId;

  InventoryTransaction({
    required this.id,
    required this.type,
    required this.quantity,
    this.reference,
    this.notes,
    required this.date,
    required this.userId,
  });

  factory InventoryTransaction.fromJson(Map<String, dynamic> json) {
    return InventoryTransaction(
      id: json['id'],
      type: TransactionType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
      ),
      quantity: json['quantity'],
      reference: json['reference'],
      notes: json['notes'],
      date: DateTime.parse(json['date']),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'quantity': quantity,
      'reference': reference,
      'notes': notes,
      'date': date.toIso8601String(),
      'user_id': userId,
    };
  }
}

enum TransactionType {
  purchase,
  sale,
  return,
  adjustment,
  transfer,
  loss,
  recount
}

enum InventoryStatus {
  normal,
  low,
  outOfStock,
  overstocked
}

extension InventoryStatusExtension on InventoryStatus {
  String get label {
    switch (this) {
      case InventoryStatus.normal:
        return 'Normal';
      case InventoryStatus.low:
        return 'Low Stock';
      case InventoryStatus.outOfStock:
        return 'Out of Stock';
      case InventoryStatus.overstocked:
        return 'Overstocked';
    }
  }

  String get color {
    switch (this) {
      case InventoryStatus.normal:
        return '#4CAF50'; // Green
      case InventoryStatus.low:
        return '#FFC107'; // Yellow
      case InventoryStatus.outOfStock:
        return '#F44336'; // Red
      case InventoryStatus.overstocked:
        return '#2196F3'; // Blue
    }
  }
}

extension TransactionTypeExtension on TransactionType {
  String get label {
    switch (this) {
      case TransactionType.purchase:
        return 'Purchase';
      case TransactionType.sale:
        return 'Sale';
      case TransactionType.return:
        return 'Return';
      case TransactionType.adjustment:
        return 'Adjustment';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.loss:
        return 'Loss';
      case TransactionType.recount:
        return 'Recount';
    }
  }

  bool get isPositive {
    switch (this) {
      case TransactionType.purchase:
      case TransactionType.return:
        return true;
      case TransactionType.sale:
      case TransactionType.loss:
        return false;
      case TransactionType.adjustment:
      case TransactionType.transfer:
      case TransactionType.recount:
        return true; // Depends on the quantity being positive or negative
    }
  }
}
