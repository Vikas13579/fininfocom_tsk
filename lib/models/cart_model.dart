import 'package:flutter/foundation.dart';

class CartItem {
  final int id;
  final String name;
  final double priceInclTax;
  int qty;
  CartItem({required this.id, required this.name, required this.priceInclTax, this.qty = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [
    CartItem(id: 1, name: 'Item 1 Small', priceInclTax: 3.75, qty: 1),
    CartItem(id: 2, name: 'Item 2', priceInclTax: 2.50, qty: 1),
    CartItem(id: 3, name: 'Item 3', priceInclTax: 1.50, qty: 2),
    CartItem(id: 4, name: 'Item 4', priceInclTax: 2.00, qty: 1),
    CartItem(id: 5, name: 'Item 5', priceInclTax: 1.00, qty: 1),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  void increaseQty(int id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i >= 0) {
      _items[i].qty += 1;
      notifyListeners();
    }
  }

  void decreaseQty(int id) {
    final i = _items.indexWhere((e) => e.id == id);
    if (i >= 0) {
      _items[i].qty -= 1;
      if (_items[i].qty <= 0) {
        _items.removeAt(i);
      }
      notifyListeners();
    }
  }

  double get totalInclTax =>
      _items.fold(0.0, (s, e) => s + e.priceInclTax * e.qty);

  double get taxAmount {
    final taxRate = 0.125;
    final totalExcl = totalInclTax / (1 + taxRate);
    return totalInclTax - totalExcl;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
