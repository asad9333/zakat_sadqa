import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});
  @override
  State<PayScreen> createState() => _PayState();
}

class _PayState extends State<PayScreen> {
  String q = '';

  Future<void> edit([Map? p]) async {
    final amt = TextEditingController(text: p?['amount']?.toString() ?? ''), rec = TextEditingController(text: p?['receiver'] ?? ''), note = TextEditingController(text: p?['note'] ?? '');
    String type = p?['type'] ?? 'Zakat';
    DateTime dt = p != null ? DateTime.parse(p['date']) : DateTime.now();
    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, set) => AlertDialog(
          title: Text(tr('add')),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              DropdownButton<String>(value: type, isExpanded: true, items: ['Zakat', 'Sadqa', 'Fitrana', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => set(() => type = v!)),
              TextField(controller: amt, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: tr('amount'))),
              TextField(controller: rec, decoration: InputDecoration(labelText: tr('receiver'))),
              TextField(controller: note, decoration: InputDecoration(labelText: tr('note'))),
              TextButton(
                onPressed: () async {
                  final x = await showDatePicker(context: c, initialDate: dt, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (x != null) set(() => dt = x);
                },
                child: Text(dt.toIso8601String().substring(0, 10)),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: Text(tr('cancel'))),
            FilledButton(
              onPressed: () {
                final a = double.tryParse(amt.text) ?? 0;
                if (a <= 0) return;
                final m = {'id': p?['id'] ?? DateTime.now().millisecondsSinceEpoch, 'type': type, 'amount': a, 'date': dt.toIso8601String().substring(0, 10), 'receiver': rec.text, 'note': note.text};
                if (p != null) {
                  app.pays[app.pays.indexOf(p)] = m;
                } else {
                  app.pays.insert(0, m);
                }
                app.save();
                Navigator.pop(c);
              },
              child: Text(tr('save')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => live(() {
        final l = app.pays.where((p) => q.isEmpty || '${p['type']}${p['receiver']}${p['note']}${p['date']}'.toLowerCase().contains(q.toLowerCase())).toList();
        return Scaffold(
          floatingActionButton: FloatingActionButton(onPressed: () => edit(), child: const Icon(Icons.add)),
          body: Column(children: [
            Padding(padding: const EdgeInsets.all(12), child: TextField(onChanged: (v) => setState(() => q = v), decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: tr('search'), border: const OutlineInputBorder()))),
            Expanded(
              child: l.isEmpty
                  ? Center(child: Text(tr('none')))
                  : ListView(children: [
                      for (final p in l)
                        ListTile(
                          onTap: () => edit(p),
                          title: Text('${p['type']} · ${fmt(p['amount'])}'),
                          subtitle: Text('${p['date']} ${p['receiver'] ?? ''} ${p['note'] ?? ''}'),
                          trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {
                            app.pays.remove(p);
                            app.save();
                          }),
                        ),
                    ]),
            ),
          ]),
        );
      });
}
