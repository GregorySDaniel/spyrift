import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spyrift/model/customer_model.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/repository/web_repository_interface.dart';
import 'package:spyrift/widgets/customer_details_page/customer_details_page.dart';
import 'package:spyrift/widgets/customer_details_page/customer_details_page_viewmodel.dart';
import 'package:spyrift/widgets/home_page/home_page.dart';
import 'package:spyrift/widgets/home_page/home_page_viewmodel.dart';
import 'package:spyrift/widgets/new_customer_page/new_customer_page.dart';
import 'package:spyrift/widgets/new_customer_page/new_customer_page_viewmodel.dart';

GoRouter router() {
  return GoRouter(routes: routes(), initialLocation: '/');
}

List<RouteBase> routes() {
  return <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, __) {
        final DbBaseRepository repo = context.read<DbBaseRepository>();

        return ChangeNotifierProvider<HomePageViewmodel>(
          create: (_) => HomePageViewmodel(repo: repo),
          child: HomePage(),
        );
      },
    ),
    GoRoute(
      path: '/new',
      builder: (BuildContext context, GoRouterState state) {
        final DbBaseRepository repo = context.read<DbBaseRepository>();
        final String? customerId = state.uri.queryParameters['id'];

        return ChangeNotifierProvider<NewCustomerPageViewmodel>(
          create: (_) =>
              NewCustomerPageViewmodel(repo: repo, customerId: customerId),
          child: NewCustomerPage(),
        );
      },
    ),
    GoRoute(
      path: '/customer',
      builder: (BuildContext context, GoRouterState state) {
        final DbBaseRepository dbRepo = context.read<DbBaseRepository>();
        final CustomerModel customer = state.extra as CustomerModel;
        final WebRepositoryInterface webRepositoryInterface = context
            .read<WebRepositoryInterface>();

        return ChangeNotifierProvider<CustomerDetailsPageViewmodel>(
          create: (_) => CustomerDetailsPageViewmodel(
            dbRepo: dbRepo,
            customer: customer,
            webRepo: webRepositoryInterface,
          ),
          child: CustomerDetailsPage(),
        );
      },
    ),
  ];
}
