import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';

abstract class BaseRepository {
  Future<List<AccountModel>> fetchAccounts(int customerId);
  Future<List<CustomerModel>> fetchCustomers();
  Future<CustomerModel> fetchCustomerById(int id);
  Future<void> deleteCustomer(int id);
  Future<int> addCustomer(CustomerModel customer);
  Future<void> addAccounnts({
    required List<AccountModel> accounts,
    required int customerId,
  });
  Future<void> editCustomer({
    required CustomerModel customer,
    required int customerId,
  });
  Future<void> editAccounts({required List<AccountModel> accounts});

  Future<void> removeAccounts({required List<int> accountsIds});
}
