import 'dart:async';

import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/db_base_repository.dart';
import 'package:desktop/services/opgg.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';

class CustomerDetailsPageViewmodel extends ChangeNotifier {
  CustomerDetailsPageViewmodel({
    required this.repo,
    required this.customer,
    required this.opgg,
  });

  final DbBaseRepository repo;
  final Opgg opgg;
  final CustomerModel customer;

  List<AccountModel>? accounts;

  bool isLoading = false;
  String? errorMsg;

  Future<void> fetchAccountsRanking() async {
    if (accounts == null) return;

    for (final AccountModel account in accounts!) {
      if (account.link == null) continue;

      final String ranking = await opgg.fetchAccountRanking(url: account.link!);
      // TODO: update no banco
    }
  }

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
