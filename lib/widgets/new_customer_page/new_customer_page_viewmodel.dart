import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';

class NewCustomerPageViewmodel extends ChangeNotifier {
  NewCustomerPageViewmodel({required this.repo, required this.customerId});

  final BaseRepository repo;
  final String? customerId;

  final TextEditingController accTec = TextEditingController();
  final TextEditingController nameTec = TextEditingController();
  final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();

  List<AccountModel> accounts = <AccountModel>[];
  List<AccountModel> retrievedAccounts = <AccountModel>[];

  void addAccount() {
    final AccountModel account = parsefromOpggLink(accTec.text);
    accounts.add(account);
    notifyListeners();
  }

  AccountModel parsefromOpggLink(String link) {
    final List<String> splittedLink = link.split('/');

    final int lastIndex = splittedLink.length - 1;

    final String nickWithTag = splittedLink[lastIndex];
    final List<String> splittedNickTag = nickWithTag.split('-');

    final String tag = splittedNickTag[1];
    final String nick = splittedNickTag[0].replaceAll(RegExp(r'%20'), ' ');
    final String region = splittedLink[lastIndex - 1];

    return AccountModel(tag: tag, nick: nick, region: region, link: link);
  }

  List<AccountModel> newAccountsOnEditing() {
    final List<AccountModel> newAccountsOnEditing = <AccountModel>[];

    for (final AccountModel account in accounts) {
      if (!retrievedAccounts.contains(account)) {
        newAccountsOnEditing.add(account);
      }
    }

    return newAccountsOnEditing;
  }

  List<int> getDeletedAccountsIds() {
    final List<int> ids = <int>[];

    if (accounts.isEmpty) {
      return retrievedAccounts.map((AccountModel acc) => acc.id!).toList();
    }

    for (final AccountModel retrievedAccount in retrievedAccounts) {
      if (!accounts.contains(retrievedAccount)) ids.add(retrievedAccount.id!);
    }

    return ids;
  }

  Future<void> handleExistingAccounts(CustomerModel customer) async {
    if (customerId == null) return;

    final int? intCustomerid = int.tryParse(customerId!);

    if (intCustomerid == null) return;

    await repo.editCustomer(customer: customer, customerId: intCustomerid);
    final List<int> deletedAccountsIds = getDeletedAccountsIds();
    if (deletedAccountsIds.isNotEmpty) {
      await repo.removeAccounts(accountsIds: deletedAccountsIds);
    }
    final List<AccountModel> newAccounts = newAccountsOnEditing();
    await repo.addAccounnts(accounts: newAccounts, customerId: intCustomerid);
  }

  Future<bool> onSubmit() async {
    final CustomerModel customer = CustomerModel(name: nameTec.text);

    if (customerId != null) {
      await handleExistingAccounts(customer);
      return true;
    }

    final Result<int> customerIdRes = await repo.addCustomer(customer);

    // TODO: tratar erro
    if (customerIdRes is Ok<int>) {
      final int customerId = customerIdRes.value;

      await repo.addAccounnts(accounts: accounts, customerId: customerId);
    }

    return true;
  }

  Future<void> fetchCustomerInfos() async {
    if (customerId == null) return;

    final int? intCustomerid = int.tryParse(customerId!);

    if (intCustomerid == null) return;

    // TODO: tratar erro
    final Result<List<AccountModel>> retrievedAccountsRes = await repo
        .fetchAccounts(intCustomerid);

    if (retrievedAccountsRes is Ok<List<AccountModel>>) {
      retrievedAccounts = retrievedAccountsRes.value;
      final List<AccountModel> _retrievedAccounts = retrievedAccountsRes.value;
      accounts.addAll(_retrievedAccounts);
    }

    // TODO: tratar erro
    final Result<CustomerModel> customerRes = await repo.fetchCustomerById(
      intCustomerid,
    );

    if (customerRes is Ok<CustomerModel>) {
      final CustomerModel cust = customerRes.value;
      nameTec.text = cust.name;
    }
    notifyListeners();
  }

  void removeAccount(int index) {
    accounts.removeAt(index);
    notifyListeners();
  }
}
