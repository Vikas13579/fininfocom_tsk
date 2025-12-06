import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repository.dart';
import '../models/models.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;
  OrderDetailsScreen({required this.orderId});
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<Repository>(context, listen:false);
    return Scaffold(
      appBar: AppBar(title: Text('Order #$orderId')),
      body: FutureBuilder(
        future: Future.wait([
          repo.fetchItemsForOrder(orderId),
          repo.fetchPaymentsForOrder(orderId),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snap) {
          if (snap.connectionState != ConnectionState.done) return Center(child: CircularProgressIndicator());
          final items = snap.data![0] as List<OrderItem>;
          final payments = snap.data![1] as List<Payment>;
          final total = items.fold<double>(0.0, (s,e)=>s+e.total);
          final paid = payments.fold<double>(0.0, (s,e)=>s+e.totalPaid);
          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Items', style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
              ...items.map((it)=>ListTile(
                title: Text('Item ${it.itemId} ${it.size}'),
                subtitle: Text('Price £${it.price.toStringAsFixed(2)} • Qty ${it.qty}'),
                trailing: Text('£${it.total.toStringAsFixed(2)}'),
              )),
              Divider(),
              Text('Payments', style: TextStyle(fontSize:18,fontWeight:FontWeight.bold)),
              ...payments.map((p)=>ListTile(
                title: Text('${p.type} • ${p.status}'),
                subtitle: Text('${p.date}'),
                trailing: Text('£${p.totalPaid.toStringAsFixed(2)}'),
              )),
              Divider(),
              ListTile(title: Text('Order Total'), trailing: Text('£${total.toStringAsFixed(2)}')),
              ListTile(title: Text('Total Paid'), trailing: Text('£${paid.toStringAsFixed(2)}')),
              if ((paid - total).abs() > 0.01)
                Padding(
                  padding: EdgeInsets.only(top:8),
                  child: Text('Note: Payment total differs from order total. Reconcile tips/discount/refunds.', style: TextStyle(color:Colors.orange)),
                )
            ]),
          );
        },
      ),
    );
  }
}
