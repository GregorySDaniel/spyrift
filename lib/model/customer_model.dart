class CustomerModel {
  CustomerModel({required this.name, this.id});

  CustomerModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      name = json['name'] as String;

  final int? id;
  final String name;
}
