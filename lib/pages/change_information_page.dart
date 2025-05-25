import 'package:flutter/material.dart';
import 'package:villanakey/components/edit_profile_form.dart';

class ChangeInformationPage extends StatefulWidget {
  const ChangeInformationPage({super.key});

  @override
  State<ChangeInformationPage> createState() => _ChangeInformationPageState();
}

class _ChangeInformationPageState extends State<ChangeInformationPage> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade500, height: 1),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/change_information.png',
                      width: 30,
                      height: 30,
                      color: const Color.fromARGB(255, 122, 122, 122),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Change Information Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Change Username",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    EditProfileForm(
                      hintText: 'New Username',
                      controller: userNameController,
                    ),
                    SizedBox(height: 20),

                    // Email Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Change Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    EditProfileForm(
                      hintText: 'New Email',
                      controller: emailController,
                    ),
                    SizedBox(height: 20),

                    // Number Section
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Change Number",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    EditProfileForm(
                      hintText: 'New Number',
                      controller: numberController,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 1, height: 1, color: Colors.grey.shade200),
        ],
      ),
      // Button Save Changes
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            print("Saved Change");
          },

          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            backgroundColor: Color(0xff819766),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 15,
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
