import 'package:flutter/material.dart';
import '../app_state.dart';
import '../l10n.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthState();
}

class _AuthState extends State<AuthScreen> {
  bool reg = false;
  final n = TextEditingController(), i = TextEditingController(), p = TextEditingController();

  void go() {
    final e = reg ? app.register(n.text.trim(), i.text.trim().toLowerCase(), p.text) : app.login(i.text.trim().toLowerCase(), p.text);
    if (e != null) snack(context, tr(e));
  }

  Widget f(TextEditingController c, String l, {bool obs = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(controller: c, obscureText: obs, decoration: InputDecoration(labelText: tr(l), border: const OutlineInputBorder())),
      );

  @override
  Widget build(BuildContext context) => live(() => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: app.toggleLang, child: Text(app.ur ? 'EN' : 'اردو'))),
                const Icon(Icons.mosque, size: 64, color: Color(0xFF0F6B4A)),
                Text(tr('title'), style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 24),
                if (reg) f(n, 'name'),
                f(i, 'email'),
                f(p, 'password', obs: true),
                SizedBox(width: double.infinity, child: FilledButton(onPressed: go, child: Text(tr(reg ? 'register' : 'login')))),
                TextButton(onPressed: () => setState(() => reg = !reg), child: Text(tr(reg ? 'have' : 'newuser'))),
              ]),
            ),
          ),
        ),
      ));
}
