import 'package:desktop/model/account_model.dart';

class CustomerModel {
  final int id;
  final String name;
  final List<AccountModel>? accounts;

  CustomerModel({required this.name, required this.id, this.accounts});

  CustomerModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      accounts = [];
}
// TODO: accs