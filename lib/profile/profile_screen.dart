import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:math' as math;
import '../drawer.dart';
import '../auth/services/auth.dart';



class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends ConsumerState<UserProfilePage> {
  final double coverHeight = 230;
  final double profileHeight = 130;

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Image.asset(
          'images/books.jpg',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover),
    );
  }

  Widget buildProfileImage(String url) {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(url),
    );
  }

  Widget buildTop(String? profileImgUrl) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: buildCoverImage()),
        Positioned(top: top, child: buildProfileImage(profileImgUrl!=null ? profileImgUrl : 'https://www.iprcenter.gov/image-repository/blank-profile-picture.png/@@images/image.png')),

      ],
    );
  }

  Widget buildHeader(String? name) {
    return Column(
      children: [
        Text(name!=null ? name:'User', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
       
      ],
    );
  }

  Widget buildBody(String? uid) {
    

   

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),

          const SizedBox(
            height: 5,
          ),
          Divider(),
          const SizedBox(
            height: 5,
          ),
          
          
          // Text(widget.lawyers.about),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight / 2;
    final bottom = profileHeight / 2;
    final GlobalKey<ScaffoldState> _key = GlobalKey();
    final user = ref.watch(userProvider);
    return Scaffold(
        key: _key,
        drawer: DrawerWidget(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              _key.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildTop(user?.imgUrl),
            buildHeader(user?.name),
            buildBody(user?.id)
          ],
        ));
  }
}
