// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/true_view_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/callbacks.dart';

class AddTrueView extends StatefulWidget {
  const AddTrueView({super.key, required this.user});
  final UserModel user;

  @override
  State<AddTrueView> createState() => _AddTrueViewState();
}

class _AddTrueViewState extends State<AddTrueView> {
  bool _ignoreStupidity = false;
  final List<String> _videoExtensions = const <String>["mp4", "avi", "mkv", "mov", "flv", "wmv", "webm", "mpg", "mpeg", "m4v", "3gp", "3g2", "f4v", "swf", "vob", "ogv"];

  final GlobalKey<State<StatefulWidget>> _videosKey = GlobalKey<State<StatefulWidget>>();

  late final MultiImagePickerController _videoController;

  final Map<ImageFile, VideoPlayerController> _videoPlayerControllers = <ImageFile, VideoPlayerController>{};

  final TextEditingController _packageNameController = TextEditingController();
  final TextEditingController _productBuyPriceController = TextEditingController(text: "0.0");

  final List<ProductModel> _products = <ProductModel>[];

  ProductModel? _selectedProduct;

  @override
  void initState() {
    _videoController = MultiImagePickerController(
      maxImages: 1,
      picker: (bool allowMultiple) async {
        List<XFile> pickedVideos = await ImagePicker().pickMultipleMedia(
          limit: 3,
          maxHeight: 200,
          maxWidth: 200,
          imageQuality: 40,
          requestFullMetadata: false,
        );
        return pickedVideos
            .where((XFile element) => _videoExtensions.contains(element.name.split('.').last))
            .map(
              (XFile e) => ImageFile(
                const Uuid().v8(),
                name: e.name,
                extension: e.name.split('.').last,
                path: e.path,
              ),
            )
            .toList();
      },
    );
    super.initState();
  }

  Future<bool> _loadProducts() async {
    _products.clear();
    await FirebaseFirestore.instance.collection("products").where("supplierID", isEqualTo: widget.user.userID).get().then(
      (QuerySnapshot<Map<String, dynamic>> value) {
        for (final DocumentSnapshot<Map<String, dynamic>> snapshot in value.docs) {
          _products.add(ProductModel.fromJson(snapshot.data()!));
        }
        _selectedProduct = _products.firstOrNull;
      },
    );
    return true;
  }

