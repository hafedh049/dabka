import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/offer_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';

class OffersList extends StatefulWidget {
  const OffersList({super.key});

  @override
  State<OffersList> createState() => _OffersListState();
}

class _OffersListState extends State<OffersList> with TickerProviderStateMixin {
  List<OfferModel> _offers = <OfferModel>[];
  late final TabController _tabsController;

  @override
  void initState() {
    _tabsController = TabController(length: 1, vsync: this);
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TabBar(
            indicatorColor: purple,
            controller: _tabsController,
            tabs: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Text("Exclusive Offers".tr, style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabsController,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance.collection("offers").orderBy("timestamp", descending: true).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        _offers = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => OfferModel.fromJson(e.data())).toList();
                        return ListView.separated(
                          itemBuilder: (BuildContext context, int index) => Card(
                            shadowColor: dark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            color: white,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: _offers[index].offerImage.isEmpty
                                          ? const DecorationImage(
                                              image: AssetImage('assets/images/thumbnail1.png'),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: CachedNetworkImageProvider(_offers[index].offerImage),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                        child: Text("CATEGORY NAME".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(_offers[index].category.toUpperCase(), style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                        child: Text("OFFER NAME".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(_offers[index].offerName, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                        child: Text("OFFER TYPE".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(_offers[index].offerType, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                        child: Text("OFFER DATE".tr, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(_formatCustomDate(_offers[index].timestamp), style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                          itemCount: _offers.length,
                        );
                      } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true)),
                              Text("No Offers Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
            ),
          ),
        ],
      ),
    );
  }
}
