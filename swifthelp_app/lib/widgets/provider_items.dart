import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/provider_model.dart';

class ProvidersWidget extends StatelessWidget {
  const ProvidersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderModel>(context);
    
    return Card(
      child: ListTile(
        title: Text(provider.name),
        subtitle: Text(provider.address),
        leading: Icon(Icons.person),
      ),
    );
  }
}
