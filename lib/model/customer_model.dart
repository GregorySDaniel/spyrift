class CustomerModel {
  final int? id;
  final String name;

  CustomerModel({required this.name, this.id});

  CustomerModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'];
}
