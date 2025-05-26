import 'package:flutter/material.dart';
import 'package:villanakey/components/button.dart';
import 'package:villanakey/components/google_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  );

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
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/logoya_app.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Login to Your Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),

                // Email Field
                formFieldWrapper(
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: noBorderInput('Email'),
                  ),
                ),

                // Password Field
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

                const SizedBox(height: 16),
                Button(),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("or sign in with"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                const GoogleLogin(),
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
              const Text("Don't have an account? "),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Color(0xFF819766)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
