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
  List<Map<String, dynamic>> _riwayatTransaksi = [];
  bool _isLoadingRiwayat = true;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _fetchRiwayatTransaksi();
  }

  Future<void> _fetchRiwayatTransaksi() async {
    final memberId = widget.data['id'];

    try {
      final response = await Supabase.instance.client
          .from('member_points_log')
          .select()
          .eq('member_id', memberId)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _riwayatTransaksi = List<Map<String, dynamic>>.from(response);
          _isLoadingRiwayat = false;
        });
      }
    } catch (e) {
      print('Gagal mengambil riwayat transaksi: $e');
      if (mounted) {
        setState(() {
          _isLoadingRiwayat = false;
        });
      }
    }
  }

  String _getNamaBulan(int bulan) {
    const bulanIndo = [
      '', // index ke-0 tidak dipakai
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return bulanIndo[bulan];
  }

  int kelipatan = 10;
  int _selectedPercentage = 10;
  final int maxPersen = 100;

  List<int> get _percentages => List.generate(
      (maxPersen ~/ kelipatan), (index) => (index + 1) * kelipatan);

  void _initializeValues() {
    setState(() {
      kelipatan = widget.data['kelipatan'] ?? 10;
      _selectedPercentage = widget.data['presentase'] ?? kelipatan;
    });
  }

  Future<void> _updateKelipatanDanPersentase() async {
    final id = widget.data['id'];
    final now = DateTime.now().toUtc().toIso8601String();

    final response = await Supabase.instance.client.from('members').update({
      'kelipatan': kelipatan,
      'presentase': _selectedPercentage,
      'updated_at': now,
    }).eq('id', id);

    // Gunakan response.hasError untuk penanganan error yang lebih baik
    if (response.hasError) {
      print('Gagal update data: ${response.error!.message}');
    } else {
      print('Kelipatan dan presentase berhasil diupdate.');
    }
  }

  void prosesTransaksi(int totalPoin) {
    int poinAffiliate = totalPoin;
    int poinUntukMember = ((poinAffiliate * _selectedPercentage) / 100).round();
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
    // Ambil photo_url dari data user
    final photoUrl = user['photo_url'] ?? ''; // Jika null, gunakan string kosong

    // Tentukan ImageProvider berdasarkan apakah photoUrl adalah URL atau kosong
    ImageProvider profileImageProvider;
    if (photoUrl.isNotEmpty && (photoUrl.startsWith('http://') || photoUrl.startsWith('https://'))) {
      profileImageProvider = NetworkImage(photoUrl);
    } else {
      // Fallback ke aset lokal jika photoUrl kosong atau bukan URL
      profileImageProvider = const AssetImage('assets/icons/avatar.png');
    }

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
            // Teruskan profileImageProvider ke _buildProfileCard
            _buildProfileCard(name, email, status, phone, profileImageProvider),
            const SizedBox(height: 16),
            _buildPointSection(),
            const SizedBox(height: 16),
            const Text(
              'Riwayat Transaksi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _isLoadingRiwayat
                ? const Center(child: CircularProgressIndicator())
                : _riwayatTransaksi.isEmpty
                    ? const Text('Belum ada transaksi.')
                    : Column(
                        children: _riwayatTransaksi.map((log) {
                          final dateTime = DateTime.parse(log['created_at']);
                          final tanggal =
                              '${dateTime.day} ${_getNamaBulan(dateTime.month)} ${dateTime.year}';
                          final poin = log['points_earned'] ?? 0;

                          return _buildTransactionItem(
                            tanggal,
                            '$poin poin',
                            'Terkirim',
                            Colors.green,
                          );
                        }).toList(),
                      ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Tambahkan parameter ImageProvider ke _buildProfileCard
  Widget _buildProfileCard(
      String name, String email, String status, String phone, ImageProvider imageProvider) {
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
              CircleAvatar(
                radius: 30,
                backgroundImage: imageProvider, // Gunakan ImageProvider di sini
                backgroundColor: Colors.grey.shade200, // Background jika gambar belum dimuat
                // Anda bisa menambahkan child Icon jika ingin menampilkan ikon placeholder
                // misalnya: child: (imageProvider is NetworkImage && imageProvider.url.isEmpty) ? Icon(Icons.person) : null,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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