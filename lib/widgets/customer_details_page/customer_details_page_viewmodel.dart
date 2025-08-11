import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spyrift/model/account_model.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/repository/web_repository_interface.dart';
import 'package:spyrift/util.dart';

class CustomerDetailsPageViewmodel extends ChangeNotifier {
  CustomerDetailsPageViewmodel({
    required this.dbRepo,
    required this.customer,
    required this.webRepo,
  });

  final DbBaseRepository dbRepo;
  final WebRepositoryInterface webRepo;
  final CustomerModel customer;

  List<AccountModel>? accounts;

  bool isLoading = false;
  String? errorMsg;

  Future<void> refresh() async {
    await getAccounts();
    notifyListeners();
  }

  Future<void> fetchAccountsRanking() async {
    if (accounts == null) return;

    isLoading = true;
    notifyListeners();

    for (final AccountModel account in accounts!) {
      if (account.link == null) continue;

      final Result<String> res = await webRepo.fetchAccountRanking(
        link: account.link!,
      );

      if (res is Ok<String>) {
        final String ranking = res.value;
        final AccountModel accountWithRanking = AccountModel(
          id: account.id,
          customerId: customer.id,
          ranking: ranking,
          tag: account.tag,
          decayGames: account.decayGames,
          region: account.region,
          link: account.link,
          nick: account.nick,
        );

        await dbRepo.editAccount(account: accountWithRanking);
      }
    }

    await refresh();
  }

  Future<void> getAccounts() async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();

    final Result<List<AccountModel>> response = await dbRepo.fetchAccounts(
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
