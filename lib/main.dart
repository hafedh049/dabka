import 'package:dabka/models/product_model.dart';
import 'package:dabka/utils/callbacks.dart';
import 'package:dabka/utils/helpers/error.dart';
import 'package:dabka/utils/helpers/wait.dart';
import 'package:dabka/utils/shared.dart';
import 'package:dabka/views/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'views/onboarding/onboarding_holder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: FutureBuilder<bool>(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return !settingsBox!.get("first_time")
                ? const Onboarding()
                : Product(
                    product: ProductModel(
                      categoryID: "111",
                      supplierID: "111",
                      productID: "111",
                      productName: "111",
                      productType: "111",
                      productDescription: "111",
                      productBuyPrice: 10,
                      productSellPrice: 10,
                      productRating: 5,
                      productImages: [
                        "https://scontent.ftun10-1.fna.fbcdn.net/v/t39.30808-6/438221590_986346913495510_3903164562332491714_n.jpg?stp=dst-jpg_s640x640&_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_ohc=zxwSA2WfKh0Q7kNvgGfYDy0&_nc_ht=scontent.ftun10-1.fna&oh=00_AYCOEentOW7IXbSMn3Ksq9gi5ylzZf8zqRly5b_8THe4DQ&oe=66467ABE",
                        "https://scontent.ftun10-1.fna.fbcdn.net/v/t39.30808-6/438221590_986346913495510_3903164562332491714_n.jpg?stp=dst-jpg_s640x640&_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_ohc=zxwSA2WfKh0Q7kNvgGfYDy0&_nc_ht=scontent.ftun10-1.fna&oh=00_AYCOEentOW7IXbSMn3Ksq9gi5ylzZf8zqRly5b_8THe4DQ&oe=66467ABE",
                        "https://scontent.ftun10-1.fna.fbcdn.net/v/t39.30808-6/438221590_986346913495510_3903164562332491714_n.jpg?stp=dst-jpg_s640x640&_nc_cat=110&ccb=1-7&_nc_sid=5f2048&_nc_ohc=zxwSA2WfKh0Q7kNvgGfYDy0&_nc_ht=scontent.ftun10-1.fna&oh=00_AYCOEentOW7IXbSMn3Ksq9gi5ylzZf8zqRly5b_8THe4DQ&oe=66467ABE",
                      ],
                      productShorts: [],
                    ),
                  ); //const Holder();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Wait();
          } else {
            return ErrorScreen(error: snapshot.error.toString());
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
