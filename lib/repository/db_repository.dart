import 'package:spyrift/model/account_model.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/services/database_interface.dart';
import 'package:spyrift/util.dart';

class DbRepository implements DbBaseRepository {
  DbRepository({required this.db});

  final DatabaseInterface db;

  @override
  Future<Result<List<AccountModel>>> fetchAccounts(int customerId) async {
    try {
      final List<AccountModel> accounts = await db.fetchAccounts(customerId);
      return Result<List<AccountModel>>.ok(accounts);
    } on Exception catch (e) {
      return Result<List<AccountModel>>.error(e);
    }
  }

  @override
  Future<Result<CustomerModel>> fetchCustomerById(int id) async {
    try {
      final CustomerModel customer = await db.fetchCustomerById(id);
      return Result<CustomerModel>.ok(customer);
    } on Exception catch (e) {
      return Result<CustomerModel>.error(e);
    }
  }

  @override
  Future<Result<List<CustomerModel>>> fetchCustomers() async {
    try {
      final List<CustomerModel> customers = await db.fetchCustomers();
      return Result<List<CustomerModel>>.ok(customers);
    } on Exception catch (e) {
      return Result<List<CustomerModel>>.error(e);
    }
  }

  @override
  Future<Result<void>> deleteCustomer(int id) async {
    try {
      await db.deleteCustomer(id);
      return Result<void>.emptyOk();
    } on Exception catch (e) {
      return Result<void>.error(e);
    }
  }

  @override
  Future<Result<int>> addCustomer(CustomerModel customer) async {
    try {
      final int id = await db.addCustomer(customer);

      return Result<int>.ok(id);
    } on Exception catch (e) {
      return Result<int>.error(e);
    }
  }

  @override
  Future<Result<void>> addAccounnts({
    required List<AccountModel> accounts,
    required int customerId,
  }) async {
    try {
      await db.addAccounts(accounts: accounts, customerId: customerId);
      return Result<void>.emptyOk();
    } on Exception catch (e) {
      return Result<void>.error(e);
    }
  }

  @override
  Future<Result<void>> editCustomer({
    required CustomerModel customer,
    required int customerId,
  }) async {
    try {
      await db.editCustomer(customer: customer, customerId: customerId);
      return Result<void>.emptyOk();
    } on Exception catch (e) {
      return Result<void>.error(e);
    }
  }

  @override
  Future<Result<void>> editAccount({required AccountModel account}) async {
    try {
      await db.editAccount(account: account);
      return Result<void>.emptyOk();
    } on Exception catch (e) {
      return Result<void>.error(e);
    }
  }

  @override
  Future<Result<void>> removeAccounts({required List<int> accountsIds}) async {
    try {
      await db.removeAccounts(accountsIds: accountsIds);
      return Result<void>.emptyOk();
    } on Exception catch (e) {
      return Result<void>.error(e);
    }
  }
}
