import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => _AdminState();
}

class _AdminState extends State<AdminScreen> {
  final gr = TextEditingController(text: app.rates?['gold']?.toString() ?? ''), sr = TextEditingController(text: app.rates?['silver']?.toString() ?? '');

  void saveRates() {
    final g = double.tryParse(gr.text) ?? 0, s = double.tryParse(sr.text) ?? 0;
    if (g <= 0 || s <= 0) return snack(context, tr('fill'));
    final now = DateTime.now().toIso8601String().substring(0, 10);
    app.g['rates'] = {'gold': g, 'silver': s, 'date': now};
    (app.g['audit'] as List).insert(0, '$now ${app.me!['name']}: gold $g, silver $s');
    app.save();
  }

  @override
  Widget build(BuildContext context) => live(() {
        final data = (app.g['data'] as Map).values;
        return ListView(padding: const EdgeInsets.all(16), children: [
          Text('${tr('stats')}: ${(app.g['users'] as List).length} / ${data.where((d) => d['calc'] != null).length} / ${data.fold<int>(0, (s, d) => s + (d['pays'] as List).length)}'),
          const SizedBox(height: 12),
          TextField(controller: gr, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr('goldRate'), border: const OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: sr, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr('silverRate'), border: const OutlineInputBorder())),
          const SizedBox(height: 10),
          FilledButton(onPressed: saveRates, child: Text(tr('saveRates'))),
          const SizedBox(height: 16),
          Text(tr('audit'), style: Theme.of(context).textTheme.titleMedium),
          for (final a in app.g['audit']) Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('$a', style: Theme.of(context).textTheme.bodySmall)),
        ]);
      });
}
