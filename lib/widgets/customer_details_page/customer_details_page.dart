import 'dart:async';

import 'package:desktop/model/account_model.dart';
import 'package:desktop/widgets/customer_details_page/customer_details_page_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage();

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  void refresh() {}

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final CustomerDetailsPageViewmodel viewmodel = context
          .read<CustomerDetailsPageViewmodel>();

      unawaited(viewmodel.getAccounts());
    });
  }

  @override
  Widget build(BuildContext context) {
    final CustomerDetailsPageViewmodel viewmodel = context
        .watch<CustomerDetailsPageViewmodel>();

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Text('Hello World'),
            if (viewmodel.isLoading) Center(child: CircularProgressIndicator()),
            if (viewmodel.accounts != null)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: viewmodel.accounts!
                    .map(
                      (AccountModel account) => _AccContainer(account: account),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _AccContainer extends StatelessWidget {
  const _AccContainer({required this.account});

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Uri url = Uri.parse(account.link!);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (!await launchUrl(url)) throw Exception();
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary),
          ),
          child: Column(
            children: <Widget>[
              Text("NICK: ${account.nick ?? 'idk'}"),
              Text("RANKING: ${account.ranking ?? 'idk'}"),
              Text("REGION: ${account.region ?? 'idk'}"),
              Text("TAG: ${account.tag ?? 'idk'}"),
              Text("DECAY: ${account.decayGames ?? 'idk'}"),
            ],
          ),
        ),
      ),
    );
  }
}
