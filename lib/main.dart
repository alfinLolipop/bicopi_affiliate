import 'package:flutter/material.dart';
import 'splash.dart';
import 'fleksibel_praktis.dart';
import 'reward_bonus.dart';
import 'penghasilan_tambahan.dart';
import 'login.dart';
import 'lupa_password.dart';
import 'signup.dart';
import 'verifikasi_email.dart';
import 'home.dart';
import 'member.dart';
import 'detail_member.dart';
import 'points.dart';
import 'popup.dart';
import 'notifikasi.dart';
import 'profil.dart';

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
