import 'package:spyrift/model/account_model.dart';
import 'package:spyrift/model/customer_model.dart';

abstract class DatabaseInterface {
  Future<List<CustomerModel>> fetchCustomers();

  Future<CustomerModel> fetchCustomerById(int id);

  Future<void> deleteCustomer(int id);

  Future<int> addCustomer(CustomerModel customer);

  Future<void> addAccounts({
    required List<AccountModel> accounts,
    required int customerId,
  });

  Future<void> editAccount({required AccountModel account});

  Future<List<AccountModel>> fetchAccounts(int customerId);

  Future<void> editCustomer({
    required CustomerModel customer,
    required int customerId,
  });

  Future<void> removeAccounts({required List<int> accountsIds});
}
