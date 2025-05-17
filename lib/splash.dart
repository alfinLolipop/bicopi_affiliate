import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';  // Impor Supabase
import 'fleksibel_praktis.dart'; // Impor halaman tujuan
import 'login.dart'; // Impor halaman login jika perlu

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Fungsi untuk mengecek status login
  Future<void> _checkLoginStatus() async {
  final session = Supabase.instance.client.auth.currentSession;

  await Future.delayed(const Duration(seconds: 3));

  if (mounted) {
    if (session != null && session.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FleksibelPraktisScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih sesuai desain
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_bicopi.png', // Pastikan path gambar benar
              width: 200, // Ukuran gambar lebih besar sesuai desain
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang\nPada Aplikasi Kami',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22, // Ukuran font lebih besar
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '"Secangkir Inspirasi, Sejuta Kreasi"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
