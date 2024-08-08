import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:swifthelp_app/consts/firebase_const.dart';

import '../models/provider_model.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/text_widget.dart';


class ProviderDetailScreen extends StatefulWidget {
  static const routeName = '/ProviderDetails';

  const ProviderDetailScreen({Key? key}) : super(key: key);

  @override
  _ProviderDetailScreenState createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  final _quantityTextController = TextEditingController(text: '1');

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the provider details from the arguments
    final ProviderModel provider =
        ModalRoute.of(context)!.settings.arguments as ProviderModel;
    
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
          child: Icon(
            Icons.arrow_back,
            color: color,
            size: 24,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: FancyShimmerImage(
              imageUrl:  'https://www.seekpng.com/png/detail/73-730482_existing-user-default-avatar.png',
              boxFit: BoxFit.cover,
              width: size.width,
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: provider.name ?? 'Provider Name',
                            color: color,
                            textSize: 28,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text:  'Status : ',
                          color: Colors.green,
                          textSize: 22,
                          isTitle: true,
                        ),
                        const SizedBox(width: 10),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextWidget(
                            text:  'Active Now',
                            color: Colors.white,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextWidget(
                      text: provider.discription ?? 'Provider Description',
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Provider Address',
                                color: Colors.red.shade300,
                                textSize: 20,
                                isTitle: true,
                              ),
                              const SizedBox(height: 5),
                              FittedBox(
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text: provider.address ?? 'Not Available',
                                      color: color,
                                      textSize: 20,
                                      isTitle: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        Flexible(
                          child: Material(
                            color: Color.fromARGB(255, 66, 238, 250),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () async {
                                // You can add actions here like navigating to another screen or making a call
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextWidget(
                                  text: 'View Maps',
                                  color: Colors.black,
                                  textSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                text: 'Mobile Number',
                                color: Colors.red.shade300,
                                textSize: 20,
                                isTitle: true,
                              ),
                              const SizedBox(height: 5),
                              FittedBox(
                                child: Row(
                                  children: [
                                    TextWidget(
                                      text: provider.mobile ?? 'Not Available',
                                      color: color,
                                      textSize: 20,
                                      isTitle: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        Flexible(
                          child: Material(
                            color: Color.fromARGB(255, 66, 238, 250),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: () async {
                                // You can add actions here like navigating to another screen or making a call
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextWidget(
                                  text: 'Call Now',
                                  color: Colors.black,
                                  textSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}