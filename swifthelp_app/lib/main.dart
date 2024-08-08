import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swifthelp_app/fetch_screen.dart';
import 'package:swifthelp_app/firebase_options.dart';
import 'package:swifthelp_app/inner_screens/cat_screen.dart';
import 'package:swifthelp_app/inner_screens/feeds_screen.dart';
import 'package:swifthelp_app/inner_screens/on_sale_screen.dart';
import 'package:swifthelp_app/inner_screens/product_details.dart';
import 'package:swifthelp_app/provider/dark_theme_provider.dart';
import 'package:swifthelp_app/providers/cart_provider.dart';
import 'package:swifthelp_app/providers/orders_provider.dart';
import 'package:swifthelp_app/providers/products_provider.dart';
import 'package:swifthelp_app/providers/viewed_prod_provider.dart';
import 'package:swifthelp_app/providers/wishlist_provider.dart';
import 'package:swifthelp_app/screens/auth/forget_pass.dart';
import 'package:swifthelp_app/screens/auth/login.dart';
import 'package:swifthelp_app/screens/auth/register.dart';
import 'package:swifthelp_app/screens/customer_service.dart';
import 'package:swifthelp_app/screens/orders/orders_widget.dart';
import 'package:swifthelp_app/screens/viewed_recently/viewed_recently.dart';
import 'package:swifthelp_app/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';
import 'providers/provider_provider.dart';
import 'screens/provider_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text('An error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(
                create: (_) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ProviderProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => ViewedProdProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => OrdersProvider(),
              ),
              
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Swift Help App',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: const FetchScreen(),
                  routes: {
                    OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                    CustomerServiceScreen.routeName: (ctx) => const CustomerServiceScreen(),
                    FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                    ProductDetails.routeName: (ctx) => const ProductDetails(),
                    WishlistScreen.routeName: (ctx) => const WishlistScreen(),
                    OrdersScreen.routeName: (context) => const OrdersScreen(),
                    ViewedRecentlyScreen.routeName: (context) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                    CategoryScreen.routeName: (ctx) => const CategoryScreen(),
                    ProviderDetailScreen.routeName: (context) => const ProviderDetailScreen(),
                  });
            }),
          );
        });
  }
}
