// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/order_model.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';

import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class BookingList extends StatefulWidget {
  const BookingList({super.key});
  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final TextEditingController _searchController = TextEditingController();
  List<OrderModel> _orders = <OrderModel>[];

  String _formatCustomDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(1.days);
    final dayBeforeYesterday = today.subtract(2.days);

    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return '${'Today, at'.tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == yesterday.day) {
      return '${'Yesterday, at'.tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == dayBeforeYesterday.day) {
      return '${'2 days ago, at'.tr} ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else {
      return formatDate(date, const <String>[dd, '/', mm, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    }
  }

  Map<int, ProductModel> _productsCounter(int index) {
    final Map<int, ProductModel> products = <int, ProductModel>{};
    for (final ProductModel product in _orders[index].products) {
      if (!products.containsValue(product)) {
        products[_orders[index].products.where((ProductModel e) => e.productID == product.productID).length] = product;
      }
    }
    return products;
  }

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Orders List".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Card(
            elevation: 6,
            shadowColor: dark,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search".tr,
                          contentPadding: const EdgeInsets.all(16),
                          hintStyle: GoogleFonts.itim(color: grey, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                    child: const Icon(FontAwesome.searchengin_brand, color: white, size: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("orders").where("ownerID", isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy('timestamp', descending: true).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                _orders = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => OrderModel.fromJson(e.data())).toList();
                return ListView.separated(
                  itemBuilder: (BuildContext context, int index) => GestureDetector(
                    onLongPress: _orders[index].state == "CONFIRMED"
                        ? null
                        : () {
                            showBottomSheet(
                              context: context,
                              builder: (BuildContext context) => Container(
                                color: white,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("Are you sure ?", style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: <Widget>[
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance.collection("orders").doc(_orders[index].orderID).delete();
                                            showToast(context, "Order deleted successfully".tr);
                                          },
                                          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                          child: Text("OK".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                        ),
                                        const SizedBox(width: 10),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(grey.withOpacity(.3))),
                                          child: Text("CANCEL".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                    child: Card(
                      shadowColor: dark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: white,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("ORDER ID".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Flexible(child: Text(_orders[index].orderID, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("OWNER ID".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Flexible(child: Text(_orders[index].ownerID, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("OWNER NAME".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Flexible(child: Text(_orders[index].ownerName, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("ORDER DATE".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Text(_formatCustomDate(_orders[index].timestamp), style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                  child: Text("STATE".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: _orders[index].state.toUpperCase() == "IN PROGRESS" ? green : blue,
                                  ),
                                  child: Text(
                                    _orders[index].state.toUpperCase().tr,
                                    style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            for (final MapEntry<int, ProductModel> product in _productsCounter(index).entries) ...<Widget>[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: grey.withOpacity(.1)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(image: NetworkImage(product.value.productImages.first.path), fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(product.value.productName, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 5),
                                          Flexible(child: Text(product.value.categoryName, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500))),
                                          const SizedBox(height: 5),
                                          Flexible(
                                            child: Wrap(
                                              crossAxisAlignment: WrapCrossAlignment.start,
                                              alignment: WrapAlignment.start,
                                              runAlignment: WrapAlignment.start,
                                              runSpacing: 10,
                                              spacing: 10,
                                              children: <Widget>[
                                                for (final String choice in product.value.productOptions)
                                                  Card(
                                                    shadowColor: dark,
                                                    color: white,
                                                    elevation: 6,
                                                    borderOnForeground: true,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                    child: Container(
                                                      padding: const EdgeInsets.all(8),
                                                      color: pink,
                                                      child: Text(choice.tr, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold)),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text("${(product.value.productBuyPrice * product.key).toStringAsFixed(2)}" "TND".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                  itemCount: _orders.length,
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                      Text("No Orders Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Wait();
              } else {
                return ErrorScreen(error: snapshot.error.toString());
              }
            },
          ),
        ),
      ],
    );
  }
}
