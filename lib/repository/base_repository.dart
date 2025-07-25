import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/util.dart';

abstract class BaseRepository {
  Future<Result<List<AccountModel>>> fetchAccounts(int customerId);
  Future<Result<List<CustomerModel>>> fetchCustomers();
  Future<Result<CustomerModel>> fetchCustomerById(int id);
  Future<Result<void>> deleteCustomer(int id);
  Future<Result<int>> addCustomer(CustomerModel customer);
  Future<Result<void>> addAccounnts({
    required List<AccountModel> accounts,
    required int customerId,
  });
  Future<Result<void>> editCustomer({
    required CustomerModel customer,
    required int customerId,
  });
  Future<Result<void>> editAccounts({required List<AccountModel> accounts});

  Future<Result<void>> removeAccounts({required List<int> accountsIds});
}
