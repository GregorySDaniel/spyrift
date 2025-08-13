import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/widgets/home_page/home_page_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final HomePageViewmodel viewmodel = context.read<HomePageViewmodel>();
      unawaited(viewmodel.getCustomers());
    });
  }

  Future<void> onDelete(
    int id,
    DbBaseRepository repo,
    HomePageViewmodel vm,
  ) async {
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
      await vm.refresh();
    }
  }

  Future<void> onEdit(int id, HomePageViewmodel vm) async {
    final bool? res = await context.push<bool>('/new?id=$id');

    if (res ?? false) await vm.refresh();
  }

  Future<void> onPressed(HomePageViewmodel vm) async {
    final bool? res = await context.push<bool>('/new');

    if (res ?? false) {
      await vm.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomePageViewmodel viewmodel = context.watch<HomePageViewmodel>();

    return Scaffold(
      floatingActionButton: IconButton.filled(
        onPressed: () => onPressed(viewmodel),
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
              Divider(),
              if (viewmodel.isLoading)
                Center(child: CircularProgressIndicator()),

              if (viewmodel.customers != null)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: viewmodel.customers!
                      .map(
                        (CustomerModel customer) => _CustomerContainer(
                          customer: customer,
                          onDelete: onDelete,
                          onEdit: onEdit,
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerContainer extends StatefulWidget {
  const _CustomerContainer({
    required this.customer,
    required this.onDelete,
    required this.onEdit,
  });

  final CustomerModel customer;
  final void Function(int id, DbBaseRepository repo, HomePageViewmodel vm)
  onDelete;
  final void Function(int id, HomePageViewmodel vm) onEdit;

  @override
  State<_CustomerContainer> createState() => _CustomerContainerState();
}

class _CustomerContainerState extends State<_CustomerContainer> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final HomePageViewmodel viewModel = context.watch<HomePageViewmodel>();

    return AnimatedScale(
      scale: isHovering ? 1.06 : 1,
      duration: const Duration(milliseconds: 100),
      child: Stack(
        children: <Widget>[
          MouseRegion(
            onHover: (_) {
              setState(() {
                isHovering = true;
              });
            },
            onExit: (_) {
              setState(() {
                isHovering = false;
              });
            },
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.push('/customer', extra: widget.customer),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.primary),
                  color: theme.colorScheme.surfaceBright,
                ),
                padding: EdgeInsets.all(16),
                width: 200,
                height: 200,
                child: Center(
                  child: Column(
                    spacing: 4,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.person, size: 64),
                      Text(
                        widget.customer.name,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: IconButton(
              onPressed: () => widget.onEdit(widget.customer.id!, viewModel),
              icon: Icon(Icons.edit),
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              onPressed: () => widget.onDelete(
                widget.customer.id!,
                viewModel.repo,
                viewModel,
              ),
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
