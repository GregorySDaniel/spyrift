import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';

abstract class BaseRepository {
  Future<List<AccountModel>> fetchAccounts();
  Future<List<CustomerModel>> fetchCustomers();
  Future<CustomerModel> fetchCustomerById(int id);
  Future<void> deleteCustomer(int id);
}
