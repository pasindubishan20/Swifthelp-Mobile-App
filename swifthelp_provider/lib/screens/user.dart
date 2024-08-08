import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:swifthelp_provider/consts/firebase_const.dart';
import 'package:swifthelp_provider/screens/auth/forget_pass.dart';
import 'package:swifthelp_provider/screens/auth/login.dart';
import 'package:swifthelp_provider/screens/btm_bar.dart';
import 'package:swifthelp_provider/screens/customer_service.dart';
import 'package:swifthelp_provider/screens/loading_manager.dart';
import 'package:swifthelp_provider/screens/orders/orders_screen.dart';
import 'package:swifthelp_provider/screens/orders/orders_widget.dart';
import 'package:swifthelp_provider/services/global_methods.dart';
import 'package:swifthelp_provider/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../provider/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
      final TextEditingController _mobileTextController =
      TextEditingController(text: ""); 
      final TextEditingController _discripTextController = 
      TextEditingController(text: "");

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _addressTextController.dispose();
    _mobileTextController.dispose();
    _discripTextController.dispose();
    super.dispose();
  }

  String? _email;
  String? _name;
  String? _address;
  String? _mobile;
  String? _discrip;

  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('providers').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        _address = userDoc.get('shipping-address');
        _mobile = userDoc.get('mobile-number');
        _addressTextController.text = userDoc.get('shipping-address');
        _mobileTextController.text = userDoc.get('mobile-number');
        _discrip = userDoc.get('discription');
        _discripTextController.text = userDoc.get('discription');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '${error}', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: Color.fromARGB(95, 238, 236, 236),
        body: LoadingManager(
      isLoading: _isLoading,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 15,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Profile,  ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Info',
                          style: TextStyle(
                            color: color,
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('My name is pressed');
                            }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Hi,  ',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: _name ?? 'Provider',
                          style: TextStyle(
                            color: color,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('My name is pressed');
                            }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: _email ?? 'Email',
                  color: color,
                  textSize: 18,
                  // isTitle: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                _listTiles(
                  title: _address ?? 'Address',
                  subtitle: 'Your Address',
                  icon: IconlyLight.location,
                  onPressed: () async {
                    await _showAddressDialog();
                  },
                  color: color,
                ),
                _listTiles(
                  title: _mobile ?? 'Mobile Number',
                  subtitle: 'Your Mobile Number',
                  icon: IconlyLight.call,
                  onPressed: () async {
                    await _showMobileDialog();
                  },
                  color: color,
                ),
                _listTiles(
                  title:  'Update Profile Discription',
                  subtitle: 'Your Profile Discription',
                  icon: IconlyLight.arrowDownCircle,
                  onPressed: () async {
                    await _showDiscripDialog();
                  },
                  color: color,
                ),
                _listTiles(
                  title: 'Orders',
                  subtitle: 'Requested Orders',
                  icon: IconlyLight.bag,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context, routeName: OrdersScreen.routeName);
                  },
                  color: color,
                ),
                _listTiles(
                  title: 'Forget password',
                  subtitle: 'Change Your Password',
                  icon: IconlyLight.unlock,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: ForgetPasswordScreen.routeName);
                  },
                  color: color,
                ),
                _listTiles(
                  title: 'SwiftHelp Agent',
                  subtitle: 'Get a Help',
                  icon: IconlyLight.send,
                  onPressed: () {
                    GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: CustomerServiceScreen.routeName);
                  },
                  color: color,
                ),
                _listTiles(
                  title: user == null ? 'Login' : 'Logout',
                  subtitle: 'Your Account',
                  icon: user == null ? IconlyLight.login : IconlyLight.logout,
                  onPressed: () {
                    if (user == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      return;
                    }
                    GlobalMethods.warningDialog(
                        title: 'Logout',
                        subtitle: 'Do you want to logout?',
                        fct: () async {
                          await authInstance.signOut();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        context: context);
                  },
                  color: color,
                ),
                SwitchListTile(
                  title: TextWidget(
                    text: themeState.getDarkTheme ? 'Dark mode' : 'Light mode',
                    color: color,
                    textSize: 24,
                    // isTitle: true,
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                //listTileAsRow(),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              onChanged: (value) {
                _addressTextController.text;
              },
              controller: _addressTextController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: "Enter Your Address"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    String _uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance
                          .collection('providers')
                          .doc(_uid)
                          .update({
                        'shipping-address': _addressTextController.text,
                      });
                      Navigator.pop(context);
                      setState(() {
                        _address = _addressTextController.text;
                      });
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: context);
                    }
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  Future<void> _showMobileDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              onChanged: (value) {
                _mobileTextController.text;
              },
              controller: _mobileTextController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: "Enter Your Number"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    String _uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance
                          .collection('providers')
                          .doc(_uid)
                          .update({
                        'mobile-number': _mobileTextController.text,
                      });
                      Navigator.pop(context);
                      setState(() {
                        _mobile = _mobileTextController.text;
                      });
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: context);
                    }
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  Future<void> _showDiscripDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              onChanged: (value) {
                _discripTextController.text;
              },
              controller: _discripTextController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: "Enter Your Discription"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    String _uid = user!.uid;
                    try {
                      await FirebaseFirestore.instance
                          .collection('providers')
                          .doc(_uid)
                          .update({
                        'discription': _discripTextController.text,
                      });
                      Navigator.pop(context);
                      setState(() {
                        _discrip = _discripTextController.text;
                      });
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: context);
                    }
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle ?? "",
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }

// Alternative code for the listTile.
//   Widget listTileAsRow() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           const Icon(Icons.settings),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('Title'),
//               Text('Subtitle'),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.chevron_right)
//         ],
//       ),
//     );
//   }
}
