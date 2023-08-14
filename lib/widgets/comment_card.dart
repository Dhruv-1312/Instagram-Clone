import 'package:flutter/material.dart';
import 'package:insta/providers/user_provider.dart';
import 'package:insta/resources/firestor_methods.dart';
import 'package:intl/intl.dart';
import 'package:insta/models/users.dart' as model;
import 'package:provider/provider.dart';

class CommenCard extends StatefulWidget {
  final snap;
  const CommenCard({super.key, required this.snap});

  @override
  State<CommenCard> createState() => _CommenCardState();
}

class _CommenCardState extends State<CommenCard> {
  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profimage']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap['name']}',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['Comment']}',
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datepublished'].toDate()),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                
                padding: const EdgeInsets.only(bottom: 0),
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().commentLikes(
                        widget.snap['uid'],
                        widget.snap['postid'],
                        widget.snap['commentId'],
                        widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Container(
                          child: const Icon(Icons.favorite_outline),
                        ),
                ),
              ),
              Text('${widget.snap['likes'].length}'),
            ],
          ),
        ],
      ),
    );
  }
}
