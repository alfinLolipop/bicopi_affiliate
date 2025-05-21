import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';
import 'popup.dart';
import 'notifikasi.dart';
import 'profil.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  _PointsScreen createState() => _PointsScreen();
}

class _PointsScreen extends State<PointsScreen> {
  int _currentIndex = 1;
  int? currentPoints;
  List<Map<String, dynamic>> rewards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await fetchPointsFromSupabase();
    await fetchRewardsFromSupabase();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPointsFromSupabase() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('affiliates')
          .select('total_points')
          .eq('id_user', user.id)
          .maybeSingle();

      if (response != null && response['total_points'] != null) {
        setState(() {
          currentPoints = response['total_points'];
        });
      }
    } catch (e) {
      print('Error fetching points: $e');
    }
  }

  Future<void> fetchRewardsFromSupabase() async {
    try {
      final response = await Supabase.instance.client
          .from('klaim_rewards')
          .select();

      print('Response klaim_rewards: $response');

      setState(() {
        rewards = List<Map<String, dynamic>>.from(response).map((r) {
          return {
            "title": r['judul'] ?? '',
            "description": r['deskripsi'] ?? '',
            "points": r['points'] ?? 0,
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching rewards: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Points',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.green,
            height: 2.0,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Point Saat Ini",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentPoints != null ? "$currentPoints" : "0",
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: rewards.isEmpty
                      ? const Center(child: Text("Tidak ada reward tersedia"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: rewards.length,
                          itemBuilder: (context, index) {
                            final reward = rewards[index];
                            return _buildRewardCard(
                              context,
                              reward["title"],
                              reward["description"],
                              reward["points"],
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            Widget nextScreen;
            if (index == 0) {
              nextScreen = const HomeScreen();
            } else if (index == 2) {
              nextScreen = const NotificationScreen();
            } else if (index == 3) {
              nextScreen = const ProfileScreen();
            } else {
              return;
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => nextScreen),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Points'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildRewardCard(BuildContext context, String title, String description, int points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text("$points Points", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: currentPoints != null && currentPoints! >= points
                    ? () => showRedeemDialog(context, title, points)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text("Klaim reward", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showRedeemDialog(BuildContext context, String title, int points) {
    if (currentPoints! < points) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Poin Tidak Cukup"),
            content: const Text("Maaf, poin Anda tidak cukup untuk menukar reward ini."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Penukaran"),
          content: Text("Tukar $points poin untuk $title?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final user = Supabase.instance.client.auth.currentUser;

                if (user != null) {
                  int updatedPoints = currentPoints! - points;
                  try {
                    // Update ke Supabase
                    await Supabase.instance.client
                        .from('affiliates')
                        .update({'total_points': updatedPoints})
                        .eq('id_user', user.id);

                    setState(() {
                      currentPoints = updatedPoints;
                    });
                  } catch (e) {
                    print('Error updating points: $e');
                    // Tambahkan notifikasi error kalau mau
                  }

                  String transactionId = generateUniqueId();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PopupPage(
                        title: title,
                        points: points,
                        transactionId: transactionId,
                      ),
                    ),
                  );
                }
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}