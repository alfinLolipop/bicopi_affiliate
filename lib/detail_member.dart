import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailMemberScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailMemberScreen({Key? key, required this.data}) : super(key: key);

  @override
  _DetailMemberScreenState createState() => _DetailMemberScreenState();
}

class _DetailMemberScreenState extends State<DetailMemberScreen> {
  List<Map<String, dynamic>> _riwayatTransaksi = [];
  StreamSubscription<List<Map<String, dynamic>>>? _affiliateLogSubscription;

  bool _isLoadingRiwayat = true;

  Stream<List<Map<String, dynamic>>>? _affiliatePointLogStream;
  String? _currentAffiliateId; // ID affiliate yang login

  // Variabel lokal untuk UI dropdown
  int kelipatan = 10;
  int _selectedPercentage = 10;
  final int maxPersen = 100;

  List<int> get _percentages =>
      List.generate((maxPersen ~/ kelipatan), (index) => (index + 1) * kelipatan);

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _fetchRiwayatTransaksi();
    _getCurrentAffiliateId(); // Dapatkan ID affiliate saat ini dan set up listener
  }

  // Metode untuk mendapatkan ID affiliate yang sedang login
  Future<void> _getCurrentAffiliateId() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _currentAffiliateId = user.id;
      });
      _setupAffiliatePointLogListener(); // Set up listener setelah ID affiliate didapatkan
    } else {
      print('Tidak ada affiliate yang login.');
      // Handle jika tidak ada user yang login, mungkin redirect ke halaman login
      // Atau tampilkan pesan kesalahan di UI
    }
  }

  // Metode untuk menyiapkan listener Realtime Supabase
  void _setupAffiliatePointLogListener() {
  if (_currentAffiliateId == null) return;

  final stream = Supabase.instance.client
      .from('affiliate_points_log')
      .stream(primaryKey: ['id'])
      .eq('affiliate_id', _currentAffiliateId!)
      .order('created_at', ascending: false);

  _affiliateLogSubscription = stream.listen((data) async {
    for (var log in data) {
      final logId = log['id'];
      final int points = log['points_earned'] ?? 0;
      final String? memberId = log['member_id'];
      final String? orderId = log['order_id'];

      // Skip jika data tidak valid
      if (points <= 0 || memberId == null) continue;

      // Cek apakah log sudah diproses sebelumnya (opsional: jika ada kolom 'processed')
      final existing = await Supabase.instance.client
          .from('member_points_log')
          .select()
          .eq('order_id', orderId as Object)
          .eq('member_id', memberId)
          .maybeSingle();

      if (existing != null) {
        print('Log $logId sudah pernah diproses.');
        continue;
      }

      await _processAffiliatePoints(points, memberId, orderId);
    }
  }, onError: (e) {
    print('❌ Error listening to affiliate_points_log: $e');
  });
}

  // Metode untuk memproses poin dari affiliate
  // Sekarang menerima memberIdToReceivePoints dan orderId dari log affiliate
  Future<void> _processAffiliatePoints(
      int totalPoinAffiliate, String memberIdToReceivePoints, String? orderId) async {
    if (_currentAffiliateId == null) {
      print('Affiliate ID tidak tersedia untuk memproses poin.');
      return;
    }

    // --- BARU: Ambil presentase TERKINI dari tabel 'members' ---
    int actualPercentage = 10; // Default fallback
    try {
      final memberData = await Supabase.instance.client
          .from('members')
          .select('presentase') // Hanya ambil 'presentase' karena itu yang digunakan untuk perhitungan
          .eq('id', memberIdToReceivePoints)
          .single();

      if (memberData != null && memberData['presentase'] != null) {

        actualPercentage = memberData['presentase'] as int;
      } else {
        print('Data presentase member tidak ditemukan atau tipe data salah untuk ID: $memberIdToReceivePoints, menggunakan nilai default.');
      }
    } catch (e) {
      print('Gagal mengambil presentase member dari database: $e, menggunakan nilai default.');
    }
    // --- AKHIR DARI BAGIAN BARU ---

    // Gunakan actualPercentage yang baru diambil dari database
    int poinUntukMember = ((totalPoinAffiliate * actualPercentage) / 100).round();

    print('✅ Affiliate mengirim poin!');
    print('Affiliate mengirim: $totalPoinAffiliate poin');
    print('Mengirim $actualPercentage% poin ke member: $poinUntukMember');

    try {
      // Masukkan poin ke member_points_log
      await Supabase.instance.client.from('member_points_log').insert({
        'member_id': memberIdToReceivePoints,
        'points_earned': poinUntukMember,
        'description': 'Menerima $poinUntukMember poin dari transaksi affiliate (Affiliate ID: $_currentAffiliateId)',
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'order_id': orderId, // Masukkan order_id dari log affiliate
      });

      print('Poin berhasil dikirim ke member_points_log.');
      // Refresh riwayat transaksi member setelah poin ditambahkan,
      // tapi hanya jika member_id yang ditambahkan adalah member yang sedang dilihat di layar ini.
      if (memberIdToReceivePoints == widget.data['id']) {
         _fetchRiwayatTransaksi();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil mengirim $poinUntukMember poin ke member!'),
        ),
      );
    } catch (e) {
      print('Gagal mengirim poin ke member_points_log: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim poin ke member: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
void dispose() {
  _affiliateLogSubscription?.cancel(); // Stop listener realtime
  super.dispose();
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

  void _initializeValues() {
    setState(() {
      // Pastikan casting ke int, karena dari database mungkin datang sebagai int? atau dynamic
      kelipatan = widget.data['kelipatan'] as int? ?? 10;
      _selectedPercentage = widget.data['presentase'] as int? ?? kelipatan;
    });
  }

  Future<void> _updateKelipatanDanPersentase() async {
    final id = widget.data['id']; // ID member yang sedang dilihat
    final now = DateTime.now().toUtc().toIso8601String();

    try {
      // Tambahkan .select() untuk mendapatkan response dari operasi update
      final response = await Supabase.instance.client.from('members').update({
        'kelipatan': kelipatan, // Nilai yang dipilih di dropdown UI
        'presentase': _selectedPercentage, // Nilai yang dipilih di dropdown UI
        'updated_at': now,
      }).eq('id', id).select(); // Menambahkan .select() di sini

      // Supabase postgrest-dart (client) tidak akan mengembalikan 'hasError' secara langsung
      // jika terjadi kesalahan jaringan atau server, ia akan melempar exception.
      // Jika response kosong atau tidak ada data yang diupdate, itu juga bisa menandakan masalah.
      if (response.isEmpty) { // Cek apakah tidak ada data yang dikembalikan (artinya mungkin gagal update)
        print('Gagal update data: Response kosong');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui pengaturan poin member. Data tidak ditemukan atau tidak diizinkan.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // Jika response tidak kosong, anggap berhasil
        print('Kelipatan dan presentase berhasil diupdate di database.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengaturan poin member berhasil diperbarui!'),
          ),
        );
      }
    } catch (e) {
      // Tangkap exception jika ada error dari Supabase client
      print('Gagal update data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan saat memperbarui: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.data['users'] ?? {};
    final name = user['username'] ?? 'Tidak diketahui';
    final email = user['email'] ?? '-';
    final status = widget.data['status'] ?? 'Aktif';
    final phone = user['phone'] ?? '-';
    final photoUrl = user['photo_url'] ?? '';

    ImageProvider profileImageProvider;
    if (photoUrl.isNotEmpty &&
        (photoUrl.startsWith('http://') || photoUrl.startsWith('https://'))) {
      profileImageProvider = NetworkImage(photoUrl);
    } else {
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
            _buildProfileCard(name, email, status, phone, profileImageProvider),
            const SizedBox(height: 16),
            _buildPointSection(), // Bagian untuk mengatur kelipatan dan presentase member
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
                          final description = log['description'] as String? ?? 'Transaksi';

                          Color statusColor = Colors.grey;
                          String statusText = 'Unknown';

                          // Sesuaikan status berdasarkan deskripsi
                          if (description.contains('Menerima') && description.contains('affiliate')) {
                            statusColor = Colors.green;
                            statusText = 'Diterima dari Affiliate';
                          } else if (description.contains('Dikirim')) {
                            statusColor = Colors.blue;
                            statusText = 'Dikirim';
                          }
                          // Tambahkan kondisi lain jika ada tipe log lain

                          return _buildTransactionItem(
                            tanggal,
                            '$poin poin',
                            statusText,
                            statusColor,
                          );
                        }).toList(),
                      ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Bagian Widget yang tidak berubah
  Widget _buildProfileCard(String name, String email, String status, String phone,
      ImageProvider imageProvider) {
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
                backgroundImage: imageProvider,
                backgroundColor: Colors.grey.shade200,
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
            'Pengaturan Point Member',
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
                    _updateKelipatanDanPersentase(); // Update ke database
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
                _updateKelipatanDanPersentase(); // Update ke database
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