import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/colors.dart'; // Pastikan file ini ada

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );

    if (shouldLogout ?? false) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text('Akun Saya', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.percent, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileCard(user),
          const SizedBox(height: 8),
          _buildMembershipCard(),

          const SizedBox(height: 16),
          _buildSectionTitle('PayLater'),
          _buildPaylaterFeatures(),

          const SizedBox(height: 16),
          _buildSectionTitle('Pilihan Pembayaran Saya'),
          _buildPaymentFeatures(),

          const SizedBox(height: 16),
          _buildSectionTitle('Rewards Saya'),
          _buildRewardsFeatures(),

          const SizedBox(height: 16),
          _buildSectionTitle('Asuransi Saya'),
          _buildInsuranceCard(),

          const SizedBox(height: 16),
          _buildSectionTitle('Fitur Member'),
          _buildMemberFeatures(),

          const SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () => _logout(context),
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'App Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProfileCard(User? user) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child:
                user?.photoURL == null
                    ? const Icon(Icons.person, size: 40, color: Colors.white)
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Guest User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'Masuk dengan Google',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to Edit Profile
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Lihat Profil',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFd7a579),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.emoji_events, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Kamu adalah Bronze Priority',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ],
      ),
    );
  }

  Widget _buildInsuranceCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFE0F7FA),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.verified_user, color: Colors.blue),
        ),
        title: const Text(
          'Akses polis Asuransi Anda kapan pun dan di mana pun.',
        ),
        subtitle: const Text(
          'Lihat Asuransi',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildPaylaterFeatures() {
    return Column(
      children: [
        _buildFeatureTile(
          'PayLater',
          'Ada promo spesial pengguna baru!',
          Icons.timelapse,
        ),
      ],
    );
  }

  Widget _buildPaymentFeatures() {
    return Column(
      children: [
        _buildFeatureTile(
          'Pembayaran',
          'Atur semua pembayaran yang disimpan',
          Icons.payments,
        ),
      ],
    );
  }

  Widget _buildRewardsFeatures() {
    return Column(
      children: [
        _buildFeatureTile(
          '0 Points',
          'Tukar poin dengan kupon! Ketuk untuk pelajari lebih lanjut.',
          Icons.paid_outlined,
          iconColor: Colors.yellow,
          badge: 'new!',
        ),
        _buildFeatureTile(
          'Mission Saya',
          'Selesaikan lebih banyak Mission, dapatkan lebih banyak reward!',
          Icons.domain_verification_rounded,
        ),
        _buildFeatureTile(
          'Kupon Saya',
          'Lihat kupon yang dapat Anda gunakan sekarang.',
          Icons.discount,
        ),
        _buildFeatureTile(
          'Affiliate',
          'Dapatkan komisi & reward eksklusif cuma dengan membagikan produk Hotel',
          Icons.attractions,
        ),
      ],
    );
  }

  Widget _buildMemberFeatures() {
    return Column(
      children: [
        _buildFeatureTile(
          'Traveler Info',
          'Kelola data traveler & alamat tersimpan',
          Icons.edit,
        ),
        _buildFeatureTile(
          'Refund',
          'Cek status refund & atur detail bank',
          Icons.attach_money,
        ),
        _buildFeatureTile(
          'Pusat Bantuan',
          'Temukan jawaban dari pertanyaan Anda',
          Icons.help_outline,
        ),
        _buildFeatureTile(
          'Hubungi Kami',
          'Bantuan dari Customer Service',
          Icons.support_agent,
        ),
        _buildFeatureTile(
          'Pengaturan',
          'Preferensi dan pengaturan akun',
          Icons.settings,
        ),
      ],
    );
  }

  Widget _buildFeatureTile(
    String title,
    String subtitle,
    IconData icon, {
    String? badge,
    Color iconColor = Colors.blueAccent, // tambahkan default color di sini
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}
