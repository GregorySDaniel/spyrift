import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/services/database_interface.dart';

class Repository implements BaseRepository {
  Repository({required this.db});

  final DatabaseInterface db;

  @override
  Future<List<AccountModel>> fetchAccounts(int customerId) async {
    try {
      final List<AccountModel> accounts = await db.fetchAccounts(customerId);
      return accounts;
    } catch (e) {
      throw 'Error $e';
    }
  }

  @override
  Future<CustomerModel> fetchCustomerById(int id) async {
    try {
      final CustomerModel customer = await db.fetchCustomerById(id);
      return customer;
    } catch (e) {
      throw 'Error: $e';
    }
  }

  @override
  Future<List<CustomerModel>> fetchCustomers() async {
    try {
      final List<CustomerModel> customers = await db.fetchCustomers();
      return customers;
    } catch (e) {
      throw 'Error: $e';
    }
  }

  @override
  Future<void> deleteCustomer(int id) async {
    try {
      await db.deleteCustomer(id);
    } catch (e) {
      throw 'Error: $e';
    }
  }

  @override
  Future<int> addCustomer(CustomerModel customer) async {
    try {
      return await db.addCustomer(customer);
    } catch (e) {
      throw 'Error: $e';
    }
  }

  @override
  Future<void> addAccounnts({
    required List<AccountModel> accounts,
    required int customerId,
  }) async {
    try {
      await db.addAccounts(accounts: accounts, customerId: customerId);
    } catch (e) {
      throw 'Error: $e';
    }
  }
}
