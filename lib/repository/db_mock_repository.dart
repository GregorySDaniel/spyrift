import 'package:spyrift/model/account_model.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/util.dart';

class DbMockRepository implements DbBaseRepository {
  @override
  Future<Result<List<AccountModel>>> fetchAccounts(int customerId) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<List<AccountModel>>.ok(mockAccountsList);
  }

  @override
  Future<Result<List<CustomerModel>>> fetchCustomers() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<List<CustomerModel>>.ok(
      List<CustomerModel>.generate(
        6,
        (int index) => CustomerModel(id: index, name: 'Customer $index '),
      ),
    );
  }

  @override
  Future<Result<CustomerModel>> fetchCustomerById(int id) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<CustomerModel>.ok(CustomerModel(name: 'Customer', id: 0));
  }

  @override
  Future<Result<void>> deleteCustomer(int id) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<void>.emptyOk();
  }

  @override
  Future<Result<int>> addCustomer(CustomerModel customer) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<int>.ok(1);
  }

  @override
  Future<Result<void>> addAccounnts({
    required List<AccountModel> accounts,
    required int customerId,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<void>.emptyOk();
  }

  @override
  Future<Result<void>> editCustomer({
    required CustomerModel customer,
    required int customerId,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<void>.emptyOk();
  }

  @override
  Future<Result<void>> removeAccounts({required List<int> accountsIds}) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<void>.emptyOk();
  }

  @override
  Future<Result<void>> editAccount({required AccountModel account}) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return Result<void>.emptyOk();
  }
}

List<AccountModel> mockAccountsList = List<AccountModel>.generate(
  4,
  (int index) => AccountModel(
    customerId: index,
    decayGames: index,
    link: 'https/blabla.com/$index',
    nick: 'Nick',
    tag: '#br1',
    ranking: 'Diamond 4 54LP',
  ),
);
