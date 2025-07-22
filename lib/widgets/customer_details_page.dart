import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({super.key, required this.customerId});

  final String customerId;

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  late Future<CustomerModel> customerFuture;
  late Future<List<AccountModel>> accountsFuture;
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
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<CustomerModel>(
        future: customerFuture,
        builder: (BuildContext context, AsyncSnapshot<CustomerModel> snapshot) {
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

          final CustomerModel customer = snapshot.data!;

          return Column(
            children: <Widget>[
              Text(customer.name),
              FutureBuilder<List<AccountModel>>(
                future: accountsFuture,
                builder: (_, AsyncSnapshot<List<AccountModel>> snapshot) {
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

                  return Column(
                    children: snapshot.data!
                        .map((AccountModel account) => Text(account.nick!))
                        .toList(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
