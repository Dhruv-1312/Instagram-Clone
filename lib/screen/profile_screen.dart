import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/resources/auth.dart';
import 'package:insta/screen/login_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/models/users.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/follow_button.dart';
import 'package:insta/resources/firestor_methods.dart';

class ProfileScreen extends StatefulWidget {
  final uid;
  const ProfileScreen({super.key, required this.uid});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userdata = {};
  int postlen = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    setState(() {
      isloading = true;
    });
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var post = await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      userdata = snap.data()!;
      postlen = post.docs.length;
      followers = snap.data()!['followers'].length;
      following = snap.data()!['following'].length;
      isfollowing = snap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      ShowSnackBar(e.toString(), context);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userdata['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userdata['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildstatColumn(postlen, "Posts"),
                                    buildstatColumn(followers, "Followers"),
                                    buildstatColumn(following, "Following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            textcolor: primaryColor,
                                            function: () async {
                                              AuthMethods().SignOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                            const LoginScreen()));
                                            },
                                          )
                                        : isfollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.white,
                                                textcolor: Colors.black,
                                                function: () async {
                                                  FirestoreMethods().followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                                  setState(() {
                                                    isfollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                textcolor: Colors.white,
                                                function: () async {
                                                  FirestoreMethods().followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      widget.uid);
                                                  setState(() {
                                                    isfollowing = false;
                                                    following++;
                                                  });
                                                },
                                              ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 13),
                        child: Text(
                          userdata['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userdata['bio'],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image(
                              image: NetworkImage(
                                  snapshot.data!.docs[index]['postUrl']),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  },
                )
              ],
            ),
          );
  }

  Column buildstatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
