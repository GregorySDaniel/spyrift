import 'package:collection/collection.dart';
import 'package:desktop/model/account_model.dart';
import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NewCustomerPage extends StatefulWidget {
  const NewCustomerPage({super.key});

  @override
  State<NewCustomerPage> createState() => _NewCustomerPageState();
}

class _NewCustomerPageState extends State<NewCustomerPage> {
  late BaseRepository repo;
  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  List<AccountModel> accounts = <AccountModel>[];
  final TextEditingController nameTec = TextEditingController();
  final TextEditingController accTec = TextEditingController();

  void addAccount() {
    final AccountModel acc = parsefromOpggLink(accTec.text);
    setState(() {
      accounts.add(acc);
    });
  }

  AccountModel parsefromOpggLink(String link) {
    // example: https://op.gg/lol/summoners/na/C9%20Loki-kr3

    final List<String> splittedLink = link.split('/');

    final int lastIndex = splittedLink.length - 1;

    final String nickWithTag = splittedLink[lastIndex];
    final List<String> splittedNickTag = nickWithTag.split('-');

    final String tag = splittedNickTag[1];
    final String nick = splittedNickTag[0].replaceAll(RegExp(r'%20'), ' ');
    final String region = splittedLink[lastIndex - 1];

    return AccountModel(tag: tag, nick: nick, region: region);
  }

  Future<void> onSubmit() async {
    final CustomerModel customer = CustomerModel(name: nameTec.text);

    final int customerId = await repo.addCustomer(customer);
    await repo.addAccounnts(accounts: accounts, customerId: customerId);

    if (mounted) context.pop(true);
  }

  void removeAccount(int index) {
    setState(() {
      accounts.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();

    repo = context.read<BaseRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FilledButton(
        onPressed: () async {
          if (_nameFormKey.currentState!.validate()) {
            await onSubmit();
          }
        },
        child: Text('Confirm'),
      ),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: KeyboardListener(
          autofocus: false,
          focusNode: FocusNode(),
          onKeyEvent: (KeyEvent event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              if (_nameFormKey.currentState!.validate()) {
                await onSubmit();
              }
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _nameFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 16,
                children: <Widget>[
                  _LabelInput(label: 'Name', tec: nameTec),
                  _AccountLinks(
                    accounts: accounts,
                    addFunction: addAccount,
                    removeFunction: removeAccount,
                    accTec: accTec,
                  ),
                ],
              ),
            ),
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
    required this.accTec,
  });

  final TextEditingController accTec;
  final List<AccountModel> accounts;
  final VoidCallback addFunction;
  final void Function(int) removeFunction;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final GlobalKey<FormState> _accountFormKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: <Widget>[
          Text('Accounts'),
          KeyboardListener(
            onKeyEvent: (KeyEvent event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                if (_accountFormKey.currentState!.validate()) {
                  addFunction();
                  accTec.clear();
                }
              }
            },
            focusNode: FocusNode(),
            child: Form(
              key: _accountFormKey,
              child: TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (value.split('/').length < 3) {
                    return 'Please enter a valid opgg link';
                  }
                  return null;
                },
                controller: accTec,
                decoration: InputDecoration(
                  helperText: 'Paste account opgg link here',
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_accountFormKey.currentState!.validate()) {
                        addFunction();
                        accTec.clear();
                      }
                    },
                    icon: Icon(Icons.add),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colorScheme.primary),
                  ),
                ),
              ),
            ),
          ),
          Column(
            spacing: 8,
            children: accounts
                .mapIndexed(
                  (int index, AccountModel acc) => Container(
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
                          Text('Region: ${acc.region}'),
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
                            onPressed: () => removeFunction(index),
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
        TextFormField(
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
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
