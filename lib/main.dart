import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/orders_list.dart';
import 'screens/cart_screen.dart';
import 'data/db_helper.dart';
import 'data/repository.dart';
import 'models/cart_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = await DBHelper.instance.initDBAndSeedIfEmpty();
  final repo = Repository(dbHelper);
  runApp(MyApp(repo));
}

class MyApp extends StatelessWidget {
  final Repository repo;
  MyApp(this.repo);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Repository>.value(value: repo),
        ChangeNotifierProvider<CartModel>(create: (_) => CartModel()),
      ],
      child: MaterialApp(
        title: 'FinInfocom Task',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: OrdersListScreen(),
        routes: {
          CartScreen.routeName: (_) => CartScreen(),
        },
      ),
    );
  }
}
