import 'package:aynaclient/service/hive_service.dart';
import 'package:aynaclient/view/home_page.dart';
import 'package:aynaclient/view/login_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    if (HiveService.userName != null) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
