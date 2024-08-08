import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swifthelp_app/models/provider_model.dart';

class ProviderProvider with ChangeNotifier {
  List<ProviderModel> _providers = [];

  List<ProviderModel> get getProviders => _providers;

  ProviderProvider() {
    fetchProviders();
  }

  Future<void> fetchProviders() async {
    try {
      final providerCollection = FirebaseFirestore.instance.collection('providers');
      final snapshot = await providerCollection.get();

      _providers = snapshot.docs.map((doc) {
        final data = doc.data();
        return ProviderModel(
          id: data['id'],
          name: data['name'],
          address: data['shipping-address'],
          discription: data['discription'],
          mobile: data['mobile-number'],
          
        );
      }).toList();

      notifyListeners();
    } catch (error) {
      print("Failed to fetch providers: $error");
    }
  }
}
