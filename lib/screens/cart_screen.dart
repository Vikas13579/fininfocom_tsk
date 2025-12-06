import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  final currency = NumberFormat.currency(locale: 'en_GB', symbol: '£');
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Cart',style: TextStyle(color: Colors.black),)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cart.items.map((it) => ListTile(
                title: Text(it.name),
                subtitle: Text('${currency.format(it.priceInclTax)} each'),
                leading: IconButton(icon: Icon(Icons.remove), onPressed: ()=>cart.decreaseQty(it.id)),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('x${it.qty}'),
                  IconButton(icon: Icon(Icons.add), onPressed: ()=>cart.increaseQty(it.id)),
                ]),
              )).toList(),
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Total (Incl Tax): ${currency.format(cart.totalInclTax)}', style: TextStyle(fontSize:16)),
              Text('Tax (12.5%): ${currency.format(cart.taxAmount)}', style: TextStyle(fontSize:14)),
              SizedBox(height:8),
              ElevatedButton(onPressed: cart.items.isEmpty?null:(){
                // checkout stub
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout not implemented')));
              }, child: Text('Checkout')),
            ]),
          )
        ],
      ),
    );
  }
}
