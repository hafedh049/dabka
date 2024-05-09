import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/helpers/aman_paper_work.dart';
import '../../utils/helpers/direct_installment.dart';
import '../../utils/helpers/general_terms_conditions.dart';
import '../../utils/helpers/installment_period.dart';
import '../../utils/helpers/online_process.dart';
import '../../utils/shared.dart';

class Installment extends StatefulWidget {
  const Installment({super.key});

  @override
  State<Installment> createState() => _InstallmentState();
}

class _InstallmentState extends State<Installment> {
  final List<Widget> _items = <Widget>[
    InstallmentPeriod(),
    GeneralTermsConditions(),
    OnlineProcess(),
    DirectInstallment(),
    AmanPaperWork(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("Installment", style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
        elevation: 6,
        shadowColor: dark,
      ),
      body: Stack(
        children: <Widget>[
          Center(child: Image.asset("assets/images/logo.png", width: 150, height: 150, color: purple.withOpacity(.3))),
          ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => _items[index],
            itemCount: _items.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
