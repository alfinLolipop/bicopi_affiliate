import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailMemberScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailMemberScreen({Key? key, required this.data}) : super(key: key);

  @override
  _DetailMemberScreenState createState() => _DetailMemberScreenState();
}

class _DetailMemberScreenState extends State<DetailMemberScreen> {
  int _selectedPercentage = 10;
  final List<int> _percentages = [10, 20, 30, 40];

  @override
  void initState() {
    super.initState();
    // Tidak perlu kirim poin saat initState!
  }

  /// Fungsi ini akan dipanggil saat member membeli barang
  void prosesTransaksi(int totalPoin) {
    int poinAffiliate = totalPoin;
    int poinUntukMember = ((poinAffiliate * _selectedPercentage) / 100).round();
    int sisaPoinAffiliate = poinAffiliate - poinUntukMember;

    // Simulasi proses kirim
    print('✅ Member membeli barang!');
    print('Affiliate menerima: $poinAffiliate poin');
    print('Mengirim $_selectedPercentage% poin ke member: $poinUntukMember poin');
    print('Sisa poin affiliate: $sisaPoinAffiliate');

    // Tampilkan snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengirim $poinUntukMember poin ke member (${_selectedPercentage}%)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.data['users'] ?? {};
    final name = user['username'] ?? 'Tidak diketahui';
    final email = user['email'] ?? '-';
    final status = widget.data['status'] ?? 'Aktif';
    final phone = user['phone'] ?? '-';
    final komisi = widget.data['komisi'] ?? 0;
    final referral = widget.data['referral'] ?? 0;
    final poin = widget.data['poin'] ?? 0;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
        title: Text(
          "Detail Member",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.green,
            height: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== Card Profile =====================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/icons/avatar.png'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: const TextStyle(
                                  color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.email, size: 16),
                      const SizedBox(width: 8),
                      Text(email),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 16),
                      const SizedBox(width: 8),
                      Text(phone),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================== Card Info Komisi =====================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Total Komisi', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          'Rp. ${komisi.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[400],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Referral', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(
                          referral.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================== Pilihan Point =====================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Berikan Point',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: _percentages.map((percent) {
                      final isSelected = _selectedPercentage == percent;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPercentage = percent;
                          });
                          // Tidak kirim poin di sini!
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Persentase kirim poin diubah ke $percent%')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(8),
                            color: isSelected ? Colors.green[100] : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            '$percent%',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================== Riwayat Transaksi =====================
            const Text('Riwayat Transaksi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildTransactionItem('17 Maret 2025', '5000 points', 'Tertunda', Colors.red),
            _buildTransactionItem('16 Maret 2025', '5000 points', 'Sukses', Colors.green),
            _buildTransactionItem('15 Maret 2025', '5000 points', 'Sukses', Colors.green),

            const SizedBox(height: 32),

                      ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      String date, String amount, String status, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status,
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}