import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';

class MockRepository implements BaseRepository {
  @override
  Future<List<AccountModel>> fetchAccounts(int customerId) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return mockAccountsList;
  }

  @override
  Future<List<CustomerModel>> fetchCustomers() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return List<CustomerModel>.generate(
      6,
      (int index) => CustomerModel(id: index, name: 'Customer $index '),
    );
  }

  @override
  Future<CustomerModel> fetchCustomerById(int id) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return CustomerModel(name: 'Customer', id: 0);
  }

  @override
  Future<void> deleteCustomer(int id) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<void> addCustomer(CustomerModel customer) {
    // TODO: implement addCustomer
    throw UnimplementedError();
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
