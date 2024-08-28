import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/cart_item/cart_item_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: BlocBuilder<CartItemBloc, CartItemState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            if (state.cartItems.isEmpty) {
              return Center(child: Text('Your cart is empty.'));
            }

            return ListView.builder(
              itemCount: state.cartItems.length,
              itemBuilder: (context, index) {
                final item = state.cartItems[index];
                return ListTile(
                  leading: Image.network(item.product.pictureUrl ?? ''),
                  title: Text(item.product.name ?? 'Product'),
                  subtitle: Text(
                      '${formatCurrency.format(item.product.price)} x ${item.quantity}'),
                  trailing: Text(formatCurrency
                      .format(item.product.price! * item.quantity)),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BlocBuilder<CartItemBloc, CartItemState>(
        builder: (context, state) {
          if (state is CartLoaded && state.cartItems.isNotEmpty) {
            final totalPrice = state.cartItems.fold(
              0,
              (sum, item) => sum + (item.product.price! * item.quantity),
            );
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${formatCurrency.format(totalPrice)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implementasi logika transaksi
                      _showTransactionDialog(context, totalPrice);
                    },
                    child: Text('Checkout'),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  void _showTransactionDialog(BuildContext context, int totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Complete Transaction'),
          content: Text(
              'Are you sure you want to complete the transaction? Total amount: Rp. $totalPrice'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Logic untuk menyelesaikan transaksi
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Transaction completed!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
