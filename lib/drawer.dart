import 'dart:convert';

import 'package:bookbuddy/home/home.dart';
import 'package:bookbuddy/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/services/auth.dart';
import '../main.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => DrawerWidgetState();
}

class DrawerWidgetState extends ConsumerState<DrawerWidget> {
 bool isLightTheme = true;

  Future<void> _saveTheme() async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isLightTheme', isLightTheme);
    });
  }

  void switchTheme(bool value) {
    setState(() {
      ref.read(themeProvider.notifier).update((state) => value);
      isLightTheme = value;
      _saveTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final isLightThemeProv = ref.watch(themeProvider);
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        children: [
          // UserAccountsDrawerHeader(
          //   accountName: Text(user!.name),
          //   accountEmail: Text(user!.email),
          //   currentAccountPicture: CircleAvatar(
          //     child: ClipOval(
          //       child: Image.network(
          //         user!.imgUrl,
          //         fit: BoxFit.cover,
          //         width: 90,
          //         height: 90,
          //       ),
          //     ),
          //   ),
          //   decoration: BoxDecoration(
          //     color: Colors.blue,
          //     image: DecorationImage(
          //         fit: BoxFit.fill,
          //         image: AssetImage('images/profilebg.jpg')),
          //   ),
          // ),
          Text(
            'BookBuddy',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          Divider(),

          ListTile(
            dense: true,
            visualDensity: VisualDensity(vertical: -1.5),
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              )
            },
          ),

          ListTile(
            dense: true,
            visualDensity: VisualDensity(vertical: -1.5),
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(),
                ),
              )
            },
          ),

          Divider(),

          ListTile(
            dense: true,
            visualDensity: VisualDensity(vertical: -1.5),
            trailing: Switch(
                value: isLightThemeProv,
                onChanged: switchTheme,
              ),
            title: Text(
              'Dark Mode',
              style: TextStyle(fontSize: 15),
            ),
            
          ),

          

          InkWell(
            onTap: () {
              signOut(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text("Log Out", style: TextStyle(color: Colors.white)),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromARGB(232, 0, 35, 65),
                ),
                padding: EdgeInsets.all(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
