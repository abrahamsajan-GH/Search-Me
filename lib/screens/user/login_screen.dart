import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/admin/widgets/admin_landing.dart';
import 'package:search_me/screens/org/widgets/org_landing.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  void _login(Function navigateToHome) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _formKey.currentState!.fields['email']!.value as String,
          password: _formKey.currentState!.fields['password']!.value as String,
        );

        if (FirebaseAuth.instance.currentUser!.email == "admin@gmail.com") {
          Navigator.of(_formKey.currentContext!).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => AdminLanding()),
            (Route<dynamic> route) => false,
          );
        } else {
          navigateToHome();
        }
      } catch (e) {
        log('Login failed: $e');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: const Text(
          '',
          style: TextStyle(
            fontSize: 14,
          ),
        )),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: ClipRRect(
              borderRadius: br8,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                color: indigoClr.withOpacity(0.3),
                width: size.width * 0.9,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      height: size.height * 0.3,
                      decoration: BoxDecoration(
                        color: whiteClr.withOpacity(0.4),
                        borderRadius: br6,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign in to continue',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          h20,
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(color: blueClr, width: 2.0),
                                borderRadius: br6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/google.png',
                                  width: 35,
                                  height: 35,
                                ),
                                w10,
                                const Text(
                                  'Sign In with Google',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: blueClr),
                                )
                              ],
                            ),
                          ),
                          h10,
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                border: Border.all(color: blueClr, width: 2.0),
                                borderRadius: br6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/facebook.png',
                                  width: 35,
                                  height: 35,
                                ),
                                w10,
                                const Text(
                                  'Sign In with Facebook',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: blueClr),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    h20,
                    const Text(
                      'OR',
                      style: TextStyle(
                          color: blackClr, fontWeight: FontWeight.bold),
                    ),
                    FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            name: 'email',
                            decoration: const InputDecoration(
                                labelText: 'Enter E-mail'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ]),
                          ),
                          FormBuilderTextField(
                            name: 'password',
                            decoration: const InputDecoration(
                                labelText: 'Enter Password'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.minLength(6),
                            ]),
                            obscureText: true,
                          ),
                          h20,
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll(blueClr),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: br6))),
                            onPressed: _isLoading
                                ? null
                                : () => _login(() {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => OrgLanding(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: whiteClr,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(color: whiteClr),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
