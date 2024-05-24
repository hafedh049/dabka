import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/offer_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/helpers/error.dart';
import '../../../utils/helpers/wait.dart';
import '../../../utils/shared.dart';

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
      return 'Today, at ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == yesterday.day) {
      return 'Yesterday, at ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
    } else if (date.year == today.year && date.month == today.month && date.day == dayBeforeYesterday.day) {
      return '2 days ago, at ${formatDate(date, const <String>[hh, ':', nn, ':', ss, ' ', am])}';
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
            controller: _tabsController,
            tabs: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Text("Exclusive Offers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.w500)),
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
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        color: purple,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                        child: Text("OFFER NAME", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(_offers[index].offerName, style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        color: purple,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                        child: Text("OFFER TYPE", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(child: Text(_offers[index].offerType, style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        color: purple,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                                        child: Text("OFFER DATE", style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(_formatCustomDate(_offers[index].timestamp), style: GoogleFonts.abel(fontSize: 10, color: dark, fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                          itemCount: 0,
                        );
                      } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(child: LottieBuilder.asset("assets/lotties/empty.json", reverse: true)),
                              Text("No Offers Yet!", style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
