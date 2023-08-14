import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta/screen/profile_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController SearchControl = TextEditingController();
  bool ishowusers = false;

  @override
  void dispose() {
    super.dispose();
    SearchControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: const InputDecoration(
              labelText: 'Search for user',
              labelStyle: TextStyle(color: Colors.white)),
          onFieldSubmitted: (String _) {
            setState(() {
              ishowusers = true;
            });
            // print(
            //     _); // print(searchControl.text)-> both will return the text entered in the text field
          },
        ),
      ),
      body: ishowusers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: SearchControl.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: snapshot.data!.docs[index]['uid']))),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data!.docs[index]['photoUrl'],
                          ),
                        ),
                        title: Text(
                          snapshot.data!.docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('Posts').get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: snapshot.data!.docs[index]['postUrl'],
                            fit: BoxFit.cover,
                          ),
                        ));
                  },
                  staggeredTileBuilder: (index) {
                    return StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                  },
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                );
              },
            ),
    );
  }
}