  @override
  void dispose() {
    _productBuyPriceController.dispose();

    _videoController.dispose();

    for (final VideoPlayerController controller in _videoPlayerControllers.values) {
      controller.dispose();
    }
    _videoPlayerControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
          title: Text('Add True View', style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: purple)),
          backgroundColor: white,
          elevation: 6,
          shadowColor: dark,
          surfaceTintColor: transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: StatefulBuilder(
                    key: _videosKey,
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return InkWell(
                        hoverColor: transparent,
                        splashColor: transparent,
                        highlightColor: transparent,
                        onTap: () async {
                          _videoPlayerControllers.clear();
                          for (final ImageFile video in _videoController.images) {
                            _videoPlayerControllers[video] = await VideoPlayerController.file(File(video.path!))
                              ..initialize();
                          }
                          await showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => Container(
                              padding: const EdgeInsets.all(8),
                              child: MultiImagePickerView(
                                controller: _videoController,
                                initialWidget: DefaultInitialWidget(
                                  centerWidget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(FontAwesome.image_portrait_solid, size: 25, color: Color.fromARGB(255, 137, 0, 161)),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Add Videos',
                                        style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 137, 0, 161)),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                builder: (context, imageFile) => GestureDetector(
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
                          ).then(
                            (void value) async {
                              _videoPlayerControllers.clear();
                              for (final ImageFile video in _videoController.images) {
                                _videoPlayerControllers[video] = await VideoPlayerController.file(File(video.path!))
                                  ..initialize();
                              }
                              _videosKey.currentState!.setState(() {});
                            },
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(FontAwesome.circle_plus_solid, size: 20, color: purple),
                                const SizedBox(height: 10),
                                Text(
                                  'Add Product Shorts${_videoController.hasNoImages ? "" : "\n(${_videoController.images.length})"}',
                                  style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: purple),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  shadowColor: dark,
                  color: white,
                  elevation: 6,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        FutureBuilder(
                          future: _loadProducts(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            return snapshot.hasError
                                ? Center(child: Text(snapshot.error.toString(), style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)))
                                : snapshot.connectionState == ConnectionState.waiting
                                    ? const Center(child: CircularProgressIndicator(color: purple))
                                    : snapshot.hasData && _products.isEmpty
                                        ? const SizedBox()
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Text("Product Name", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                                              const SizedBox(height: 10),
                                              Card(
                                                elevation: 6,
                                                shadowColor: dark,
                                                child: CustomDropdown<ProductModel>.search(
                                                  hintText: "Pick a product",
                                                  items: _products,
                                                  excludeSelected: false,
                                                  initialItem: _products.firstOrNull,
                                                  onChanged: (ProductModel value) => _selectedProduct = value,
                                                ),
                                              ),
                                            ],
                                          );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text("Package Name", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _packageNameController,
                            style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              hintText: "Package Name",
                              hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              labelText: "What is its package",
                              labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.note_sticky, color: grey, size: 15)),
                            ),
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zء-ي ]'))],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text("Price", style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 40,
                          child: TextField(
                            controller: _productBuyPriceController,
                            style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                              hintText: "Price",
                              hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              labelText: "How does it cost to do it",
                              labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                              prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.dollar_sign_solid, color: grey, size: 15)),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[\d\.]'))],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: StatefulBuilder(
                            builder: (BuildContext context, void Function(void Function()) _) {
                              return IgnorePointer(
                                ignoring: _ignoreStupidity,
                                child: InkWell(
                                  hoverColor: transparent,
                                  splashColor: transparent,
                                  highlightColor: transparent,
                                  onTap: () async {
                                    if (_videoController.hasNoImages) {
                                      showToast(context, "Please pick up the true view", color: red);
                                    } else if (_selectedProduct == null) {
                                      showToast(context, "Select the product you want to market", color: red);
                                    } else if (_packageNameController.text.trim().isEmpty) {
                                      showToast(context, "Package name is required", color: red);
                                    } else if (_productBuyPriceController.text.isEmpty || _productBuyPriceController.text.startsWith('.') || _productBuyPriceController.text.startsWith('.') || _productBuyPriceController.text.split('').where((String element) => element == ".").length > 1) {
                                      showToast(context, "Enter a correct buying price", color: red);
                                    } else {
                                      try {
                                        _(() => _ignoreStupidity = true);
                                        showToast(context, "Please wait...");

                                        final List<MediaModel> videoPaths = <MediaModel>[];

                                        final String reelID = const Uuid().v8();

                                        if (_videoController.images.isNotEmpty) {
                                          showToast(context, "Uploading Videos...");
                                        }

                                        for (final ImageFile video in _videoController.images) {
                                          final TaskSnapshot task = await FirebaseStorage.instance.ref().child("/videos/${const Uuid().v8()}${video.name}").putFile(File(video.path!));
                                          showToast(context, "Uploading Video N °${videoPaths.length + 1}");
                                          videoPaths.add(
                                            MediaModel(
                                              ext: video.extension,
                                              name: video.name,
                                              path: await task.ref.getDownloadURL(),
                                              type: "VIDEO",
                                            ),
                                          );
                                          showToast(context, "Video N °${videoPaths.length} Uploaded");
                                        }

                                        if (_videoController.images.isNotEmpty) {
                                          showToast(context, "Videos Uploaded");
                                        }

                                        await FirebaseFirestore.instance.collection("true_views").doc(reelID).set(
                                              TrueViewModel(
                                                categoryID: widget.user.categoryID,
                                                category: widget.user.categoryName,
                                                package: _packageNameController.text.trim(),
                                                price: double.parse(_productBuyPriceController.text.trim()),
                                                reelUrl: videoPaths.first,
                                                reelDuration: _videoPlayerControllers.values.first.value.duration.inSeconds,
                                                reelID: reelID,
                                                userID: widget.user.userID,
                                                userName: widget.user.username,
                                                reelViews: 0,
                                                productID: _selectedProduct!.productID,
                                              ).toJson(),
                                            );

                                        _packageNameController.clear();
                                        _productBuyPriceController.clear();

                                        _videosKey.currentState!.setState(() {});
                                        _videoController.clearImages();

                                        showToast(context, "True View Created Successfully");
                                        _(() => _ignoreStupidity = false);
                                      } catch (e) {
                                        debugPrint(e.toString());
                                        showToast(context, e.toString(), color: red);
                                        _(() => _ignoreStupidity = false);
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purple),
                                    child: Text("ADD TRUE VIEW", style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
