import 'package:spyrift/model/account_model.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/util.dart';

abstract class DbBaseRepository {
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
  Future<Result<void>> editAccount({required AccountModel account});

  Future<Result<void>> removeAccounts({required List<int> accountsIds});
}
