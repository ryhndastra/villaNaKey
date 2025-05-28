// Import tambahan
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:villanakey/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeInformationPage extends StatefulWidget {
  const ChangeInformationPage({super.key});

  @override
  State<ChangeInformationPage> createState() => _ChangeInformationPageState();
}

class _ChangeInformationPageState extends State<ChangeInformationPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

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

  Future<void> saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) return;

    final Map<String, dynamic> updatedData = {};

    final newName = nameController.text.trim();
    final newEmail = emailController.text.trim();
    final newPhone = phoneController.text.trim();

    if (newName.isNotEmpty && newName != userProvider.user?.name) {
      updatedData['name'] = newName;
    }

    if (newEmail.isNotEmpty && newEmail != userProvider.user?.email) {
      updatedData['email'] = newEmail;
      await currentUser?.updateEmail(newEmail);
    }

    if (newPhone.isNotEmpty && newPhone != userProvider.user?.phone) {
      updatedData['phone'] = newPhone;
    }

    if (updatedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada data yang diubah')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updatedData);
      await userProvider.fetchUser();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informasi berhasil diperbarui')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui: $e')));
    }
  }

  Future<void> showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.check, color: Color(0xff819766)),
              SizedBox(width: 8),
              Text(
                'Konfirmasi Perubahan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Apakah kamu yakin ingin menyimpan perubahan ini?',
            style: TextStyle(fontSize: 15),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff819766),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                saveChanges();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
            padding: const EdgeInsets.all(16),
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
                    const SizedBox(width: 12),
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
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Change Username",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    formFieldWrapper(
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        decoration: noBorderInput('${user?.name ?? ''}'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Change Email",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    formFieldWrapper(
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: noBorderInput('${user?.email ?? ''}'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Change Number",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    formFieldWrapper(
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: noBorderInput('${user?.phone ?? ''}'),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 1, height: 1, color: Colors.grey.shade200),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: showConfirmationDialog,
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            backgroundColor: const Color(0xff819766),
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
