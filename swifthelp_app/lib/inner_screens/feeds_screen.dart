import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:swifthelp_app/consts/constss.dart';
import 'package:swifthelp_app/models/products_model.dart';
import 'package:swifthelp_app/providers/products_provider.dart';
import 'package:swifthelp_app/widgets/back_widget.dart';
import 'package:swifthelp_app/widgets/empty_products_widget.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/feed_items.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreenState";
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final TextEditingController? _searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];
  @override
  void dispose() {
    _searchTextController!.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
  //   productsProvider.fetchProducts();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    return Scaffold(
      appBar: AppBar(
        leading: const BackWidget(),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: TextWidget(
          text: 'All Services',
          color: color,
          textSize: 20.0,
          isTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: TextField(
                focusNode: _searchTextFocusNode,
                controller: _searchTextController,
                onChanged: (valuee) {
                  setState(() {
                    listProductSearch = productProviders.searchQuery(valuee);
                  });
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.greenAccent, width: 1),
                  ),
                  hintText: "What's in your mind",
                  prefixIcon: const Icon(Icons.search),
                  suffix: IconButton(
                    onPressed: () {
                      _searchTextController!.clear();
                      _searchTextFocusNode.unfocus();
                    },
                    icon: Icon(
                      Icons.close,
                      color: _searchTextFocusNode.hasFocus ? Colors.red : color,
                    ),
                  ),
                ),
              ),
            ),
          ),
         _searchTextController!.text.isNotEmpty &&
                        listProductSearch.isEmpty
                    ? const EmptyProdWidget(text: 'No Services Found!')
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.zero,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: size.width / (size.height * 0.53),
                          children: List.generate(
                              _searchTextController!.text.isNotEmpty
                                  ? listProductSearch.length
                                  : allProducts.length, (index) {
                            return ChangeNotifierProvider.value(
                              value: _searchTextController!.text.isNotEmpty
                                  ? listProductSearch[index]
                                  : allProducts[index],
                              child: const FeedsWidget(),
                            );
                          }),
                        ),
                      ),
        ]),
      ),
    );
  }
}
