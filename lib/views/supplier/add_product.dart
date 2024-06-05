// ignore_for_file: use_build_context_synchronously, await_only_futures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dabka/models/product_model.dart';
import 'package:dabka/models/user_model.dart';
import 'package:dabka/utils/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../../utils/callbacks.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/wait.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool _ignoreStupidity = false;
  final List<String> _videoExtensions = const <String>["mp4", "avi", "mkv", "mov", "flv", "wmv", "webm", "mpg", "mpeg", "m4v", "3gp", "3g2", "f4v", "swf", "vob", "ogv"];

  final GlobalKey<State<StatefulWidget>> _imagesKey = GlobalKey<State<StatefulWidget>>();
  final GlobalKey<State<StatefulWidget>> _videosKey = GlobalKey<State<StatefulWidget>>();

  final MultiImagePickerController _imageController = MultiImagePickerController(
    maxImages: 10,
    picker: (bool allowMultiple) async {
      final List<XFile> pickedImages = await ImagePicker().pickMultiImage(
        requestFullMetadata: false,
        limit: 3,
      );
      return pickedImages
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

  late final MultiImagePickerController _videoController;

  final Map<ImageFile, VideoPlayerController> _videoPlayerControllers = <ImageFile, VideoPlayerController>{};

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productBuyPriceController = TextEditingController(text: "0.0");
  final TextEditingController _productDescriptionController = TextEditingController();

  @override
  void initState() {
    _videoController = MultiImagePickerController(
      maxImages: 3,
      picker: (bool allowMultiple) async {
        List<XFile> pickedVideos = await ImagePicker().pickMultipleMedia(limit: 3, requestFullMetadata: false);
        return pickedVideos
            .where((XFile element) => _videoExtensions.contains(element.name.split('.').last))
            .map(
              (XFile e) => ImageFile(
                const Uuid().v8(),
                name: e.name,
                extension: e.name.split('.').last,
                path: e.path,
                bytes: File(e.path).readAsBytesSync(),
              ),
            )
            .toList();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productBuyPriceController.dispose();
    _productDescriptionController.dispose();

    _imageController.dispose();
    _videoController.dispose();
    for (final VideoPlayerController controller in _videoPlayerControllers.values) {
      controller.dispose();
    }
    _videoPlayerControllers.clear();
    super.dispose();
  }

  final List<String> _selectedChoices = <String>[];

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> choices = <String, List<String>>{
      "20240525-1317-8525-8839-c5944ca24374": <String>[
        "Pause Vernis".tr,
        "Brushing".tr,
        "Make Up".tr,
        "Acheter".tr,
      ],
      "20240525-1318-8315-8856-e633e68c7eff": <String>[
        "Louer".tr,
        "Acheter".tr,
      ],
      "20240525-1319-8900-a128-354555faf0a7": <String>[
        "Ouverte".tr,
        "Fermée".tr,
        "Louer".tr,
      ],
      "20240525-1320-8302-a906-953deeaaf71d": <String>[
        "Videos".tr,
        "Images".tr,
        "Mixte".tr,
      ],
      "20240525-1320-8a54-b547-4a4c93ac7b3f": <String>[
        "En Tunisie".tr,
        "A L'étranger".tr,
        "Louer".tr,
      ],
      "20240525-1320-8b30-8203-ca85e45b3e5a": <String>[
        "Acheter".tr,
        "Louer".tr,
      ],
    };
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: dark)),
          title: Text('Add Product'.tr, style: GoogleFonts.abel(fontSize: 22, fontWeight: FontWeight.bold, color: dark)),
          backgroundColor: white,
          elevation: 6,
          shadowColor: dark,
          surfaceTintColor: transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData) {
                final UserModel user = UserModel.fromJson(snapshot.data!.data()!);
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: StatefulBuilder(
                          key: _imagesKey,
                          builder: (BuildContext context, void Function(void Function()) _) {
                            return InkWell(
                              hoverColor: transparent,
                              splashColor: transparent,
                              highlightColor: transparent,
                              onTap: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => Container(
                                    padding: const EdgeInsets.all(8),
                                    child: MultiImagePickerView(controller: _imageController),
                                  ),
                                ).then((void value) => _imagesKey.currentState!.setState(() {}));
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
                                      Text('Add Product Images'.tr, style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: purple)),
                                      const SizedBox(height: 10),
                                      if (!_imageController.hasNoImages)
                                        FlutterImageStack.providers(
                                          providers: _imageController.images.map((ImageFile e) => FileImage(File(e.path!))).toList(),
                                          totalCount: _imageController.images.length,
                                          itemBorderColor: purple,
                                          itemCount: 3,
                                          showTotalCount: true,
                                          itemRadius: 40,
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
                                              'Add Videos'.tr,
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
                                        '${"Add Product Shorts".tr}${_videoController.hasNoImages ? "" : "\n(${_videoController.images.length})"}',
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
                      if (choices.containsKey(user.categoryID)) ...<Widget>[
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
                                    for (final String choice in choices[user.categoryID]!)
                                      InkWell(
                                        highlightColor: transparent,
                                        hoverColor: transparent,
                                        splashColor: transparent,
                                        onTap: () {
                                          if (_selectedChoices.contains(choice)) {
                                            _selectedChoices.remove(choice);
                                          } else {
                                            _selectedChoices.add(choice);
                                          }
                                          _(() {});
                                        },
                                        child: Card(
                                          shadowColor: dark,
                                          color: white,
                                          elevation: 6,
                                          borderOnForeground: true,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          child: AnimatedContainer(
                                            duration: 300.milliseconds,
                                            padding: const EdgeInsets.all(8),
                                            color: _selectedChoices.contains(choice) ? pink : white,
                                            child: AnimatedDefaultTextStyle(
                                              style: GoogleFonts.abel(fontSize: 12, color: _selectedChoices.contains(choice) ? white : dark, fontWeight: _selectedChoices.contains(choice) ? FontWeight.bold : FontWeight.w500),
                                              duration: 300.milliseconds,
                                              child: Text(choice.tr),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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
                              Text("Product Name".tr, style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _productNameController,
                                  style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(6),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    hintText: "Product Name".tr,
                                    hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                    labelText: "What is the product called?".tr,
                                    labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                    prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.note_sticky, color: grey, size: 15)),
                                  ),
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zء-ي ]'))],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Product Buying Price".tr, style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
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
                                    hintText: "Buy Price".tr,
                                    hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                    labelText: "How does it cost to buy it".tr,
                                    labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                    prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.dollar_sign_solid, color: grey, size: 15)),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[\d\.]'))],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Product Description".tr, style: GoogleFonts.abel(fontSize: 16, color: dark, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 10),
                              SizedBox(
                                // height: 40,
                                child: TextField(
                                  controller: _productDescriptionController,
                                  maxLines: 5,
                                  minLines: 5,
                                  style: GoogleFonts.abel(color: dark, fontSize: 14, fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(6),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: grey, width: .3)),
                                    hintText: "Description".tr,
                                    hintStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                    labelText: "Describe your product".tr,
                                    labelStyle: GoogleFonts.abel(color: grey, fontSize: 14, fontWeight: FontWeight.w500),
                                    prefixIcon: const IconButton(onPressed: null, icon: Icon(FontAwesome.text_slash_solid, color: grey, size: 15)),
                                  ),
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
                                          if (_imageController.hasNoImages) {
                                            showToast(context, "Please pick up some images for the product".tr, color: red);
                                          } else if (_productNameController.text.trim().isEmpty) {
                                            showToast(context, "Product name is required".tr, color: red);
                                          } else if (_productBuyPriceController.text.isEmpty || _productBuyPriceController.text.startsWith('.') || _productBuyPriceController.text.startsWith('.') || _productBuyPriceController.text.split('').where((String element) => element == ".").length > 1) {
                                            showToast(context, "Enter a correct buying price".tr, color: red);
                                          } else if (_productDescriptionController.text.trim().isEmpty) {
                                            showToast(context, "Product description is mandatory".tr, color: red);
                                          } else {
                                            try {
                                              _(() => _ignoreStupidity = true);
                                              showToast(context, "Please wait...".tr);

                                              final List<MediaModel> imagePaths = <MediaModel>[];
                                              final List<MediaModel> videoPaths = <MediaModel>[];

                                              final String productID = const Uuid().v8();
                                              showToast(context, "Uploading Images...".tr);

                                              for (final ImageFile image in _imageController.images) {
                                                await FirebaseStorage.instance.ref().child("/images/${const Uuid().v8()}${image.name}").putFile(File(image.path!)).then(
                                                  (TaskSnapshot task) async {
                                                    showToast(context, "${'Uploading Image N °'.tr}${imagePaths.length + 1}");
                                                    imagePaths.add(
                                                      MediaModel(
                                                        ext: image.extension,
                                                        name: image.name,
                                                        path: await task.ref.getDownloadURL(),
                                                        type: "IMAGE",
                                                      ),
                                                    );
                                                    showToast(context, "${'Image N °'.tr}${imagePaths.length} ${'Uploaded'.tr}");
                                                  },
                                                );
                                              }

                                              showToast(context, "Images Uploaded".tr);

                                              if (_videoController.images.isNotEmpty) {
                                                showToast(context, "Uploading Videos...".tr);
                                              }

                                              for (final ImageFile video in _videoController.images) {
                                                await FirebaseStorage.instance.ref().child("/videos/${const Uuid().v8()}${video.name}").putFile(File(video.path!)).then(
                                                  (TaskSnapshot task) async {
                                                    showToast(context, "${'Uploading Video N °'.tr}${videoPaths.length + 1}");
                                                    videoPaths.add(
                                                      MediaModel(
                                                        ext: video.extension,
                                                        name: video.name,
                                                        path: await task.ref.getDownloadURL(),
                                                        type: "VIDEO",
                                                      ),
                                                    );
                                                    showToast(context, "${'Video N °'.tr}${videoPaths.length} ${'Uploaded'.tr}");
                                                  },
                                                );
                                              }

                                              if (_videoController.images.isNotEmpty) {
                                                showToast(context, "Videos Uploaded".tr);
                                              }

                                              await FirebaseFirestore.instance.collection("products").doc(productID).set(
                                                    ProductModel(
                                                      productOptions: _selectedChoices,
                                                      categoryName: user.categoryName,
                                                      categoryID: user.categoryID,
                                                      supplierID: user.userID,
                                                      productID: productID,
                                                      productName: _productNameController.text.trim(),
                                                      productDescription: _productDescriptionController.text.trim(),
                                                      productBuyPrice: double.parse(_productBuyPriceController.text),
                                                      productRating: 0,
                                                      productImages: imagePaths,
                                                      productShorts: videoPaths,
                                                    ).toJson(),
                                                  );

                                              _productNameController.clear();
                                              _productBuyPriceController.clear();
                                              _productDescriptionController.clear();

                                              _videosKey.currentState!.setState(() {});
                                              _videoController.clearImages();
                                              _imagesKey.currentState!.setState(() {});
                                              _imageController.clearImages();

                                              showToast(context, "Product Created Successfully".tr);
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
                                          child: Text("Create Product".tr, style: GoogleFonts.abel(color: white, fontSize: 14, fontWeight: FontWeight.bold)),
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
    );
  }
}
