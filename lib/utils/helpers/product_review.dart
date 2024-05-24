// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/review_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../shared.dart';

class ProductReview extends StatefulWidget {
  const ProductReview({super.key, required this.product});
  final ProductModel product;
  @override
  State<ProductReview> createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _applierNameController = TextEditingController();

  double _rating = 0;

  @override
  void dispose() {
    _applierNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Text("Reviews", style: GoogleFonts.abel(color: dark, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: Card(
              shadowColor: dark,
              elevation: 4,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('reviews').orderBy('timestamp', descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData) {
                    final List<ReviewModel> reviews = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> review) => ReviewModel.fromJson(review.data())).toList();
                    return Column(
                      children: <Widget>[
                        Card(
                          shadowColor: dark,
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                Text("Over all rate", style: GoogleFonts.abel(color: grey, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Card(
                                  color: white,
                                  shadowColor: dark,
                                  elevation: 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          widget.product.productRating.toStringAsFixed(1),
                                          style: GoogleFonts.abel(color: purple, fontSize: 10, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(FontAwesome.star, size: 9, color: purple),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  splashColor: transparent,
                                  hoverColor: transparent,
                                  highlightColor: transparent,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Leave a review", style: GoogleFonts.abel(color: purple, fontSize: 18, fontWeight: FontWeight.w500)),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height: 40,
                                              child: StatefulBuilder(
                                                builder: (BuildContext context, void Function(void Function()) _) {
                                                  return TextField(
                                                    controller: _applierNameController,
                                                    style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                                    decoration: InputDecoration(
                                                      contentPadding: const EdgeInsets.all(6),
                                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                      hintText: "What is your name",
                                                      hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                                      labelText: "Your name",
                                                      labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                                      prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.user, color: grey, size: 15)),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            StatefulBuilder(
                                              builder: (BuildContext context, void Function(void Function()) _) {
                                                return TextField(
                                                  controller: _descriptionController,
                                                  minLines: 4,
                                                  maxLines: 4,
                                                  style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                                  decoration: InputDecoration(
                                                    contentPadding: const EdgeInsets.all(6),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                                    hintText: "Write something",
                                                    hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                                    labelText: "Description",
                                                    labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                                    prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.envelope_solid, color: grey, size: 15)),
                                                  ),
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            StatefulBuilder(
                                              builder: (BuildContext context, void Function(void Function()) _) {
                                                return RatingBar.builder(
                                                  initialRating: _rating,
                                                  minRating: 0,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemSize: 25,
                                                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                  itemBuilder: (BuildContext context, int _) => const Icon(Icons.star, color: purple),
                                                  onRatingUpdate: (double rating) => _(() => _rating = rating),
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              children: <Widget>[
                                                const Spacer(),
                                                TextButton(
                                                  onPressed: () async {
                                                    if (_applierNameController.text.trim().isEmpty) {
                                                      showToast(context, "Please provide your name");
                                                    } else if (_descriptionController.text.trim().isEmpty) {
                                                      showToast(context, "Write your review");
                                                    } else {
                                                      final String reviewID = const Uuid().v8();
                                                      await FirebaseFirestore.instance.collection('reviews').doc(reviewID).set(
                                                            ReviewModel(
                                                              reviewID: reviewID,
                                                              applierName: _applierNameController.text.trim(),
                                                              productID: widget.product.productID,
                                                              rating: _rating,
                                                              comment: _descriptionController.text.trim(),
                                                              timestamp: Timestamp.now().toDate(),
                                                            ).toJson(),
                                                          );
                                                      showToast(context, "Review submitted");
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                                  child: Text("Submit", style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                                                ),
                                                const SizedBox(width: 10),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(blue)),
                                                  child: Text("Cancel", style: GoogleFonts.abel(color: white, fontSize: 12, fontWeight: FontWeight.w500)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text("Write review", style: GoogleFonts.abel(color: grey, fontSize: 12, fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: reviews.isEmpty
                              ? Column(
                                  children: <Widget>[
                                    Expanded(child: LottieBuilder.asset("assets/lotties/empty.json")),
                                    Text("No reviews yet", style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500)),
                                  ],
                                )
                              : PageView.builder(
                                  itemCount: reviews.length,
                                  itemBuilder: (BuildContext context, int index) => Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(reviews[index].applierName, style: GoogleFonts.abel(color: dark, fontSize: 20, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 10),
                                        Flexible(child: Text(reviews[index].comment, style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500))),
                                        const SizedBox(height: 10),
                                        Text(_formatCustomDate(reviews[index].timestamp), style: GoogleFonts.abel(color: dark.withOpacity(.6), fontSize: 10, fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Wait();
                  } else {
                    return ErrorScreen(error: snapshot.error.toString());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
