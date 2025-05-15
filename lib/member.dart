import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail_member.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nfafmiaxogrxxwjuyqfs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mYWZtaWF4b2dyeHh3anV5cWZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAyNTIzMDcsImV4cCI6MjA1NTgyODMwN30.tsapVtnxkicRa-eTQLhKTBQtm7H9U1pfwBBdGdqryW0',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MemberScreen(),
    );
  }
}

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> _allMembers = []; // Data asli
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
  try {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      print('User belum login.');
      return;
    }

    // Ambil affiliate_id milik user yang sedang login
    final affiliate = await Supabase.instance.client
        .from('affiliates')
        .select('id')
        .eq('id_user', currentUser.id)
        .maybeSingle();

    if (affiliate == null) {
      print("Kamu belum menjadi affiliate.");
      return;
    }

    final affiliateId = affiliate['id'];

    // Ambil member yang hanya milik affiliate ini
    final response = await Supabase.instance.client
        .from('members')
        .select('*, users (username, email, phone)')
        .eq('affiliate_id', affiliateId);

    final data = response as List;

    setState(() {
      _allMembers = data.cast<Map<String, dynamic>>();
      _members = _allMembers;
      _isLoading = false;
    });
  } catch (e) {
    print('Gagal mengambil data members: $e');
    setState(() {
      _isLoading = false;
    });
  }
}


  void _filterMembers(String query) {
    final filtered = _allMembers.where((member) {
      final user = member['users'];
      final name = user?['username']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchQuery = query;
      _members = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Member",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Colors.green,
            height: 2.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterMembers, // <- Tambahkan ini
              decoration: InputDecoration(
                hintText: "Cari berdasarkan nama",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        final member = _members[index];
                        final user = member['users'];
                        final name = user?['username'] ?? 'Tidak diketahui';
                        final email = user?['email'] ?? '-';
                        final joinedAt = member['joined_at'] != null
                            ? DateTime.parse(member['joined_at'])
                            : null;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailMemberScreen(data: member),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.shade100,
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage:
                                      AssetImage('assets/icons/avatar.png'),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        email,
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "Bergabung : ${joinedAt != null ? "${joinedAt.day}-${joinedAt.month}-${joinedAt.year}" : "-"}",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    size: 14, color: Colors.black54),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}