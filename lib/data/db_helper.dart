import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  Database? _db;

  Future<DBHelper> initDBAndSeedIfEmpty() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'fin_task.db');
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    // check seed
    final count = Sqflite.firstIntValue(await _db!.rawQuery('SELECT COUNT(*) FROM orders')) ?? 0;
    if (count == 0) {
      await _seedData();
    }
    return this;
  }

  Database get db {
    if (_db == null) throw Exception('DB not initialized');
    return _db!;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY,
        order_date TEXT,
        order_id INTEGER,
        item_id INTEGER,
        size TEXT,
        price REAL,
        qty INTEGER,
        order_status TEXT,
        total REAL
      );
    ''');
    await db.execute('''
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY,
        payment_date TEXT,
        payment_id INTEGER,
        order_id INTEGER,
        amount_due REAL,
        tips REAL,
        discount REAL,
        total_paid REAL,
        payment_type TEXT,
        payment_status TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE menu(
        id INTEGER PRIMARY KEY,
        item_name TEXT,
        cat_id INTEGER,
        menu_id INTEGER,
        size TEXT,
        price TEXT
      );
    ''');
  }

  Future<void> _seedData() async {
    final db = this.db;
    // Insert a few orders from the provided PDF sample (do more as needed)
    // For brevity, insert some representative rows:
    final orders = [
      {'id':1,'order_date':'01 Oct 2025','order_id':10,'item_id':2,'size':'','price':2.5,'qty':1,'order_status':'Completed','total':2.5},
      {'id':2,'order_date':'01 Oct 2025','order_id':10,'item_id':3,'size':'','price':1.5,'qty':2,'order_status':'Completed','total':3.0},
      {'id':3,'order_date':'01 Oct 2025','order_id':10,'item_id':1,'size':'Small','price':3.75,'qty':1,'order_status':'Completed','total':3.75},
      // add more rows as desired parsed from the PDF...
    ];
    for (var r in orders) await db.insert('orders', r);

    final payments = [
      {'id':1,'payment_date':'01 Oct 2025','payment_id':100,'order_id':10,'amount_due':10.0,'tips':0.0,'discount':0.0,'total_paid':9.25,'payment_type':'Card','payment_status':'Completed'},
      {'id':2,'payment_date':'01 Oct 2025','payment_id':101,'order_id':11,'amount_due':21.25,'tips':0.0,'discount':0.0,'total_paid':10.0,'payment_type':'Cash','payment_status':'Completed'},
      // add more from PDF as needed...
    ];
    for (var r in payments) await db.insert('payments', r);

    final menu = [
      {'id':1,'item_name':'Item1','cat_id':1,'menu_id':1,'size':'Small, Large','price':'1.50, 2.50'},
      {'id':2,'item_name':'Item2','cat_id':1,'menu_id':1,'size':'','price':'3'},
      {'id':3,'item_name':'Item3','cat_id':2,'menu_id':2,'size':'','price':'2.5'},
      // add more...
    ];
    for (var r in menu) await db.insert('menu', r);
  }
}
