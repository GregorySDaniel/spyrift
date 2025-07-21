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
  late Future<CustomerModel> future;
  late BaseRepository repo;

  void refresh(int id) {
    setState(() {
      future = repo.fetchCustomerById(id);
    });
  }

  @override
  void initState() {
    super.initState();

    final int id = int.parse(widget.customerId);
    repo = context.read<BaseRepository>();
    future = repo.fetchCustomerById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return Center(
              child: Column(
                children: <Widget>[
                  Text('Ocorreu um erro.'),
                  ElevatedButton(
                    onPressed: () => refresh(int.parse(widget.customerId)),
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final CustomerModel customer = snapshot.data!;

          return Column(children: <Widget>[Text(customer.name)]);
        },
      ),
    );
  }
}
