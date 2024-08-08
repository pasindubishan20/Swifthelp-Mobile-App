import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swifthelp_app/inner_screens/feeds_screen.dart';
import 'models/provider_model.dart';
import 'providers/provider_provider.dart';
import 'screens/provider_detail_screen.dart';
import 'services/global_methods.dart';
import 'services/utils.dart';
import 'widgets/text_widget.dart';
import 'widgets/provider_items.dart'; // Import the ProviderDetailScreen

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = utils.getScreenSize;
    final Color color = utils.color;
    final providerProviders = Provider.of<ProviderProvider>(context);
    List<ProviderModel> allProviders = providerProviders.getProviders;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 37),
            TextButton(
              onPressed: () {},
              child: TextWidget(
                text: 'Best Providers',
                isTitle: true,
                maxLines: 1,
                color: Colors.black,
                textSize: 30,
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Providers',
                    color: color,
                    textSize: 22,
                    isTitle: true,
                  ),
                  TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: TextWidget(
                      text: 'Browse all',
                      maxLines: 1,
                      color: Colors.blue,
                      textSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              childAspectRatio: size.width / (size.height * 0.20),
              children: List.generate(
                allProviders.length < 4 ? allProviders.length : 4, (index) {
                  final provider = allProviders[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ProviderDetailScreen.routeName,
                        arguments: provider,
                      );
                    },
                    child: Provider<ProviderModel>.value(
                      value: provider,
                      child: const ProvidersWidget(),
                    ),
                  );
                }
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
