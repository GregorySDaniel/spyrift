import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/services/database_interface.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Sqflite implements DatabaseInterface {
  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    await openDb();
    return _db!;
  }

  Future<void> openDb() async {
    _db = await databaseFactoryFfi.openDatabase(
      join(await getDatabasesPath(), 'abc.db'),
    );

    if (_db != null) {
      await _db!.execute("PRAGMA foreign_keys = ON;");
      await _db!.execute(
        '''CREATE TABLE IF NOT EXISTS customers(id INTEGER PRIMARY KEY, name TEXT);''',
      );
      await _db!.execute(
        '''CREATE TABLE IF NOT EXISTS
        accounts(id INTEGER PRIMARY KEY, decay_games INTEGER, link TEXT,
        nick TEXT, tag text, ranking TEXT, region TEXT, customer_id INTEGER,
        FOREIGN KEY(customer_id) REFERENCES customers(id) ON DELETE CASCADE);''',
      );
    }
  }

  @override
  Future<int> addCustomer(CustomerModel customer) async {
    final Database database = await db;
    final int customerId = await database.insert('customers', <String, Object?>{
      'name': customer.name,
    });

    return customerId;
  }

  @override
  Future<void> deleteCustomer(int id) async {
    final Database database = await db;
    await database.delete(
      'customers',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  @override
  Future<CustomerModel> fetchCustomerById(int id) async {
    final Database database = await db;

    final List<Map<String, Object?>> result = await database.query(
      'customers',
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    return CustomerModel.fromJson(result[0]);
  }

  @override
  Future<List<CustomerModel>> fetchCustomers() async {
    final Database database = await db;
    final List<Map<String, Object?>> result = await database.query('customers');

    final List<CustomerModel> customerList = result
        .map(CustomerModel.fromJson)
        .toList();

    return customerList;
  }

  @override
  Future<void> addAccounts({
    required List<AccountModel> accounts,
    required int customerId,
  }) async {
    final Database database = await db;

    for (final AccountModel account in accounts) {
      await database.insert('accounts', <String, Object?>{
        'nick': account.nick,
        'region': account.region,
        'tag': account.tag,
        'decay_games': account.decayGames,
        'link': account.link,
        'ranking': account.ranking,
        'customer_id': customerId,
      });
    }
  }

  @override
  Future<List<AccountModel>> fetchAccounts(int customerId) async {
    final Database database = await db;
    final List<Map<String, Object?>> result = await database.query(
      'accounts',
      where: 'customer_id = ?',
      whereArgs: <Object?>[customerId],
    );

    final List<AccountModel> accounts = result
        .map(AccountModel.fromJson)
        .toList();

    return accounts;
  }

  @override
  Future<void> editCustomer({
    required CustomerModel customer,
    required int customerId,
  }) async {
    final Database database = await db;
    await database.update(
      'customers',
      <String, Object?>{'name': customer.name},
      where: 'id = ?',
      whereArgs: <Object?>[customerId],
    );
  }

  @override
  Future<void> editAccounts({required List<AccountModel> accounts}) async {
    final Database database = await db;

    for (final AccountModel account in accounts) {
      await database.update(
        'accounts',
        <String, Object?>{
          'nick': account.nick,
          'region': account.region,
          'tag': account.tag,
          'decay_games': account.decayGames,
          'link': account.link,
          'ranking': account.ranking,
        },
        where: 'id = ?',
        whereArgs: <Object?>[account.id],
      );
    }
  }

  @override
  Future<void> removeAccounts({required List<int> accountsIds}) async {
    final Database database = await db;

    for (final int id in accountsIds) {
      await database.delete(
        'accounts',
        where: 'id = ?',
        whereArgs: <Object?>[id],
      );
    }
  }
}
