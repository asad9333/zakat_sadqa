import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});
  @override
  State<MoreScreen> createState() => _MoreState();
}

class _MoreState extends State<MoreScreen> {
  final fp = TextEditingController(text: '1'), fk = TextEditingController();
  static const duas = [
    ['Before eating', 'کھانے سے پہلے', 'بِسْمِ اللهِ'],
    ['After eating', 'کھانے کے بعد', 'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ'],
    ['Before sleep', 'سونے سے پہلے', 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا'],
    ['Good in both worlds', 'دنیا و آخرت', 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ'],
  ];

  @override
  Widget build(BuildContext context) => live(() {
        final fit = (int.tryParse(fp.text) ?? 0) * (double.tryParse(fk.text) ?? 0) * 2;
        return ListView(padding: const EdgeInsets.all(16), children: [
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text(tr('tasbeeh'), style: Theme.of(context).textTheme.titleMedium),
            Text('${app.d['tas']}', style: Theme.of(context).textTheme.displayMedium),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              FilledButton(onPressed: () { app.d['tas'] = app.d['tas'] + 1; app.save(); }, child: const Text('+1')),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () { app.d['tas'] = 0; app.save(); }, child: Text(tr('reset'))),
            ]),
          ]))),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Text(tr('fitrana'), style: Theme.of(context).textTheme.titleMedium),
            Row(children: [
              Expanded(child: TextField(controller: fp, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: tr('persons')))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: fk, keyboardType: TextInputType.number, onChanged: (_) => setState(() {}), decoration: InputDecoration(labelText: tr('wheat')))),
            ]),
            const SizedBox(height: 8),
            Text('${tr('fitCalc')}: PKR ${fmt(fit)}'),
          ]))),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(tr('learnText')))),
          Text(tr('duas'), style: Theme.of(context).textTheme.titleMedium),
          for (final d in duas) ListTile(title: Text(app.ur ? d[1] : d[0], style: Theme.of(context).textTheme.bodySmall), subtitle: Text(d[2], textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 20))),
        ]);
      });
}
