// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/views/supplier/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../utils/callbacks.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';
import '../../utils/shared.dart';
import 'edit_product.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final GlobalKey<State<StatefulWidget>> _searchKey = GlobalKey<State<StatefulWidget>>();

  final TextEditingController _searchController = TextEditingController();

  List<ProductModel> _products = <ProductModel>[];

  Map<ProductModel, MultiImagePickerController> _images = <ProductModel, MultiImagePickerController>{};
  Map<ProductModel, MultiImagePickerController> _videos = <ProductModel, MultiImagePickerController>{};

  final Map<ImageFile, VideoPlayerController> _videoPlayerControllers = <ImageFile, VideoPlayerController>{};

  @override
  void dispose() {
    for (final MultiImagePickerController image in _images.values) {
      image.dispose();
    }
    for (final MultiImagePickerController video in _videos.values) {
      video.dispose();
    }

    for (final VideoPlayerController videoController in _videoPlayerControllers.values) {
      videoController.dispose();
    }
    _searchController.dispose();
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
            Text("Products List".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
            const Spacer(),
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddProduct())),
              icon: const Icon(FontAwesome.circle_plus_solid, color: purple, size: 25),
            ),
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
                        onChanged: (String value) => _searchKey.currentState!.setState(() {}),
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
            stream: FirebaseFirestore.instance.collection("products").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return StatefulBuilder(
                  key: _searchKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    _products = snapshot.data!.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> e) => ProductModel.fromJson(e.data())).where((ProductModel element) => element.productName.toLowerCase().contains(_searchController.text.trim().toLowerCase())).toList();
                    _images = <ProductModel, MultiImagePickerController>{
                      for (final ProductModel product in _products)
                        product: MultiImagePickerController(
                          images: <ImageFile>[
                            for (final MediaModel image in product.productImages)
                              ImageFile(
                                const Uuid().v8(),
                                name: image.name,
                                extension: image.ext,
                                path: image.path,
                              ),
                          ],
                          picker: (bool allowMultiple) async {
                            return <ImageFile>[
                              for (final MediaModel image in product.productImages)
                                ImageFile(
                                  const Uuid().v8(),
                                  name: image.name,
                                  extension: image.ext,
                                  path: image.path,
                                ),
                            ];
                          },
                        ),
                    };
                    _videos = <ProductModel, MultiImagePickerController>{
                      for (final ProductModel product in _products)
                        product: MultiImagePickerController(
                          images: <ImageFile>[
                            for (final MediaModel video in product.productShorts)
                              ImageFile(
                                const Uuid().v8(),
                                name: video.name,
                                extension: video.ext,
                                path: video.path,
                              ),
                          ],
                          picker: (bool allowMultiple) async {
                            return <ImageFile>[
                              for (final MediaModel video in product.productShorts)
                                ImageFile(
                                  const Uuid().v8(),
                                  name: video.name,
                                  extension: video.ext,
                                  path: video.path,
                                ),
                            ];
                          },
                        ),
                    };
                    return ListView.separated(
                      itemBuilder: (BuildContext context, int index) => GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditProduct(product: _products[index]))),
                        onLongPress: () {
                          showBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              color: white,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Are you sure ?".tr, style: GoogleFonts.abel(fontSize: 14, color: dark, fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: <Widget>[
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          await Future.wait(
                                            <Future>[
                                              FirebaseFirestore.instance.collection("products").doc(snapshot.data!.docs[index].id).delete(),
                                              FirebaseFirestore.instance.collection("true_views").where("productID", isEqualTo: _products[index].productID).get().then(
                                                    (QuerySnapshot<Map<String, dynamic>> value) async => await Future.wait(
                                                      <Future>[for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in value.docs) doc.reference.delete()],
                                                    ),
                                                  ),
                                            ],
                                          );

                                          showToast(context, "Product deleted successfully".tr);
                                          Navigator.pop(context);
                                        },
                                        style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(purple)),
                                        child: Text("OK".tr, style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.w500)),
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
                                Center(
                                  child: InkWell(
                                    hoverColor: transparent,
                                    splashColor: transparent,
                                    highlightColor: transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) => Container(
                                          padding: const EdgeInsets.all(8),
                                          child: MultiImagePickerView(
                                            controller: _images.values.elementAt(index),
                                            addMoreButton: const SizedBox(),
                                            initialWidget: DefaultInitialWidget(centerWidget: Text("Tap to Show".tr, style: GoogleFonts.abel(fontSize: 18, color: purple, fontWeight: FontWeight.bold))),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 4,
                                      borderOnForeground: true,
                                      color: white,
                                      shadowColor: dark,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: FlutterImageStack(
                                          imageList: _products[index].productImages.map((MediaModel e) => e.path).toList(),
                                          totalCount: _products[index].productImages.length,
                                          itemBorderColor: purple,
                                          itemCount: 2,
                                          showTotalCount: true,
                                          itemRadius: 80,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: InkWell(
                                    hoverColor: transparent,
                                    splashColor: transparent,
                                    highlightColor: transparent,
                                    onTap: _videos[_products[index]]!.hasNoImages
                                        ? null
                                        : () async {
                                            for (final ImageFile video in _videos[_products[index]]!.images) {
                                              _videoPlayerControllers[video] = await VideoPlayerController.networkUrl(Uri.parse(video.path!));
                                              await _videoPlayerControllers[video]!.initialize();
                                            }
                                            await showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) => Container(
                                                padding: const EdgeInsets.all(8),
                                                child: MultiImagePickerView(
                                                  controller: _videos[_products[index]]!,
                                                  initialWidget: DefaultInitialWidget(centerWidget: Text('Tap to open'.tr, style: GoogleFonts.abel(fontSize: 18, fontWeight: FontWeight.bold, color: purple))),
                                                  builder: (BuildContext context, ImageFile imageFile) => GestureDetector(
                                                    onTap: () async {
                                                      await _videoPlayerControllers[imageFile]!.play();
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext context) => StatefulBuilder(
                                                          builder: (BuildContext context, void Function(void Function()) setS) {
                                                            return InkWell(
                                                              splashColor: transparent,
                                                              hoverColor: transparent,
                                                              highlightColor: transparent,
                                                              onTap: () async {
                                                                if (_videoPlayerControllers[imageFile]!.value.isPlaying) {
                                                                  await _videoPlayerControllers[imageFile]!.pause();
                                                                } else {
                                                                  await _videoPlayerControllers[imageFile]!.play();
                                                                }
                                                                setS(() {});
                                                              },
                                                              child: ClipRRect(
                                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                                child: VideoPlayer(_videoPlayerControllers[imageFile]!),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ).then(
                                                        (void value) async {
                                                          await _videoPlayerControllers[imageFile]!.seekTo(0.seconds);
                                                          await _videoPlayerControllers[imageFile]!.pause();
                                                        },
                                                      );
                                                    },
                                                    child: DefaultDraggableItemWidget(imageFile: imageFile),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    child: Card(
                                      elevation: 4,
                                      borderOnForeground: true,
                                      color: white,
                                      shadowColor: dark,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          '${"Videos".tr} ${_videos[_products[index]]!.hasNoImages ? "(${'EMPTY'.tr})" : "(${_videos[_products[index]]!.images.length})"}',
                                          style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: purple),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PRODUCT ID".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_products[index].productID, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PRODUCT NAME".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_products[index].productName, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PRODUCT DESCRIPTION".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text(_products[index].productDescription, style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PRODUCT BUYING PRICE".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(child: Text("${_products[index].productBuyPrice.toStringAsFixed(2)} TND", style: GoogleFonts.abel(fontSize: 12, color: dark, fontWeight: FontWeight.w500))),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(color: purple, borderRadius: BorderRadius.circular(5)),
                                      child: Text("PRODUCT RATING".tr, style: GoogleFonts.abel(fontSize: 14, color: white, fontWeight: FontWeight.w500)),
                                    ),
                                    const SizedBox(width: 10),
                                    RatingBar.builder(
                                      initialRating: _products[index].productRating,
                                      ignoreGestures: true,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemSize: 20,
                                      itemBuilder: (BuildContext context, _) => const Icon(Icons.star, color: Colors.amber),
                                      onRatingUpdate: (double rating) {},
                                    ),
                                  ],
                                ),
                                if (_products[index].productOptions.isNotEmpty) ...<Widget>[
                                  const SizedBox(height: 20),
                                  Card(
                                    shadowColor: dark,
                                    color: white,
                                    elevation: 6,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context, void Function(void Function()) _) {
                                          return Wrap(
                                            alignment: WrapAlignment.center,
                                            crossAxisAlignment: WrapCrossAlignment.center,
                                            runAlignment: WrapAlignment.center,
                                            runSpacing: 20,
                                            spacing: 20,
                                            children: <Widget>[
                                              for (final String choice in _products[index].productOptions)
                                                Card(
                                                  shadowColor: dark,
                                                  color: white,
                                                  elevation: 6,
                                                  borderOnForeground: true,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                  child: AnimatedContainer(
                                                    duration: 300.milliseconds,
                                                    padding: const EdgeInsets.all(8),
                                                    color: pink,
                                                    child: AnimatedDefaultTextStyle(
                                                      style: GoogleFonts.abel(fontSize: 12, color: white, fontWeight: FontWeight.bold),
                                                      duration: 300.milliseconds,
                                                      child: Text(choice.tr),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
                      itemCount: _products.length,
                    );
                  },
                );
              } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      LottieBuilder.asset("assets/lotties/empty.json", reverse: true),
                      Text("No Products Yet!".tr, style: GoogleFonts.abel(fontSize: 18, color: dark, fontWeight: FontWeight.w500)),
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
