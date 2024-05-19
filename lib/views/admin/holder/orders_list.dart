import 'package:dabka/models/order_model.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key, required this.orders});
  final List<OrderModel> orders;
  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[],
    );
  }
}
