import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';
import 'admin.dart';
import 'calc.dart';
import 'more.dart';
import 'pay.dart';
import 'summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int i = 0;
  @override
  Widget build(BuildContext context) => live(() {
        final pages = <Widget>[const CalcScreen(), const PayScreen(), const SummaryScreen(), const MoreScreen(), if (app.isAdmin) const AdminScreen()];
        final dest = [('calculate', Icons.calculate), ('payments', Icons.payments), ('summary', Icons.bar_chart), ('islamic', Icons.mosque), if (app.isAdmin) ('admin', Icons.admin_panel_settings)];
        if (i >= pages.length) i = 0;
        return Scaffold(
          appBar: AppBar(title: Text('${tr('title')} · ${app.me!['name']}'), actions: [
            TextButton(onPressed: app.toggleLang, child: Text(app.ur ? 'EN' : 'اردو')),
            IconButton(icon: const Icon(Icons.logout), onPressed: app.logout),
          ]),
          body: pages[i],
          bottomNavigationBar: NavigationBar(
            selectedIndex: i,
            onDestinationSelected: (x) => setState(() => i = x),
            destinations: [for (final d in dest) NavigationDestination(icon: Icon(d.$2), label: tr(d.$1))],
          ),
        );
      });
}
