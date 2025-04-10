import 'package:fitness2/constants/colors.dart';
import 'package:fitness2/pages/loginPage.dart';
import 'package:fitness2/pages/profile/updateProfile.dart';
import 'package:fitness2/services/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class myProfilePage extends StatelessWidget {
  const myProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Profile", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(dark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset("assets/blueberry_pancake.jpeg")),
                ),
                SizedBox(height: 12),
                Text("RizyRafiyandika@gmail.com",
                    style: Theme.of(context).textTheme.labelMedium),
                Text("rizkyRafiyandika",
                    style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (e) => MyUpdateProfile()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdblue, // ✅ Pastikan nama warna benar
                      foregroundColor: tdGrey,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                    ),
                  ),
                ),

                SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),

                // Menu
                profileMenuWidget(
                  title: "Settings",
                  icon: LineAwesomeIcons.cog_solid,
                  onPress: () {},
                ),
                profileMenuWidget(
                  title: "History",
                  icon: LineAwesomeIcons.history_solid,
                  onPress: () {},
                ),
                profileMenuWidget(
                  title: "User management",
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {},
                ),
                const Divider(),
                const SizedBox(height: 20),
                profileMenuWidget(
                  title: "About",
                  icon: LineAwesomeIcons.info_circle_solid,
                  onPress: () {},
                ),
                profileMenuWidget(
                  title: "Logout",
                  icon: Icons.exit_to_app_rounded,
                  textColor: tdRed,
                  endIcon: false,
                  onPress: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (e) => MyLoginPage()));
                    signOutGoogle();
                  },
                ),
              ],
            )),
      ),
    );
  }
}

class profileMenuWidget extends StatelessWidget {
  const profileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: tdblue.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: tdBlack,
          ),
        ),
        title: Text(title,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.apply(color: textColor)),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: tdBlack.withOpacity(0.1),
                ),
                child: Icon(
                  LineAwesomeIcons.angle_right_solid,
                  color: tdBlack,
                  size: 18,
                ),
              )
            : null);
  }
}
