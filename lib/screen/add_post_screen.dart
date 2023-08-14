import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/models/users.dart' as model;
import 'package:insta/providers/user_provider.dart';
import 'package:insta/resources/firestor_methods.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController disController = TextEditingController();
  bool isloading = false;
  selectImage(BuildContext parentContext) async {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create A Post'),
            children:<Widget> [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take A photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose From Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void postImage(String uid, String username, String profimage) async {
    setState(() {
      isloading = true;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(disController.text, _file!, uid, username, profimage);

      if (res == 'success') {
        setState(() {
          isloading = false;
        });
        if(context.mounted){
          ShowSnackBar('Posted', context);
        }
        clearImage();
      } else {
        ShowSnackBar(res, context);
      }
    } catch (e) {
      setState(() {
        isloading=false;
      });
      ShowSnackBar(e.toString(), context);
    }
  }
  void clearImage(){
  setState(() {
    _file= null;
  });
}

  @override
  void dispose() {
    super.dispose();
    disController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              onPressed: () => selectImage(context),
              icon: Icon(Icons.upload),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.photoUrl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                isloading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                      const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl.toString()),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Write a caption..',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                        controller: disController,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.center),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
