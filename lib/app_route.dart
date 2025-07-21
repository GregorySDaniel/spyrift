import 'package:desktop/widgets/customer_details_page.dart';
import 'package:desktop/widgets/home_page.dart';
import 'package:desktop/widgets/new_customer_page.dart';
import 'package:go_router/go_router.dart';

GoRouter router() {
  return GoRouter(routes: routes(), initialLocation: '/');
}

List<RouteBase> routes() {
  return <RouteBase>[
    GoRoute(path: '/', builder: (_, __) => HomePage()),
    GoRoute(path: '/new', builder: (_, __) => NewCustomerPage()),
    GoRoute(
      path: '/customer/:id',
      builder: (_, state) =>
          CustomerDetailsPage(customerId: state.pathParameters['id']!),
    ),
  ];
}
