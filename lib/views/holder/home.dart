import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/helpers/categories_list.dart';
import '../../utils/helpers/error.dart';
import '../../utils/helpers/exclusive_offers.dart';
import '../../utils/helpers/home_ads_carousel.dart';
import '../../utils/helpers/home_dresses.dart';
import '../../utils/helpers/home_filter.dart';
import '../../utils/helpers/home_makeup_artists.dart';
import '../../utils/helpers/home_photographers.dart';
import '../../utils/helpers/home_recommended.dart';
import '../../utils/helpers/home_sellers.dart';
import '../../utils/helpers/installment_offers.dart';
import '../../utils/helpers/wait.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _images = <String>[];
  List<Map<String, dynamic>> _categories = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _exclusiveOffers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _installmentOffers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _dresses = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _makeupArtists = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _photographers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _sellers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _recommended = <Map<String, dynamic>>[];

  final PageController _imagesController = PageController();

  List<Widget> _components = <Widget>[];

  Future<bool> _load() async {
    try {
      _images = jsonDecode(await rootBundle.loadString("assets/jsons/ads.json")).cast<String>();
      _categories = jsonDecode(await rootBundle.loadString("assets/jsons/categories.json")).cast<Map<String, dynamic>>();
      _exclusiveOffers = jsonDecode(await rootBundle.loadString("assets/jsons/exclusive_offers.json")).cast<Map<String, dynamic>>();
      _installmentOffers = jsonDecode(await rootBundle.loadString("assets/jsons/installment_offers.json")).cast<Map<String, dynamic>>();
      _dresses = jsonDecode(await rootBundle.loadString("assets/jsons/dresses.json")).cast<Map<String, dynamic>>();
      _makeupArtists = jsonDecode(await rootBundle.loadString("assets/jsons/makeup_artists.json")).cast<Map<String, dynamic>>();
      _photographers = jsonDecode(await rootBundle.loadString("assets/jsons/photographers.json")).cast<Map<String, dynamic>>();
      _sellers = jsonDecode(await rootBundle.loadString("assets/jsons/sellers.json")).cast<Map<String, dynamic>>();
      _recommended = jsonDecode(await rootBundle.loadString("assets/jsons/recommended.json")).cast<String>();
      _components = <Widget>[
        const HomeFilter(),
        HomeAdsCarousel(images: _images),
        CategoriesList(categories: _categories),
        ExclusiveOffers(exclusiveOffers: _exclusiveOffers),
        InstallmentOffers(installmentOffers: _installmentOffers),
        HomeDresses(dresses: _dresses),
        HomeMakeUpArtists(makeupArtists: _makeupArtists),
        HomePhotographers(photographers: _photographers),
        HomeSellers(sellers: _sellers),
        HomeRecommended(recommended: _recommended),
      ];
      return true;
    } catch (_) {
      debugPrint(_.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _load(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) => _components[index],
            itemCount: _components.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
            padding: EdgeInsets.zero,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Wait();
        } else {
          return ErrorScreen(error: snapshot.error.toString());
        }
      },
    );
  }
}
