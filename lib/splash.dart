import 'package:flutter/material.dart';
import 'fleksibel_praktis.dart'; // Impor file penghasilan_tambahan.dart

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FleksibelPraktisScreen(), // Langsung ke PenghasilanTambahanScreen
          ),
        );
      }
    });
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
