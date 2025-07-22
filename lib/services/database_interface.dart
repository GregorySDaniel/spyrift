import 'package:desktop/model/customer_model.dart';

abstract class DatabaseInterface {
  Future<List<CustomerModel>> fetchCustomers();

  Future<CustomerModel> fetchCustomerById(int id);

  Future<void> deleteCustomer();

  Future<int> addCustomer(String name);

  Future<int> addAccount();
}
