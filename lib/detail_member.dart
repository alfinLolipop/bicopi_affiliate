import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailMemberScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailMemberScreen({Key? key, required this.data}) : super(key: key);

  @override
  _DetailMemberScreenState createState() => _DetailMemberScreenState();
}

class _DetailMemberScreenState extends State<DetailMemberScreen> {
  int kelipatan = 10;
  int _selectedPercentage = 10;
  final int maxPersen = 100;

  List<int> get _percentages =>
      List.generate((maxPersen ~/ kelipatan), (index) => (index + 1) * kelipatan);

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    // Ambil kelipatan & presentase dari data Supabase untuk member ini
    setState(() {
      kelipatan = widget.data['kelipatan'] ?? 10;
      _selectedPercentage = widget.data['presentase'] ?? kelipatan;
    });
  }

  Future<void> _updateKelipatanDanPersentase() async {
  final id = widget.data['id'];
  final now = DateTime.now().toUtc().toIso8601String(); // waktu sekarang UTC

  final response = await Supabase.instance.client
      .from('members')
      .update({
        'kelipatan': kelipatan,
        'presentase': _selectedPercentage,
        'updated_at': now,  // penting supaya urutan berubah saat fetch ulang
      })
      .eq('id', id);

  if (response.error != null) {
    // kalau ingin, bisa tangani error di sini
    print('Gagal update data: ${response.error!.message}');
  }
}


  void prosesTransaksi(int totalPoin) {
    int poinAffiliate = totalPoin;
    int poinUntukMember =
        ((poinAffiliate * _selectedPercentage) / 100).round();
    int sisaPoinAffiliate = poinAffiliate - poinUntukMember;

    print('✅ Member membeli barang!');
    print('Affiliate menerima: $poinAffiliate poin');
    print('Mengirim $_selectedPercentage% poin ke member: $poinUntukMember');
    print('Sisa poin affiliate: $sisaPoinAffiliate');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Mengirim $poinUntukMember poin ke member ($_selectedPercentage%)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.data['users'] ?? {};
    final name = user['username'] ?? 'Tidak diketahui';
    final email = user['email'] ?? '-';
    final status = widget.data['status'] ?? 'Aktif';
    final phone = user['phone'] ?? '-';

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
            _buildProfileCard(name, email, status, phone),
            const SizedBox(height: 16),
            _buildPointSection(),
            const SizedBox(height: 16),
            const Text('Riwayat Transaksi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _buildTransactionItem(
                '17 Maret 2025', '5000 points', 'Tertunda', Colors.red),
            _buildTransactionItem(
                '16 Maret 2025', '5000 points', 'Sukses', Colors.green),
            _buildTransactionItem(
                '15 Maret 2025', '5000 points', 'Sukses', Colors.green),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      String name, String email, String status, String phone) {
    return Container(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
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
    );
  }

  Widget _buildPointSection() {
    return Container(
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
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          // Kelipatan
          Row(
            children: [
              const Text("Kelipatan: "),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: kelipatan,
                items: [5, 10, 20, 25].map((k) {
                  return DropdownMenuItem(
                    value: k,
                    child: Text('$k%'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      kelipatan = val;
                      _selectedPercentage = val; // reset persentase
                    });
                    _updateKelipatanDanPersentase();
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Persentase
          DropdownButtonFormField<int>(
            value: _selectedPercentage,
            decoration: InputDecoration(
              labelText: 'Pilih Presentase',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items: _percentages.map((percent) {
              return DropdownMenuItem(
                value: percent,
                child: Text('$percent %'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPercentage = value;
                });
                _updateKelipatanDanPersentase();
              }
            },
          ),
        ],
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
