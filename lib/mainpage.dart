// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:admin/auth/authprovider.dart';
import 'package:admin/auth/login.dart';
import 'package:admin/users/get_all_users.dart';
import 'package:admin/users/update_users.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String userId;
  String role = '';
  Map<String, dynamic> userData = {};
  late GlobalKey<RefreshIndicatorState> refreshKey;
  String name = '';
  String token = '';
  String email = '';
  String mobile = '';
  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    userId = authProvider.userId ?? '';
    fetchProfile(userId);
    fetchToken();
  }

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token')!;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  void logout() async {
    await clearToken();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'You have successfully Logged out!',
        ),
        backgroundColor: Colors.blue,
      ),
    );
    // Navigate to the login screen
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  Future<Map<String, dynamic>> fetchProfile(String userId) async {
    String profile = 'http://172.31.46.143:5000/api/user/profile?id=$userId';

    try {
      final response = await http.get(
        Uri.parse(profile),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        userData = json.decode(response.body)['data']['user'];
        name = userData['Firstname'] + " " + userData['Lastname'];
        mobile = userData['mobile'];
        email = userData['email'];
        role = userData['role'];
        print(name);
        print(mobile);
        print(email);
        updateUI();
        return userData;
      } else {
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
        return {};
      }
    } catch (error) {
      print('Error: $error');
      return {};
    }
  }

  Future<void> onRefresh() async {
    await fetchProfile(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Profile Page',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        child: ListView(
          children: [
            Container(
              color: Colors.blue,
              height: size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: size.width * 0.03,
                  ),
                  Text(
                    'Welcome to Main Page of Admin Pannel',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.03),
                    width: size.width * 0.80,
                    height: size.height * 0.50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(width: 1, color: Colors.amberAccent),
                      borderRadius: BorderRadius.circular(size.width * 0.04),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Profile Details',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        Text(
                          'UserName : $name',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        Text(
                          'Email : $email',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.02,
                        ),
                        Text(
                          'Contact Number : $mobile',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.09,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                logout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(132, 255,
                                    214, 64), // Set the background color
                              ),
                              child: Text(
                                'Logout',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateUsers(
                                      firstName: userData['Firstname'],
                                      id: userId,
                                      token: token,
                                      lastName: userData['Lastname'],
                                      mobile: mobile,
                                      role: role,
                                      emailId: email,
                                    ),
                                  ),
                                );
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //     content: Text(
                                //         'This functionality not completed yet!'),
                                //     backgroundColor: Colors.blue,
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(132, 255,
                                    214, 64), // Set the background color
                              ),
                              child: Text(
                                'Update Profile',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.width * 0.03,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const GetAllUsers()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(132, 255,
                                  214, 64), // Set the background color
                            ),
                            child: Text(
                              'Get All Users',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
