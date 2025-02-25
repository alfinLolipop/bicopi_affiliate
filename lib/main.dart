import 'package:flutter/material.dart';
import 'splash.dart';
import 'fleksibel_praktis.dart';
import 'reward_bonus.dart';
import 'penghasilan_tambahan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan label debug
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // SplashScreen akan ditampilkan pertama kali
    );
  }
}
