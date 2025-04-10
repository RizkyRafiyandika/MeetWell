import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/models/customeToastMsg.dart';
import 'package:fitness2/pages/Search.dart';
import 'package:fitness2/pages/WelcomeScreen.dart';
import 'package:fitness2/pages/cart/cart.dart';
import 'package:fitness2/pages/home.dart';
import 'package:fitness2/pages/profile/profile.dart';
import 'package:fitness2/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fitness2/constants/colors.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavigationMenu extends StatefulWidget {
  const MyNavigationMenu({super.key});

  @override
  _MyNavigationMenuState createState() => _MyNavigationMenuState();
}

class _MyNavigationMenuState extends State<MyNavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MyHomepage(),
    const MyCart(),
    const MySearch(),
    const myProfilePage(), // ✅ Perbaikan nama kelas
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      User? user = FirebaseAuth.instance.currentUser; // Cek apakah user login
      if (user == null || user.isAnonymous) {
        customToast("Your have login first ");
        return;
      }
    }

    // Jika lolos validasi, ubah tab
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding:
                const EdgeInsets.all(8), // Lebih kecil biar tidak terlalu tebal
            decoration: BoxDecoration(
              color: tdcyan.withOpacity(0.2), // Transparan lebih tinggi
            ),
            child: GNav(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              gap: 8,
              activeColor: tdbackground,
              tabBackgroundColor:
                  tdcyan.withOpacity(0.5), // Transparan agar smooth
              tabs: const [
                GButton(icon: Icons.home, text: "Home", iconColor: tdBlack),
                GButton(
                    icon: Icons.shopify_outlined,
                    text: "Cart",
                    iconColor: tdBlack),
                GButton(
                    icon: Icons.search, text: "Searches", iconColor: tdBlack),
                GButton(
                    icon: Icons.person, text: "Profile", iconColor: tdBlack),
              ],
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}

class MyAppDrawer extends StatelessWidget {
  const MyAppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // ✅ Ubah ListView menjadi Column
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: tdcyan),
            child: Text(
              'Menu Bar',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // ✅ Gunakan Expanded agar ListTile tetap di atas
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shopify_outlined),
                  title: const Text('Cart'),
                  onTap: () {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user == null || user.isAnonymous) {
                      customToast("You have to login first");
                      Navigator.pop(context);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (e) => MyCart()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('About'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(), // ✅ Garis pembatas di atas Logout
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
              signOutGoogle();
            },
          ),
          const SizedBox(
              height: 16), // ✅ Beri jarak antara logout dan bawah layar
        ],
      ),
    );
  }
}
