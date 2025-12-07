
class MenuItemModel {
  final int id;
  final String name;
  final int catId;
  final int menuId;
  final Map<String,double> sizePrice;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.catId,
    required this.menuId,
    required this.sizePrice,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> m){
    final sizesField = m['size'] as String? ?? '';
    final pricesField = m['price'] as String? ?? '';
    Map<String,double> map = {};
    if(sizesField.contains(',')){
      final sizes = sizesField.split(',').map((s)=>s.trim()).toList();
      final prices = pricesField.split(',').map((p)=>double.parse(p)).toList();
      for(var i=0;i<sizes.length && i<prices.length;i++){
        map[sizes[i]] = prices[i];
      }
    } else {
      double p;
      if (double.tryParse(pricesField) != null) {
        p = double.parse(pricesField);
      } else if (m['price'] is num) {
        p = (m['price'] as num).toDouble();
      } else {
        p = 0.0;
      }
      map[''] = p;
    }
    return MenuItemModel(
      id: m['id'] as int,
      name: m['item_name'] as String,
      catId: m['cat_id'] as int,
      menuId: m['menu_id'] as int,
      sizePrice: map,
    );
  }
}

class OrderItem {
  final int id;
  final String orderDate;
  final int orderId;
  final int itemId;
  final String size;
  final double price;
  final int qty;
  final String status;
  final double total;
  OrderItem({
    required this.id,
    required this.orderDate,
    required this.orderId,
    required this.itemId,
    required this.size,
    required this.price,
    required this.qty,
    required this.status,
    required this.total,
  });
  factory OrderItem.fromMap(Map<String,dynamic> m) => OrderItem(
    id: m['id'] as int,
    orderDate: m['order_date'] as String,
    orderId: m['order_id'] as int,
    itemId: m['item_id'] as int,
    size: (m['size'] ?? '').toString(),
    price: (m['price'] as num).toDouble(),
    qty: (m['qty'] as num).toInt(),
    status: m['order_status'] as String,
    total: (m['total'] as num).toDouble(),
  );
}

class Payment {
  final int id;
  final String date;
  final int paymentId;
  final int orderId;
  final double amountDue;
  final double tips;
  final double discount;
  final double totalPaid;
  final String type;
  final String status;
  Payment({
    required this.id,
    required this.date,
    required this.paymentId,
    required this.orderId,
    required this.amountDue,
    required this.tips,
    required this.discount,
    required this.totalPaid,
    required this.type,
    required this.status,
  });
  factory Payment.fromMap(Map<String,dynamic> m) => Payment(
    id: m['id'] as int,
    date: m['payment_date'] as String,
    paymentId: int.parse(m['payment_id'].toString()),
    orderId: (m['order_id'] as num).toInt(),
    amountDue: (double.tryParse(m['amount_due'].toString()) ?? 0.0),
    tips: (double.tryParse(m['tips'].toString()) ?? 0.0),
    discount: (double.tryParse(m['discount'].toString()) ?? 0.0),
    totalPaid: (double.tryParse(m['total_paid'].toString()) ?? 0.0),
    type: m['payment_type'] as String,
    status: m['payment_status'] as String,
  );
}
