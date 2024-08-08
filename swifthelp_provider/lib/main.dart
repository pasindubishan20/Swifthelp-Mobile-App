import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:swifthelp_provider/fetch_screen.dart';
import 'package:swifthelp_provider/firebase_options.dart';
import 'package:swifthelp_provider/provider/dark_theme_provider.dart';
import 'package:swifthelp_provider/providers/orders_provider.dart';
import 'package:swifthelp_provider/providers/products_provider.dart';
import 'package:swifthelp_provider/providers/viewed_prod_provider.dart';
import 'package:swifthelp_provider/screens/auth/forget_pass.dart';
import 'package:swifthelp_provider/screens/auth/login.dart';
import 'package:swifthelp_provider/screens/auth/register.dart';
import 'package:swifthelp_provider/screens/categories.dart';
import 'package:swifthelp_provider/screens/customer_service.dart';
import 'package:swifthelp_provider/screens/orders/orders_widget.dart';
import 'package:provider/provider.dart';

import 'consts/theme_data.dart';


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
                create: (_) => OrdersProvider(),
              ),
        ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
        ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child,) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Swift Help App',
                  theme: Styles.themeData(themeProvider.getDarkTheme, context),
                  home: const FetchScreen(),
                  routes: {
                    
                    CustomerServiceScreen.routeName: (ctx) => const CustomerServiceScreen(),
                    DashboardScreen.routeName: (ctx) => const DashboardScreen(),
                    OrdersScreen.routeName: (context) => const OrdersScreen(),
                    RegisterScreen.routeName: (ctx) => const RegisterScreen(),
                    LoginScreen.routeName: (ctx) => const LoginScreen(),
                    ForgetPasswordScreen.routeName: (ctx) =>
                        const ForgetPasswordScreen(),
                  });
            }),
          );
        });
  }
}
