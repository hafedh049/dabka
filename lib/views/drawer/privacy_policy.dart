import 'package:dabka/views/drawer/contact_support.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../utils/shared.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> list = <Map<String, dynamic>>[
      <String, dynamic>{
        "tile": "How can I contact the support?".tr,
        "page": const ContactSupport(),
      },
      <String, dynamic>{
        "tile": "Use of your information".tr,
        "page": null,
      },
      <String, dynamic>{
        "tile": "Your E-mail address".tr,
        "page": null,
      },
      <String, dynamic>{
        "tile": "Payment information".tr,
        "page": null,
      },
      <String, dynamic>{
        "tile": "Security".tr,
        "page": null,
      },
      <String, dynamic>{
        "tile": "Contact Us".tr,
        "page": null,
      },
      <String, dynamic>{
        "tile": "Privacy policy for the users of the app".tr,
        "page": null,
      },
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: white,
        title: Text("About Us".tr, style: GoogleFonts.abel(fontSize: 16, fontWeight: FontWeight.bold, color: dark)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 15, color: purple)),
        elevation: 6,
        shadowColor: dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            for (final Map<String, dynamic> item in list) ...<Widget>[
              InkWell(
                hoverColor: transparent,
                splashColor: transparent,
                highlightColor: transparent,
                onTap: item["page"] == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => item["page"])),
                child: Card(
                  elevation: 4,
                  shadowColor: dark,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      children: <Widget>[
                        Text(item["tile"], style: GoogleFonts.abel(fontSize: 10, fontWeight: FontWeight.w500, color: dark)),
                        const Spacer(),
                        const IconButton(onPressed: null, icon: Icon(FontAwesome.chevron_right_solid, size: 15, color: purple)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
