import 'package:flutter/material.dart';
import 'login.dart';
import 'makinatakim.dart';
import 'listele.dart';

void main() {
  runApp(StokTakipApp());
}

class StokTakipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stok Takip Sistemi',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => StokTakip(),
        '/list': (context) => ListelePage(),
      },
    );
  }
}
