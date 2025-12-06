import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../models/models.dart';
import 'order_details.dart';
import 'cart_screen.dart';

class OrdersListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repository>(context, listen:false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
            Navigator.pushNamed(context, CartScreen.routeName);
          })
        ],
      ),
      body: FutureBuilder<List<OrderItem>>(
          future: repo.fetchAllOrderItems(),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
            final items = snap.data ?? [];
            // group by order_id
            final Map<int, List<OrderItem>> grouped = {};
            for (var it in items) grouped.putIfAbsent(it.orderId, ()=>[]).add(it);
            final orderIds = grouped.keys.toList()..sort((a,b)=>b.compareTo(a));
            return ListView.builder(
              itemCount: orderIds.length,
              itemBuilder: (c, idx) {
                final oid = orderIds[idx];
                final list = grouped[oid]!;
                final total = list.fold<double>(0.0, (s,e)=>s+e.total);
                return ListTile(
                  title: Text('Order #$oid'),
                  subtitle: Text('${list.length} items • Total £${total.toStringAsFixed(2)}'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailsScreen(orderId: oid))),
                );
              },
            );
          }
      ),
    );
  }
}
