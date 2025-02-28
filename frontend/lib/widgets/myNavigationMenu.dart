import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness2/pages/Search.dart';
import 'package:fitness2/pages/WelcomeScreen.dart';
import 'package:fitness2/pages/cart/cart.dart';
import 'package:fitness2/pages/home.dart';
import 'package:fitness2/pages/profile/profile.dart';
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: tdcyan),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // ✅ Cukup pop untuk kembali ke home
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => Navigator.pop(context),
          ),
          const Divider(),
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
            },
          ),
        ],
      ),
    );
  }
}
