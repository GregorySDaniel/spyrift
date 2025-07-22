import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';

abstract class DatabaseInterface {
  Future<List<CustomerModel>> fetchCustomers();

  Future<CustomerModel> fetchCustomerById(int id);

  Future<void> deleteCustomer(int id);

  Future<void> addCustomer(CustomerModel customer);

  Future<void> addAccounts({
    required List<AccountModel> accounts,
    required int customerId,
  });

  Future<List<AccountModel>> fetchAccounts(int customerId);
}
