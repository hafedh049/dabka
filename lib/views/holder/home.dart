import 'package:carousel_slider/carousel_slider.dart';
import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _images = <String>[];

  final GlobalKey<State<StatefulWidget>> _imagesKey = GlobalKey<State<StatefulWidget>>();

  final TextEditingController _searchController = TextEditingController();

  final PageController _imagesController = PageController();

  @override
  void dispose() {
    _searchController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          const Divider(color: grey, thickness: .5, height: .5),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: grey,
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                    ),
                  ),
                  InkWell(
                    highlightColor: transparent,
                    splashColor: transparent,
                    hoverColor: transparent,
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      child: const Icon(FontAwesome.searchengin_brand, color: white, size: 25),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StatefulBuilder(
            key: _imagesKey,
            builder: (BuildContext context, void Function(void Function()) _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _imagesController,
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) => Image.asset("assets/images/${_images[index]}", width: MediaQuery.sizeOf(context).width - 2 * 16),
                  ),
                  const SizedBox(height: 10),
                  SmoothPageIndicator(controller: _imagesController, count: _images.length),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Text("Our Categories", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            children: <Widget>[],
          ),
          const SizedBox(height: 20),
          Text("Exclusive Offers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _execlusiveOffers.length,
          ),
          const SizedBox(height: 20),
          Text("Installment Offers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _installmentOffers.length,
          ),
          const SizedBox(height: 20),
          Text("Dresses", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _dresses.length,
          ),
          const SizedBox(height: 20),
          Text("Wedding Venues", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _weddingVenues.length,
          ),
          const SizedBox(height: 20),
          Text("Beauty Centers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _beautyCenters.length,
          ),
          const SizedBox(height: 20),
          Text("Makeup Artists", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _makeupArtists.length,
          ),
          const SizedBox(height: 20),
          Text("Photographers", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _photographers.length,
          ),
          const SizedBox(height: 20),
          Text("Wedding Cars", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _makeupArtists.length,
          ),
          const SizedBox(height: 20),
          Text("Seller", style: GoogleFonts.abel(color: dark, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(),
          const SizedBox(height: 10),
          ListView.separated(
            itemBuilder: (BuildContext context, int index) => Container(),
            separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            itemCount: _sellers.length,
          ),
          const SizedBox(height: 20),
          CarouselSlider.builder(
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int index, int realIndex) => Image.asset("assets/images/${_images[index]}"),
            options: CarouselOptions(),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: controller,
            count: count,
          ),
        ],
      ),
    );
  }
}
