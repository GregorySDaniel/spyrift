import 'package:desktop/model/customer_model.dart';
import 'package:desktop/services/database_interface.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Sqflite implements DatabaseInterface {
  Sqflite();

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
      await _db!.execute(
        '''CREATE TABLE IF NOT EXISTS customers(id INTEGER PRIMARY KEY, name TEXT)''',
      );
    }
  }

  @override
  Future<int> addCustomer(String name) async {
    final database = await db;
    return database.insert('customers', <String, Object?>{'name': name});
  }

  @override
  Future<Database> deleteCustomer() {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<CustomerModel> fetchCustomerById(int id) async {
    final database = await db;

    final result = await database.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );

    return CustomerModel.fromJson(result[0]);
  }

  @override
  Future<List<CustomerModel>> fetchCustomers() async {
    final database = await db;
    final result = await database.query('customers');

    final List<CustomerModel> customerList = result
        .map(CustomerModel.fromJson)
        .toList();

    return customerList;
  }

  @override
  Future<int> addAccount() {
    // TODO: implement addAccount
    throw UnimplementedError();
  }
}
