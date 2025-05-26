import 'package:flutter/material.dart';
import 'package:villanakey/components/button.dart';
import 'package:villanakey/components/google_login.dart';
import 'package:villanakey/components/text_login_form.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                const SizedBox(height: 50),
                Text(
                  'Login to Your Account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                // Email INPUT
                TextLoginForm(
                  controller: emailController,
                  text: 'Email',
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 10),

                // Password INPUT
                TextLoginForm(
                  controller: passwordController,
                  text: 'Password',
                  obscure: true,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                Button(),
                const SizedBox(height: 10),
                GoogleLogin(),
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
                  style: TextStyle(
                    color: Color(0xFF819766),   
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
