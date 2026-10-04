import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final app = AppState();

class AppState extends ChangeNotifier {
  late SharedPreferences _p;
  Map g = {'users': [], 'data': {}, 'rates': null, 'audit': [], 'lang': 'en', 'sess': null};
  Map? me;

  Future<void> init() async {
    _p = await SharedPreferences.getInstance();
    final s = _p.getString('zkG');
    if (s != null) g = jsonDecode(s);
    _loadMe();
  }

  void _loadMe() {
    me = null;
    for (final u in g['users']) {
      if (u['id'] == g['sess']) me = u;
    }
  }

  bool get ur => g['lang'] == 'ur';
  bool get isAdmin => me?['role'] == 'admin';
  Map get d => (g['data'] as Map).putIfAbsent(me!['id'], () => {'calc': null, 'pays': [], 'tas': 0});
  List get pays => d['pays'];
  Map? get rates => g['rates'];
  void save() {
    _p.setString('zkG', jsonEncode(g));
    notifyListeners();
  }

  String _h(String p) => sha256.convert(utf8.encode('zk|$p')).toString();

  String? register(String name, String login, String pass) {
    if (name.isEmpty || login.isEmpty || pass.length < 6) return 'fill';
    final us = g['users'] as List;
    if (us.any((u) => u['login'] == login)) return 'exists';
    final u = {'id': 'u${DateTime.now().millisecondsSinceEpoch}', 'name': name, 'login': login, 'hash': _h(pass), 'role': us.isEmpty ? 'admin' : 'user'};
    us.add(u);
    g['sess'] = u['id'];
    _loadMe();
    save();
    return null;
  }

  String? login(String login, String pass) {
    for (final u in g['users']) {
      if (u['login'] == login && u['hash'] == _h(pass)) {
        g['sess'] = u['id'];
        _loadMe();
        save();
        return null;
      }
    }
    return 'wrong';
  }

  void logout() {
    g['sess'] = null;
    me = null;
    save();
  }

  void toggleLang() {
    g['lang'] = ur ? 'en' : 'ur';
    save();
  }

  double paidZakat(int y) => pays.where((p) => p['type'] == 'Zakat' && (p['date'] as String).startsWith('$y')).fold<double>(0, (s, p) => s + (p['amount'] as num).toDouble());
}
