import 'package:flutter/material.dart';
import 'verifikasi_email.dart'; // Import halaman verifikasi email
import 'login.dart' as login_page;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Logo
                Image.asset(
                  'assets/logo_bicopi.png',
                  width: 100,
                ),
                const SizedBox(height: 25),

                // Title
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Masukkan email dan password Anda.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Name Input
                _buildTextField(controller: nameController, icon: Icons.person, hintText: "Nama"),

                // Email Input
                _buildTextField(
                  controller: emailController,
                  icon: Icons.email,
                  hintText: "E-mail",
                  keyboardType: TextInputType.emailAddress,
                ),

                // Password Input
                _buildPasswordField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: obscurePassword,
                  onToggle: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),

                // Confirm Password Input
                _buildPasswordField(
                  controller: confirmPasswordController,
                  hintText: "Konfirmasi Password",
                  obscureText: obscureConfirmPassword,
                  onToggle: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),

                // Kode Referral Input
                _buildTextField(controller: referralController, icon: Icons.people, hintText: "Kode Referral"),
                const SizedBox(height: 0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Punya kode referral?',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateInputs()) {
                        // Navigasi ke halaman verifikasi email
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmailVerificationScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Login Link
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text('Sudah punya akun?', style: TextStyle(fontSize: 14)),
    TextButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const login_page.LoginScreen()),
        );
      },
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.green, fontSize: 14),
      ),
    ),
  ],
),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Validasi input
  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom harus diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan konfirmasi password tidak cocok!'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  // Widget untuk membuat TextField biasa
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // Widget untuk membuat TextField password
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock, color: Colors.black54),
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.black54),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
