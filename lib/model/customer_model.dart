import 'package:desktop/model/account_model.dart';

class CustomerModel {
  final int id;
  final String name;
  final List<AccountModel> accounts;

  CustomerModel({required this.name, required this.id, required this.accounts});
}
