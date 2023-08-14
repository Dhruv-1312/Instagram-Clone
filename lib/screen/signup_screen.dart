import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/resources/auth.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/responsive/responsive_screen_layou.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/screen/login_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/text_feild.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailControll = TextEditingController();
  final TextEditingController passwordControll = TextEditingController();
  final TextEditingController bioControll = TextEditingController();
  final TextEditingController userNAmeControll = TextEditingController();
  Uint8List? _image;
  bool isloading = false;

  @override
  void dispose() {
    super.dispose();
    emailControll.dispose();
    passwordControll.dispose();
    bioControll.dispose();
    userNAmeControll.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void SignupUser() async {
    setState(() {
      isloading = true;
    });
    String res = await AuthMethods().createUser(
      email: emailControll.text,
      password: passwordControll.text,
      username: userNAmeControll.text,
      bio: bioControll.text,
      file: _image!,
    );
    setState(() {
      isloading = false;
    });
    if (res != 'success') {
      ShowSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveSreen(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigatetoLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 38),
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRYd77KFsw2Xd6mepJr49JeM4QDX2bMmjCF0LHaviMrGQ&usqp=CAU&ec=48665698'),
                      ),
                Positioned(
                  bottom: -10,
                  right: 2,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: userNAmeControll,
                hintext: 'Enter your user name',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: bioControll,
                hintext: 'Enter your bio',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: emailControll,
                hintext: 'Enter your email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              textEditingController: passwordControll,
              hintext: 'Enter your password',
              textInputType: TextInputType.text,
              ispass: true,
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: SignupUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor),
                child: isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : const Text('Sign up'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Already have an account "),
                ),
                GestureDetector(
                  onTap: navigatetoLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Log in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }
}
