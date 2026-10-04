import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});
  @override
  Widget build(BuildContext context) => live(() {
        final calc = app.d['calc'] as Map?;
        final m = <String, List<double>>{};
        for (final p in app.pays) {
          final y = (p['date'] as String).substring(0, 4);
          m.putIfAbsent(y, () => [0, 0])[p['type'] == 'Zakat' ? 0 : 1] += (p['amount'] as num).toDouble();
        }
        final mx = m.values.fold<double>(1, (s, x) => [s, x[0], x[1]].reduce((a, b) => a > b ? a : b));
        final years = m.keys.toList()..sort((a, b) => b.compareTo(a));
        final left = calc == null ? 0.0 : (calc['due'] - app.paidZakat(calc['year'])).clamp(0, double.infinity).toDouble();
        return ListView(padding: const EdgeInsets.all(16), children: [
          if (left > 0) Card(color: Colors.orange.shade100, child: ListTile(leading: const Icon(Icons.notifications_active), title: Text('${tr('remind')}: PKR ${fmt(left)}'))),
          if (calc != null) Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tr('due')), Text(fmt(calc['due']))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tr('paid')), Text(fmt(app.paidZakat(calc['year'])))]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tr('left')), Text(fmt(left))]),
          ]))),
          const SizedBox(height: 12),
          Text(tr('yearly'), style: Theme.of(context).textTheme.titleMedium),
          if (years.isEmpty) Text(tr('none')),
          for (final y in years) ...[
            const SizedBox(height: 8), Text(y, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Zakat ${fmt(m[y]![0])}'), LinearProgressIndicator(value: m[y]![0] / mx, minHeight: 10),
            Text('Sadqa+ ${fmt(m[y]![1])}'), LinearProgressIndicator(value: m[y]![1] / mx, minHeight: 10, color: Colors.orange),
          ],
        ]);
      });
}
