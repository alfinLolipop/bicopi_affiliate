import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UbahPasswordScreen(),
    );
  }
}

class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({super.key});

  @override
  _UbahPasswordScreenState createState() => _UbahPasswordScreenState();
}

class _UbahPasswordScreenState extends State<UbahPasswordScreen> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _isObscure3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Ubah Password',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.green, height: 2.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildPasswordField(
                'Password saat ini', 'Masukkan password saat ini', _isObscure1,
                (value) {
              setState(() => _isObscure1 = !_isObscure1);
            }),
            const SizedBox(height: 12),
            buildPasswordField(
                'Password baru', 'Masukkan password baru', _isObscure2,
                (value) {
              setState(() => _isObscure2 = !_isObscure2);
            }),
            const SizedBox(height: 12),
            buildPasswordField('Konfirmasi Password baru',
                'Konfirmasi password baru', _isObscure3, (value) {
              setState(() => _isObscure3 = !_isObscure3);
            }),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Tambahkan aksi simpan perubahan di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // 🔹 Tidak terlalu melengkung
                ),
              ),
              child: Text('Simpan Perubahan',
                  style: GoogleFonts.poppins(fontSize: 14)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // 🔹 Tidak terlalu melengkung
                ),
              ),
              child: Text('Batalkan', style: GoogleFonts.poppins(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordField(
      String label, String hint, bool isObscure, Function onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700])),
        const SizedBox(height: 4),
        TextField(
          obscureText: isObscure,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300)),
            suffixIcon: IconButton(
              icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey),
              onPressed: () => onTap(isObscure),
            ),
          ),
        ),
      ],
    );
  }
}
