import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyrift/model/account_model.dart';
import 'package:spyrift/widgets/customer_details_page/customer_details_page_viewmodel.dart';
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

      await viewmodel.getAccounts();

      viewmodel.accountsSearched = viewmodel.accounts;

      viewmodel.searchTec.addListener(() {
        viewmodel.filterList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CustomerDetailsPageViewmodel viewmodel = context
        .watch<CustomerDetailsPageViewmodel>();

    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          ),
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          child: Column(
            spacing: 12,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Icon(Icons.person, size: 64),
                    Text(
                      viewmodel.customer.name,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              if (viewmodel.accounts != null && viewmodel.accounts!.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: viewmodel.searchTec,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await viewmodel.fetchAccountsRanking();
                      },
                      icon: Icon(Icons.refresh),
                    ),
                  ],
                ),

              Divider(),
              if (viewmodel.isLoading)
                Center(child: CircularProgressIndicator()),
              if (viewmodel.accounts != null && !viewmodel.isLoading)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: viewmodel.accountsSearched!
                      .map(
                        (AccountModel account) =>
                            _AccContainer(account: account),
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

class _AccContainer extends StatefulWidget {
  const _AccContainer({required this.account});

  final AccountModel account;

  @override
  State<_AccContainer> createState() => _AccContainerState();
}

class _AccContainerState extends State<_AccContainer> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Uri url = Uri.parse(widget.account.link!);

    return MouseRegion(
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
        onTap: () async {
          if (!await launchUrl(url)) throw Exception();
        },
        child: AnimatedScale(
          scale: isHovering ? 1.06 : 1,
          duration: const Duration(milliseconds: 100),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.primary),
                  color: theme.colorScheme.surfaceBright,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: <Widget>[
                    Text("NICK: ${widget.account.nick ?? 'idk'}"),
                    Text("RANKING: ${widget.account.ranking ?? 'idk'}"),
                    Text("REGION: ${widget.account.region ?? 'idk'}"),
                    Text("TAG: ${widget.account.tag ?? 'idk'}"),
                    Text("DECAY: ${widget.account.decayGames ?? 'idk'}"),
                  ],
                ),
              ),
              if (isHovering)
                Positioned(top: 4, right: 4, child: Icon(Icons.arrow_outward)),
            ],
          ),
        ),
      ),
    );
  }
}
