class ProviderModel {
  final String id;
  final String name;
  final String address;
  final String? discription;
  final String? mobile;

  ProviderModel({
    required this.id,
    required this.name,
    required this.address,
    this.discription,
    this.mobile,
  });
}


