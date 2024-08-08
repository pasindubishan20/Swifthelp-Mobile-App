import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:swifthelp_app/consts/firebase_const.dart';
import 'package:swifthelp_app/providers/cart_provider.dart';
import 'package:swifthelp_app/providers/products_provider.dart';
import 'package:swifthelp_app/providers/viewed_prod_provider.dart';
import 'package:swifthelp_app/providers/wishlist_provider.dart';
import 'package:swifthelp_app/services/global_methods.dart';
import 'package:swifthelp_app/widgets/heart_btn.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/utils.dart';
import '../widgets/text_widget.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _quantityTextController = TextEditingController(text: '1');
  DateTime? _selectedDateTime;

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    DateTime now = DateTime.now();

    // Pick date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      // Pick time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(now),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveDateTimeToFirebase(String productId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null && _selectedDateTime != null) {
      try {
        await FirebaseFirestore.instance.collection('productSelections').add({
          'userId': user.uid,
          'productId': productId,
          'selectedDateTime': _selectedDateTime,
        });
      } catch (e) {
        GlobalMethods.errorDialog(
          subtitle: 'Failed to save date and time: $e',
          context: context,
        );
      }
    } else {
      GlobalMethods.errorDialog(
        subtitle: 'No user found or no date selected.',
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productProviders = Provider.of<ProductsProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProviders.findProById(productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(_quantityTextController.text);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isIWishlist =
        wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);
    final viewedProdItemsList =
        viewedProdProvider.getViewedProdlistItems.values;
    return WillPopScope(
      onWillPop: () async {
        viewedProdProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () =>
                  Navigator.canPop(context) ? Navigator.pop(context) : null,
              child: Icon(
                IconlyLight.arrowLeft2,
                color: color,
                size: 24,
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor),
        body: Column(children: [
          Flexible(
            flex: 2,
            child: FancyShimmerImage(
              imageUrl: getCurrentProduct.imageUrl,
              boxFit: BoxFit.scaleDown,
              width: size.width,
            ),
          ),
          Flexible(
            flex: 4,
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
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: getCurrentProduct.title,
                            color: color,
                            textSize: 25,
                            isTitle: true,
                          ),
                        ),
                        HeartBTN(
                          productId: getCurrentProduct.id,
                          isInWishlist: _isIWishlist,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          text: 'Rs.${usedPrice.toStringAsFixed(2)}/',
                          color: Colors.green,
                          textSize: 22,
                          isTitle: true,
                        ),
                        TextWidget(
                          text: getCurrentProduct.isPiece ? 'Day' : 'Hour',
                          color: color,
                          textSize: 12,
                          isTitle: false,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: getCurrentProduct.isOnSale ? true : false,
                          child: Text(
                            'Rs.${getCurrentProduct.price.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 15,
                                color: color,
                                decoration: TextDecoration.lineThrough),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(63, 200, 101, 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextWidget(
                            text: 'Active',
                            color: Colors.white,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        quantityControl(
                          fct: () {
                            if (_quantityTextController.text == '1') {
                              return;
                            } else {
                              setState(() {
                                _quantityTextController.text =
                                    (int.parse(_quantityTextController.text) - 1)
                                        .toString();
                              });
                            }
                          },
                          
                          icon: CupertinoIcons.minus,
                          color: Colors.red,
                        ),
                      const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextField(
                            controller: _quantityTextController,
                            key: const ValueKey('quantity'),
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                            textAlign: TextAlign.center,
                            cursorColor: Colors.green,
                            enabled: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  _quantityTextController.text = '1';
                                } else {}
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        quantityControl(
                          fct: () {
                            setState(() {
                              _quantityTextController.text =
                                  (int.parse(_quantityTextController.text) + 1)
                                      .toString();
                            });
                          },
                          icon: CupertinoIcons.plus,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: TextWidget(
                            text: getCurrentProduct.discription,
                            color: color,
                            textSize: 20,
                            isTitle: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Total',
                                    color: Colors.red.shade300,
                                    textSize: 20,
                                    isTitle: true,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        TextWidget(
                                          text:
                                              'Rs.${totalPrice.toStringAsFixed(2)}/',
                                          color: color,
                                          textSize: 20,
                                          isTitle: true,
                                        ),
                                        TextWidget(
                                          text: '${_quantityTextController.text}',
                                          color: color,
                                          textSize: 16,
                                          isTitle: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Material(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () async {
                                    final User? user = FirebaseAuth.instance.currentUser;
                                    if (user == null) {
                                      GlobalMethods.errorDialog(
                                          subtitle:
                                              'No user found, Please login first!',
                                          context: context);
                                      return;
                                    }
                                    if (_isInCart) {
                                      return;
                                    }
                                    await GlobalMethods.addToCart(
                                        productId: getCurrentProduct.id,
                                        quantity: int.parse(_quantityTextController.text),
                                        context: context);
                                    await cartProvider.fetchCart();
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: TextWidget(
                                          text:
                                              _isInCart ? 'In Cart' : 'Add To Cart',
                                          color: Colors.white,
                                          textSize: 18)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        ElevatedButton(
                          onPressed: _pickDateTime,
                          child: Text(_selectedDateTime == null
                              ? 'Pick Date & Time'
                              : 'Selected Date & Time: ${_selectedDateTime!.toLocal()}'),
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _saveDateTimeToFirebase(productId),
                            child: Text('Save Date & Time'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget quantityControl(
      {required VoidCallback fct, required IconData icon, required Color color}) {
    return GestureDetector(
      onTap: fct,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 30,
          color: color,
        ),
      ),
    );
  }
}