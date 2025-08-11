import 'package:flutter/material.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/util.dart';

class HomePageViewmodel extends ChangeNotifier {
  HomePageViewmodel({required this.repo});

  final DbBaseRepository repo;

  List<CustomerModel>? customers;

  String? errorMsg;
  bool isLoading = false;

  Future<void> refresh() async {
    await getCustomers();
  }

  Future<void> getCustomers() async {
    errorMsg = null;
    isLoading = true;
    notifyListeners();

    final Result<List<CustomerModel>> response = await repo.fetchCustomers();

    if (response is Error<List<CustomerModel>>) {
      errorMsg = 'Ocorreu um erro';
      isLoading = false;
      notifyListeners();
    }

    if (response is Ok<List<CustomerModel>>) {
      customers = response.value;
      isLoading = false;
      notifyListeners();
    }
  }
}
