import 'package:flutter/material.dart';
import 'package:swifthelp_app/services/utils.dart';
import 'package:swifthelp_app/widgets/categories_widget.dart';
import 'package:swifthelp_app/widgets/text_widget.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/CetagoryScreen';
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
  ];

List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/images/cat/cleaner.png',
      'catText': 'Cleaning',
    },
    {
      'imgPath': 'assets/images/cat/cookingg.png',
      'catText': 'Cooking',
    },
    {
      'imgPath': 'assets/images/cat/gardener.png',
      'catText': 'Gardning',
    },
    {
      'imgPath': 'assets/images/cat/parentcare.png',
      'catText': 'Parent Care',
    },
    {
      'imgPath': 'assets/images/cat/recrycle.png',
      'catText': 'Recrycle',
    },
     {
      'imgPath': 'assets/images/cat/taxis.png',
      'catText': 'Taxis',
    },
    {
      'imgPath': 'assets/images/cat/babysitter.png',
      'catText': 'Babysitter',
    },
    {
      'imgPath': 'assets/images/cat/electrician.png',
      'catText': 'Electrician',
    },
    {
      'imgPath': 'assets/images/cat/forklift.png',
      'catText': 'Forklift',
    },
    {
      'imgPath': 'assets/images/cat/greenhouse.png',
      'catText': 'Greenhouse',
    },
  ];

  @override
  Widget build(BuildContext context) {

    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Categories',
            color: color,
            textSize: 24,
            isTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10, // Vertical spacing
            mainAxisSpacing: 10, // Horizontal spacing 
            children: List.generate(10, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ));
  }
}