import 'package:desktop/model/account_model.dart';
import 'package:desktop/services/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NewCustomerPage extends StatefulWidget {
  const NewCustomerPage({super.key});

  @override
  State<NewCustomerPage> createState() => _NewCustomerPageState();
}

class _NewCustomerPageState extends State<NewCustomerPage> {
  List<AccountModel> accounts = <AccountModel>[];
  final TextEditingController nameTec = TextEditingController();

  void addAccount() {
    setState(() {
      accounts.add(
        AccountModel(
          id: 1,
          customerId: 1,
          tag: '#br1',
          decayGames: 2,
          link: 'https://abc123.com.br',
          nick: 'abc123',
          ranking: 'Diamond 4 54LP',
        ),
      );
    });
  }

  Future<void> onSubmit() async {
    await Sqflite().addCustomer(nameTec.text);

    if (mounted) context.pop(true);
  }

  void removeAccount() {
    setState(() {
      accounts.removeAt(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton(
        onPressed: onSubmit,
        child: Text('Confirm'),
      ),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 16,
            children: <Widget>[
              _LabelInput(label: 'Name', tec: nameTec),
              _AccountLinks(
                accounts: accounts,
                addFunction: addAccount,
                removeFunction: removeAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountLinks extends StatelessWidget {
  const _AccountLinks({
    required this.accounts,
    required this.addFunction,
    required this.removeFunction,
  });

  final List<AccountModel> accounts;
  final VoidCallback addFunction;
  final VoidCallback removeFunction;

  @override
  Widget build(BuildContext context) {
    final TextEditingController accTec = TextEditingController();
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: <Widget>[
          Text('Accounts'),
          KeyboardListener(
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                addFunction();
                accTec.clear();
              }
            },
            focusNode: FocusNode(),
            child: TextField(
              controller: accTec,
              decoration: InputDecoration(
                helperText: 'Paste account opgg link here',
                suffixIcon: IconButton(
                  onPressed: addFunction,
                  icon: Icon(Icons.add),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
            ),
          ),
          Column(
            spacing: 8,
            children: accounts
                .map(
                  (AccountModel acc) => Container(
                    decoration: BoxDecoration(
                      border: BoxBorder.all(color: theme.colorScheme.onSurface),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 0, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Nick: ${acc.nick}'),
                          Text('Tag: ${acc.tag}'),
                          Row(
                            spacing: 4,
                            children: <Widget>[
                              Text('Decay games (optional):'),
                              SizedBox(
                                width: 20,
                                child: TextField(decoration: InputDecoration()),
                              ),
                            ],
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: removeFunction,
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LabelInput extends StatelessWidget {
  const _LabelInput({required this.label, required this.tec});

  final TextEditingController tec;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: <Widget>[
        Text(label),
        TextField(
          controller: tec,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
