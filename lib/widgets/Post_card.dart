import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/users.dart' as model;
import 'package:insta/providers/user_provider.dart';
import 'package:insta/resources/firestor_methods.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:insta/screen/comment_screen.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}



class _PostCardState extends State<PostCard> {
  int commentsLen=0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments()async{
    try{
      QuerySnapshot snap= await FirebaseFirestore.instance.collection('Posts').doc(widget.snap['postid']).collection('Comments').get();
    commentsLen=snap.docs.length;
    }catch(e){
      ShowSnackBar(e.toString(), context);
    }
    setState(() {});
    
  }

  bool islikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
              .copyWith(right: 0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap['profimage']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: [
                            'Delete',
                          ]
                              .map((e) => InkWell(
                                    onTap: () async{
                                      FirestoreMethods().deletepost(widget.snap['postid']);
                                      Navigator.of(context).pop(); 
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ))
                              .toList()),
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),

          //Image section
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().updateLikes(
              widget.snap['uid'],
              widget.snap['postid'],
              widget.snap['likes'],
            );
            setState(() {
              islikeAnimating = true;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: islikeAnimating ? 1 : 0,
                child: LikeAnimation(
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                  isanimating: islikeAnimating,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                    setState(() {
                      islikeAnimating = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
        //like comment section
        Row(
          children: [
            LikeAnimation(
              isanimating: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().updateLikes(
                    widget.snap['uid'],
                    widget.snap['postid'],
                    widget.snap['likes'],
                  );
                },
                icon: widget.snap['likes'].contains(user.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline,
                      ),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommentScreen(postid: widget.snap['postid']),
                ),
              ),
              icon: const Icon(
                Icons.comment_outlined,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.send,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        //description and number of comments
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w800),
                child: Text(
                  '${widget.snap['likes'].length} likes',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: widget.snap['description'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'View all the $commentsLen comments',
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datepublished'].toDate(),
                  ),
                  style: const TextStyle(fontSize: 16, color: secondaryColor),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
