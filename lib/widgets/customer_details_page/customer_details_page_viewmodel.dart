import 'dart:async';

import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';

class CustomerDetailsPageViewmodel extends ChangeNotifier {
  CustomerDetailsPageViewmodel({required this.repo, required this.customer});

  final BaseRepository repo;
  final CustomerModel customer;

  List<AccountModel>? accounts;

  bool isLoading = false;
  String? errorMsg;

  Future<void> getAccounts() async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();

    final Result<List<AccountModel>> response = await repo.fetchAccounts(
      customer.id!,
    );

    // TODO: tratar erros
    if (response is Error<AccountModel>) {
      isLoading = false;
      errorMsg = 'Ocorreu um erro';
      notifyListeners();
    }

    if (response is Ok<List<AccountModel>>) {
      accounts = response.value;
      isLoading = false;
      notifyListeners();
    }
  }
}
