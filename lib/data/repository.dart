import 'db_helper.dart';
import '../models/models.dart';

class Repository {
  final DBHelper dbHelper;
  Repository(this.dbHelper);

  Future<List<OrderItem>> fetchAllOrderItems() async {
    final db = dbHelper.db;
    final maps = await db.query('orders', orderBy: 'order_id DESC, id ASC');
    return maps.map((m)=>OrderItem.fromMap(m)).toList();
  }

  Future<List<OrderItem>> fetchItemsForOrder(int orderId) async {
    final db = dbHelper.db;
    final maps = await db.query('orders', where: 'order_id = ?', whereArgs: [orderId]);
    return maps.map((m)=>OrderItem.fromMap(m)).toList();
  }

  Future<List<Payment>> fetchPaymentsForOrder(int orderId) async {
    final db = dbHelper.db;
    final maps = await db.query('payments', where: 'order_id = ?', whereArgs: [orderId]);
    return maps.map((m)=>Payment.fromMap(m)).toList();
  }

  Future<Map<int, List<Payment>>> fetchAllPaymentsGrouped() async {
    final db = dbHelper.db;
    final maps = await db.query('payments');
    final list = maps.map((m)=>Payment.fromMap(m)).toList();
    final Map<int,List<Payment>> grouped = {};
    for (var p in list) {
      grouped.putIfAbsent(p.orderId, ()=>[]).add(p);
    }
    return grouped;
  }
}
