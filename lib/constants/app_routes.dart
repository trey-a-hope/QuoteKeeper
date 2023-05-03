import 'package:book_quotes/constants/globals.dart';
import 'package:book_quotes/ui/create_book/create_book_view.dart';
import 'package:book_quotes/ui/dashboard/dashboard_view.dart';
import 'package:book_quotes/ui/edit_book/edit_book_view.dart';
import 'package:book_quotes/ui/books/books_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  AppRoutes._();

  static final List<GetPage> routes = [
    GetPage(
      name: Globals.routeCreateQuote,
      page: () => CreateBookView(),
    ),
    GetPage(
      name: Globals.routeDashboard,
      page: () => const DashboardView(),
    ),
    GetPage(
      name: Globals.routeBooks,
      page: () => const BooksView(),
    ),
    GetPage(
      name: Globals.routeEditQuote,
      page: () => EditBookView(),
    ),
  ];
}
