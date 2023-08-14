import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/utils/Global_var.dart';
import 'package:insta/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:insta/models/users.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationtapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    //model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: (_page == 1) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,
                color: (_page == 2) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: (_page == 3) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: (_page == 4) ? primaryColor : secondaryColor),
            label: '',
            backgroundColor: mobileBackgroundColor,
          ),
        ],
        onTap: navigationtapped,
        currentIndex: _page,
      ),
    );
  }
}
