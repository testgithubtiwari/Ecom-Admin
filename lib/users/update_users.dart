// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:admin/users/get_all_users.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateUsers extends StatefulWidget {
  final String firstName;
  final String id;
  final String token;
  final String lastName;
  final String emailId;
  final String mobile;
  final String role;
  const UpdateUsers(
      {required this.firstName,
      required this.id,
      required this.token,
      required this.lastName,
      required this.mobile,
      required this.role,
      required this.emailId,
      super.key});

  @override
  State<UpdateUsers> createState() => _UpdateUsersState();
}

class _UpdateUsersState extends State<UpdateUsers> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    // Initialize controllers with current data
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    mobileController.text = widget.mobile;
    roleController.text = widget.role;
    emailController.text = widget.emailId;
    super.initState();
  }

  Future<void> updateUser(String userId, String token) async {
    try {
      String apiUrl = 'http://172.31.46.143:5000/api/user/edit-user?id=$userId';
      print(apiUrl);

      Map<String, dynamic> userData = {
        "Firstname": firstNameController.text,
        "Lastname": lastNameController.text,
        "mobile": mobileController.text,
        "role": roleController.text,
        "email": emailController.text,
      };

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        print('User data updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Data Updated Successfully!'),
            backgroundColor: Color.fromARGB(255, 11, 77, 220),
          ),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const GetAllUsers()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network Error!'),
            backgroundColor: Colors.red,
          ),
        );
        print('Error: ${response.statusCode}');
        print('Failed to update user data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
          backgroundColor: Colors.red,
        ),
      );
      // Handle other errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Update User Data',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.blue,
        child: Container(
          // height: size.height * 0.50,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.amberAccent),
              borderRadius: BorderRadius.circular(size.width * 0.030),
              color: const Color.fromARGB(96, 185, 218, 21)),
          margin: EdgeInsets.all(size.width * 0.09),
          padding: EdgeInsets.all(size.width * 0.05),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(labelText: 'Mobile'),
                ),
                TextFormField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    updateUser(widget.id, widget.token);
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
