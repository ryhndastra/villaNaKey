import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:villanakey/components/button.dart';
import 'package:villanakey/components/google_login.dart';
import 'dart:ui';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final RegExp _passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');

  Widget formFieldWrapper(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: child,
    );
  }

  InputDecoration noBorderInput(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: InputBorder.none,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Image.asset(
                        'assets/icons/logoya_app.png',
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    formFieldWrapper(
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: noBorderInput('Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),

                    formFieldWrapper(
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: noBorderInput('Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),

                    formFieldWrapper(
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 16,
                            ),
                            child: const Text('+62'),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter phone number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Only numbers allowed';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    formFieldWrapper(
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: noBorderInput(
                          'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          }
                          if (!_passwordRegex.hasMatch(value)) {
                            return 'Min 8 chars, 1 uppercase, 1 number';
                          }
                          return null;
                        },
                      ),
                    ),

                    formFieldWrapper(
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: noBorderInput(
                          'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirm = !_obscureConfirm;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    Button(
                      textBtn: 'Sign Up',
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          try {
                            await registerWithEmail(
                              context,
                              nameController.text.trim(),
                              emailController.text.trim(),
                              phoneController.text.trim(),
                              passwordController.text.trim(),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("or sign up with"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const GoogleLogin(label: "Sign Up With Google"),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              height: 50,
              color: Colors.white,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Color(0xFF42754C)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        if (_isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(color: Colors.black.withOpacity(0.2)),
                ),
                const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF42754C),
                    strokeWidth: 4,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Future<void> registerWithEmail(
  BuildContext context,
  String name,
  String email,
  String phone,
  String password,
) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final uid = userCredential.user!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': '+62$phone',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await userCredential.user!.sendEmailVerification();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Verifikasi Email'),
            content: Text(
              'Kami telah mengirimkan tautan verifikasi ke $email. Silakan periksa email Anda.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.message ?? 'Registrasi gagal')));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
    );
  }
}
