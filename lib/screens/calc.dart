import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});
  @override
  State<CalcScreen> createState() => _CalcState();
}

class _CalcState extends State<CalcScreen> {
  static const tola = 11.664;
  final c = {for (final k in ['cash', 'bank', 'gw', 'sw', 'biz', 'inv', 'rec', 'liab']) k: TextEditingController()};
  final car = TextEditingController(text: '24');
  bool gT = true, sT = true, jewel = true, silverBasis = true;

  double v(String k) => (double.tryParse(c[k]!.text) ?? 0).clamp(0, double.infinity).toDouble();

  void run() {
    final r = app.rates;
    if (r == null) {
      snack(context, tr('ratesMissing'));
      return;
    }
    final gr = (r['gold'] as num).toDouble(), sr = (r['silver'] as num).toDouble();
    final carat = (double.tryParse(car.text) ?? 24).clamp(1, 24).toDouble();
    final gold = jewel ? (gT ? v('gw') : v('gw') / tola) * gr * carat / 24 : 0.0;
    final silver = jewel ? (sT ? v('sw') : v('sw') / tola) * sr : 0.0;
    final a = {'cash': v('cash'), 'bank': v('bank'), 'gold': gold, 'silver': silver, 'biz': v('biz'), 'inv': v('inv'), 'rec': v('rec')};
    final total = a.values.fold<double>(0, (s, x) => s + x), net = total - v('liab');
    final nisab = silverBasis ? 52.5 * sr : 7.5 * gr;
    app.d['calc'] = {'a': a, 'liab': v('liab'), 'total': total, 'net': net, 'nisab': nisab, 'due': net >= nisab && net > 0 ? net * 0.025 : 0.0, 'year': DateTime.now().year};
    app.save();
  }

  Widget f(String k, String l) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(controller: c[k], keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: tr(l), border: const OutlineInputBorder())),
      );

  Widget unit(bool t, void Function(bool) s) => SegmentedButton<bool>(
        segments: [ButtonSegment(value: true, label: Text(tr('tola'))), ButtonSegment(value: false, label: Text(tr('gram')))],
        selected: {t},
        onSelectionChanged: (x) => setState(() => s(x.first)),
      );

  Widget kv(String k, num v, {bool b = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(tr(k), style: TextStyle(fontWeight: b ? FontWeight.bold : null)),
          Text(fmt(v), style: TextStyle(fontWeight: b ? FontWeight.bold : null)),
        ]),
      );

  @override
  Widget build(BuildContext context) => live(() {
        final r = app.d['calc'] as Map?;
        return ListView(padding: const EdgeInsets.all(16), children: [
          if (app.rates == null) Card(color: Colors.orange.shade100, child: Padding(padding: const EdgeInsets.all(12), child: Text(tr('ratesMissing')))),
          f('cash', 'cash'), f('bank', 'bank'),
          f('gw', 'gw'), Row(children: [unit(gT, (x) => gT = x), const SizedBox(width: 12), SizedBox(width: 90, child: TextField(controller: car, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr('carat'), border: const OutlineInputBorder())))]),
          const SizedBox(height: 10),
          f('sw', 'sw'), unit(sT, (x) => sT = x), const SizedBox(height: 10),
          f('biz', 'biz'), f('inv', 'inv'), f('rec', 'rec'), f('liab', 'liab'),
          SwitchListTile(value: jewel, onChanged: (x) => setState(() => jewel = x), title: Text(tr('jewel'))),
          SwitchListTile(value: silverBasis, onChanged: (x) => setState(() => silverBasis = x), title: Text(tr('silverBasis'))),
          FilledButton(onPressed: run, child: Text(tr('calc'))),
          if (r != null) Card(
            margin: const EdgeInsets.only(top: 16),
            child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              for (final k in ['cash', 'bank', 'gold', 'silver', 'biz', 'inv', 'rec']) kv(k, r['a'][k]),
              const Divider(), kv('total', r['total'], b: true), kv('liab', r['liab']), kv('net', r['net'], b: true), kv('nisab', r['nisab']),
              const Divider(),
              if (r['due'] > 0) ...[
                Text(tr('due'), style: Theme.of(context).textTheme.labelLarge),
                Text('PKR ${fmt(r['due'])}', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xFF0F6B4A), fontWeight: FontWeight.bold)),
                kv('paid', app.paidZakat(r['year'])), kv('left', (r['due'] - app.paidZakat(r['year'])).clamp(0, double.infinity)),
                if (r['due'] - app.paidZakat(r['year']) <= 0) Text('✓ ${tr('done')}', style: const TextStyle(color: Color(0xFF0F6B4A))),
              ] else Text('${tr('notdue')} ${fmt((r['nisab'] - r['net']).clamp(0, double.infinity))}', style: const TextStyle(color: Colors.deepOrange)),
              if (app.rates != null) Text('${tr('rateDate')}: ${app.rates!['date']}', style: Theme.of(context).textTheme.bodySmall),
            ])),
          ),
          Padding(padding: const EdgeInsets.only(top: 12), child: Text(tr('disclaimer'), style: Theme.of(context).textTheme.bodySmall)),
        ]);
      });
}
