import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:promilo_project/models/login_req_model.dart';
import 'package:promilo_project/providers/authentication_provider.dart';
import 'package:promilo_project/screens/home/home_page.dart';
import 'package:promilo_project/utils/constants.dart';
import 'package:promilo_project/utils/locator.dart';
import 'package:promilo_project/utils/session_manager.dart';
import 'package:promilo_project/utils/toast_message.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/logIn';

  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _session = locator.get<SessionManager>();
  final _passwordFocus = FocusNode();
  String? _errorEmail, _errorPassword;

  void _login(BuildContext context) async {
    if (_email.text.isEmpty) {
      setState(() => _errorEmail = 'Please enter email id.');
    } else if (_password.text.isEmpty) {
      setState(() => _errorPassword = 'Please enter password.');
    } else {
      final encrypted = sha256.convert(utf8.encode(_password.text));
      LoginReqModel model = LoginReqModel(username: _email.text, grantType: 'password', password: encrypted.toString());
      context.read<AuthenticationProvider>().login(context, model).then((response) {
        _session.setUserName(_email.text);
        _session.setPassword(_password.text);
        if (response) {
          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.read<AuthenticationProvider>().isRemember) {
        _email.text = _session.getUserName();
        _password.text = _session.getPassword();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(title: const Text('promilo', style: TextStyle(color: Colors.black)), centerTitle: true),
      body: SingleChildScrollView(
        child: Container(
          height: height - kToolbarHeight - statusBarHeight,
          padding: const EdgeInsets.all(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Please Sign in to continue'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: 'Enter Email or Mob No.',
                      errorText: _errorEmail,
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPrimaryColor)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                    ),
                    onChanged: (String? text) {
                      if (text != null && _errorEmail != null) setState(() => _errorEmail = null);
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ToastMessage.showMessage('It will open Sign in With OTP screen.', kToastInfoColor);
                      },
                      child: const Text('Sign in With OTP', style: TextStyle(color: kPrimaryColor), textAlign: TextAlign.right),
                    ),
                  ),
                  const Text('Password'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      errorText: _errorPassword,
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kPrimaryColor)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
                    ),
                    onChanged: (String? text) {
                      if (text != null && _errorPassword != null) setState(() => _errorPassword = null);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    focusNode: _passwordFocus,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Selector<AuthenticationProvider, bool>(
                              selector: (c, p) => p.isRemember,
                              builder: (context, isRemember, child) {
                                return Checkbox(value: isRemember, onChanged: (value) => context.read<AuthenticationProvider>().setRemember(value!));
                              }),
                          const Text('Remember Me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          ToastMessage.showMessage('It will open forget password dialog or screen.', kToastInfoColor);
                        },
                        child: const Text('Forget Password', style: TextStyle(color: kPrimaryColor), textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Selector<AuthenticationProvider, bool>(
                    selector: (c, p) => p.isLoading,
                    builder: (context, isLoading, child) {
                      return isLoading
                          ? const Column(
                              children: [
                                Center(child: CircularProgressIndicator(color: kPrimaryColor)),
                                SizedBox(height: 10),
                              ],
                            )
                          : Container();
                    },
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        _login(context);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(width: 2, color: kPrimaryColor))),
                      child: const Text('Submit', style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Container(height: 1, margin: const EdgeInsets.all(10), color: Colors.grey.shade300)),
                      const Text('or'),
                      Expanded(child: Container(height: 1, margin: const EdgeInsets.all(10), color: Colors.grey.shade300))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialMediaButton(onTap: () {}, image: 'assets/icon_google.png'),
                      _SocialMediaButton(onTap: () {}, image: 'assets/icon_linkedin.png'),
                      _SocialMediaButton(onTap: () {}, image: 'assets/icon_fb.png'),
                      _SocialMediaButton(onTap: () {}, image: 'assets/icon_insta.png'),
                      _SocialMediaButton(onTap: () {}, image: 'assets/icon_whatsapp.png'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DiffLogin(onPressed: () {}, title: 'Business User?', buttonText: 'Login Here'),
                      _DiffLogin(onPressed: () {}, alignment: CrossAxisAlignment.end, title: 'Don\'t have an account', buttonText: 'Sign Up'),
                    ],
                  )
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: height * 0.80,
                child: Text('Hi, Welcome Back!', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 24), textAlign: TextAlign.center),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    const Text('By continuing, you agree to', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 2),
                    InkWell(
                      onTap: () {},
                      child: Text.rich(
                          TextSpan(text: 'Promilo\'s', children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(' Terms of Use & Privacy Policy.', style: TextStyle(color: Colors.black)),
                              ),
                            )
                          ]),
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                    // const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiffLogin extends StatelessWidget {
  const _DiffLogin({super.key, required this.onPressed, required this.title, required this.buttonText, this.alignment});

  final String title, buttonText;
  final VoidCallback onPressed;
  final CrossAxisAlignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment ?? CrossAxisAlignment.start,
      children: [
        Text(title),
        TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            child: Text(buttonText))
      ],
    );
  }
}

class _SocialMediaButton extends StatelessWidget {
  const _SocialMediaButton({super.key, required this.image, required this.onTap});

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(image, height: width * 0.1, width: width * 0.1),
        ));
  }
}
