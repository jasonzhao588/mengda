import 'package:mengda/pages/application/application.dart';
import 'package:mengda/pages/index/index.dart';
import 'package:get/get.dart';

// final Map<String, GetRoute> routes = {
//   '/': GetRoute(page: IndexPage()),
//   '/app': GetRoute(page: ApplicationPage()),
// };

final List<GetPage> pages = [
  GetPage(name: '/', page: () => IndexPage()),
  GetPage(name: '/app', page: () => ApplicationPage()),
];
