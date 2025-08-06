import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BaseRepository repo;
  late Future<Result<List<CustomerModel>>> future;

  @override
  void initState() {
    super.initState();

    repo = context.read<BaseRepository>();
    future = repo.fetchCustomers();
  }

  void refresh() {
    setState(() {
      future = repo.fetchCustomers();
    });
  }

  Future<void> onDelete(int id) async {
    final bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            context.pop(true);
          }
        },
        child: AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop(false);
              },
              child: Text('No'),
            ),

            TextButton(
              onPressed: () {
                context.pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      ),
    );

    if (confirmation ?? false) {
      await repo.deleteCustomer(id);
      refresh();
    }
  }

  Future<void> onEdit(int id) async {
    final bool? res = await context.push<bool>('/new?id=$id');

    if (res ?? false) refresh();
  }

  Future<void> onPressed() async {
    final bool? res = await context.push<bool>('/new');

    if (res ?? false) {
      refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: IconButton.filled(
        onPressed: onPressed,
        icon: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Dashboard', style: TextStyle(fontSize: 48)),
              FutureBuilder<Result<List<CustomerModel>>>(
                future: future,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<Result<List<CustomerModel>>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data == null) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text('Error'),
                              ElevatedButton(
                                onPressed: refresh,
                                child: Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      final Result<List<CustomerModel>> response =
                          snapshot.data!;

                      if (response is Error<List<CustomerModel>>) {
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text('Error: ${response.error}'),
                              ElevatedButton(
                                onPressed: refresh,
                                child: Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (response is Ok<List<CustomerModel>>) {
                        final List<CustomerModel> customers = response.value;

                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: customers
                              .map(
                                (CustomerModel customer) => _CustomerContainer(
                                  customer: customer,
                                  onDelete: onDelete,
                                  onEdit: onEdit,
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Center(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(16),
                          child: Center(child: Text('Unexpected error')),
                        ),
                      );
                    },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerContainer extends StatelessWidget {
  const _CustomerContainer({
    required this.customer,
    required this.onDelete,
    required this.onEdit,
  });

  final CustomerModel customer;
  final void Function(int id) onDelete;
  final void Function(int id) onEdit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: <Widget>[
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.push('/customer/${customer.id}'),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary),
              ),
              padding: EdgeInsets.all(16),
              width: 200,
              height: 200,
              child: Center(child: Text(customer.name)),
            ),
          ),
        ),
        Positioned(
          child: IconButton(
            onPressed: () => onEdit(customer.id!),
            icon: Icon(Icons.edit),
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () => onDelete(customer.id!),
            icon: Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
