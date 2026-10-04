import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/auth.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await app.init();
  runApp(const ZakatApp());
}

class ZakatApp extends StatelessWidget {
  const ZakatApp({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (_, __) => MaterialApp(
          title: 'Zakat & Sadqa',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: const Color(0xFF0F6B4A), useMaterial3: true),
          builder: (c, child) => Directionality(textDirection: app.ur ? TextDirection.rtl : TextDirection.ltr, child: child!),
          home: app.me == null ? const AuthScreen() : const HomeScreen(),
        ),
      );
}
