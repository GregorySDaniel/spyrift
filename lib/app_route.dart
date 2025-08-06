import 'package:desktop/model/customer_model.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/widgets/customer_details_page/customer_details_page.dart';
import 'package:desktop/widgets/customer_details_page/customer_details_page_viewmodel.dart';
import 'package:desktop/widgets/home_page/home_page.dart';
import 'package:desktop/widgets/new_customer_page/new_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router() {
  return GoRouter(routes: routes(), initialLocation: '/');
}

List<RouteBase> routes() {
  return <RouteBase>[
    GoRoute(path: '/', builder: (_, __) => HomePage()),
    GoRoute(
      path: '/new',
      builder: (_, GoRouterState state) =>
          NewCustomerPage(customerId: state.uri.queryParameters['id']),
    ),
    GoRoute(
      path: '/customer',
      builder: (BuildContext context, GoRouterState state) {
        final BaseRepository repo = context.read<BaseRepository>();
        final CustomerModel customer = state.extra as CustomerModel;

        return ChangeNotifierProvider<CustomerDetailsPageViewmodel>(
          create: (_) =>
              CustomerDetailsPageViewmodel(repo: repo, customer: customer),
          child: CustomerDetailsPage(),
        );
      },
    ),
  ];
}
