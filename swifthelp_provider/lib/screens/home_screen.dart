import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:swifthelp_provider/models/products_model.dart';
import 'package:swifthelp_provider/providers/products_provider.dart';
import 'package:swifthelp_provider/services/utils.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _offerImages = [
    'assets/images/offres/Offer1.jpg',
    'assets/images/offres/Offer2.jpg',
    'assets/images/offres/Offer3.jpg',
    'assets/images/offres/Offer4.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    final Color color = Utils(context).color;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
        List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    _offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: _offerImages.length,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.red)),
                // control: const SwiperControl(color: Colors.black),
              ),
            ),
            Column(
          children: [
            const SizedBox(height: 20),
            TextWidget(text: 'Welcome SwiftHelp Providers', textSize: 30, color: Colors.red),
            const SizedBox(height: 15),
            TextWidget(text: 'Sell & Earn', textSize: 20, color: Color.fromARGB(255, 15, 98, 131)),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  
                  ButtonsWidget(
                      onPressed: () {},
                      text: 'Panel',
                      icon: Icons.view_agenda,
                      backgroundColor: Colors.blue),
                ],
              ),
            ),
            const SizedBox(
                    height: 28,
                  ),
            Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Welcome to ServiceHub, the ultimate app designed to connect you with skilled professionals for all your essential needs. Whether you are looking for a reliable cleaner, a seasoned farmer, or a talented cook, ServiceHub makes it easy to find and book top-quality services right at your fingertips.',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
            TextWidget(text: '----  Features  ----', textSize: 30, color: Colors.red),
            const SizedBox(height: 19),
            Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Cleaning Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Cooking Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Gardening Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Painting Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Pest control Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Plastic and Iron Collecting Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Children or Elder Care Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Shifting House Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Smart Home Integration Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: '✅  Green Living Area Service',
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
          ],
        ),
      ),
    );
  }
}
