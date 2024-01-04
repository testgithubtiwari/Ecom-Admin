// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:admin/auth/authprovider.dart';
import 'package:admin/auth/register.dart';
import 'package:admin/mainpage.dart';
// import 'package:admin/notification_services.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Validation error messages
  String emailError = '';
  String passwordError = '';
  bool _isPasswordVisible = false;
  // bool _savePassword = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    const String url = 'http://172.31.46.143:5000/api/user/login';

    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];
        final String id = responseData['_id'];
        await _saveTokenToPrefs(token);
        await _saveIdToPrefs(id);

        Provider.of<AuthProvider>(context, listen: false).setUserId(id);

        print(responseData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
        isLoading = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Credentials!'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
        print('Error Message: ${response.body}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Network Error!'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
    }
  }

  Future<void> _saveTokenToPrefs(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> _saveIdToPrefs(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
  }

  @override
  void initState() {
    super.initState();
    _checkForStoredToken();
  }

  Future<void> _checkForStoredToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedToken = prefs.getString('token');
    final String? storedUserId = prefs.getString('id');

    if (storedToken != null && storedUserId != null) {
      // Check if the token is still valid (you may need to implement this logic)
      bool isValid = await _isTokenValid(storedToken);
      if (isValid) {
        Provider.of<AuthProvider>(context, listen: false)
            .setUserId(storedUserId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are already Logged In!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      } else {
        // Token is no longer valid, handle it (e.g., show login screen)
        print('Token is no longer valid? You have to log in again');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token is no longer valid? You have to log in again'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have not any Token or you LogOut last time'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _isTokenValid(String token) async {
    final String validateTokenUrl =
        'http://172.31.46.143:5000/api/user/check-token-validity?token=$token';

    try {
      final response = await http.post(
        Uri.parse(validateTokenUrl),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (error) {
      print('Error validating token: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text(
          'Admin Login Page',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Container(
          height: double.infinity,
          color: isLoading
              ? const Color.fromARGB(85, 39, 26, 11)
              : const Color.fromARGB(255, 58, 135, 199),
          child: Container(
            margin: EdgeInsets.all(size.width * 0.08),
            width: size.width * 0.90,
            height: size.width * 0.30,
            padding: EdgeInsets.all(size.width * 0.07),
            child: Column(
              children: [
                TextField(
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(color: Colors.white),
                    errorText: emailError,
                    errorStyle: GoogleFonts.poppins(color: Colors.white),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(size.width * 0.035),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: size.width * 0.04,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: passwordError,
                      labelStyle: GoogleFonts.poppins(color: Colors.white),
                      errorStyle: GoogleFonts.poppins(color: Colors.white),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(size.width * 0.035),
                        child: Icon(
                          Icons.password,
                          color: Colors.white,
                          size: size.width * 0.04,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      )),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Validate email and password
                    if (_validateInputs()) {
                      login(
                        emailController.text,
                        passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        132, 255, 214, 64), // Set the background color
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                      )
                    : Container(),
                SizedBox(
                  height: size.width * 0.03,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        141, 255, 214, 64), // Set the background color
                  ),
                  child: Text(
                    'SignUp',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool isValid = true;

    // Reset error messages
    setState(() {
      emailError = '';
      passwordError = '';
    });

    // Validate email
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Email is required';
      });
      isValid = false;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(emailController.text)) {
      setState(() {
        emailError = 'Enter a valid email address';
      });
      isValid = false;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Password is required';
      });
      isValid = false;
    }

    return isValid;
  }
}
