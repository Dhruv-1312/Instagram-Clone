import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta/resources/auth.dart';
import 'package:insta/responsive/mobile_screen_layout.dart';
import 'package:insta/responsive/responsive_screen_layou.dart';
import 'package:insta/responsive/web_screen_layout.dart';
import 'package:insta/screen/signup_screen.dart';
import 'package:insta/utils/colors.dart';
import 'package:insta/utils/utils.dart';
import 'package:insta/widgets/text_feild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailControll = TextEditingController();
  final TextEditingController passwordControll = TextEditingController();
  bool isalsoLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailControll.dispose();
    passwordControll.dispose();
  }

  void loginUser() async {
    setState(() {
      isalsoLoading = true;
    });
    String res = await AuthMethods()
        .loginUser(email: emailControll.text, password: passwordControll.text);
    setState(() {
      isalsoLoading = false;
    });
    if (res != 'success') {
      ShowSnackBar(res, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResponsiveSreen(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigatetoSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
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
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              'assets/images/ic_instagram.svg',
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            SizedBox(
              height: 30,
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
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor),
                child: isalsoLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Log in'),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text("Dont'n have an account  "),
                ),
                GestureDetector(
                  onTap: navigatetoSignUp,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Sign up',
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
