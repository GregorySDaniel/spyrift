import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({super.key, required this.customerId});

  final String customerId;

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  late Future<Result<CustomerModel>> customerFuture;
  late Future<Result<List<AccountModel>>> accountsFuture;
  late BaseRepository repo;

  void refresh() {
    final int id = int.parse(widget.customerId);
    setState(() {
      accountsFuture = repo.fetchAccounts(id);
      customerFuture = repo.fetchCustomerById(id);
    });
  }

  @override
  void initState() {
    super.initState();
    final int id = int.parse(widget.customerId);

    repo = context.read<BaseRepository>();
    customerFuture = repo.fetchCustomerById(id);
    accountsFuture = repo.fetchAccounts(id);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        spacing: 16,
        children: <Widget>[
          Column(
            children: <Widget>[
              FutureBuilder<Result<CustomerModel>>(
                future: customerFuture,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<Result<CustomerModel>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data == null) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text('Ocorreu um erro.'),
                              ElevatedButton(
                                onPressed: refresh,
                                child: Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      final Result<CustomerModel> result = snapshot.data!;

                      if (result is Error<CustomerModel>) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text('Ocorreu um erro: ${result.error}.'),
                              ElevatedButton(
                                onPressed: refresh,
                                child: Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (result is Ok<CustomerModel>) {
                        final CustomerModel customer = result.value;
                        return Text(
                          customer.name,
                          style: TextStyle(fontSize: 28),
                        );
                      }

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Unexpected error'),
                        ),
                      );
                    },
              ),
            ],
          ),
          Column(
            spacing: 8,
            children: <Widget>[
              Text('Accounts:'),
              FutureBuilder<Result<List<AccountModel>>>(
                future: accountsFuture,
                builder: (_, AsyncSnapshot<Result<List<AccountModel>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: Column(
                          children: <Widget>[
                            Text('Error'),
                            FilledButton(
                              onPressed: refresh,
                              child: Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final Result<List<AccountModel>> response = snapshot.data!;

                  if (response is Error<List<AccountModel>>) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(16),
                        child: Column(
                          children: <Widget>[
                            Text('Error: ${response.error}'),
                            FilledButton(
                              onPressed: refresh,
                              child: Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (response is Ok<List<AccountModel>>) {
                    final List<AccountModel> accs = response.value;

                    return SizedBox(
                      width: double.maxFinite,
                      child: Wrap(
                        spacing: 16,
                        alignment: WrapAlignment.center,
                        runSpacing: 16,
                        children: accs.map((AccountModel account) {
                          final Uri _url = Uri.parse(account.link!);

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                if (!await launchUrl(_url)) throw Exception();
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Text("NICK: ${account.nick ?? 'idk'}"),
                                    Text(
                                      "RANKING: ${account.ranking ?? 'idk'}",
                                    ),
                                    Text("REGION: ${account.region ?? 'idk'}"),
                                    Text("TAG: ${account.tag ?? 'idk'}"),
                                    Text(
                                      "DECAY: ${account.decayGames ?? 'idk'}",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }

                  return Center(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(16),
                      child: Text('Unexpected error'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
