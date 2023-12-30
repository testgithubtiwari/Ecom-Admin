import 'package:admin/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isloading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isPasswordVisibleConfirm = false;

  // Validation error messages
  String emailError = '';
  String passwordError = '';
  String firstnameError = '';
  String lastnameError = '';
  String mobileError = '';

  void signUp(
    String firstName,
    String email,
    String password,
    String lastName,
    String mobile,
  ) async {
    const String url = 'http://192.168.43.207:5000/api/user/register';
    Map<String, dynamic> data = {
      'Firstname': firstName,
      'Lastname': lastName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'role': "Admin",
    };
    isloading = true;

    // print(data);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // ignore: avoid_print
        print('Response data: ${response.body}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          isloading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Login()));
      } else if (response.statusCode == 400) {
        // ignore: avoid_print
        print('Error: User Already exist');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: User already exists'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isloading = false;
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: AbsorbPointer(
        absorbing: isloading,
        child: Container(
          height: size.height,
          color: isloading
              ? const Color.fromARGB(85, 39, 26, 11)
              : const Color.fromARGB(255, 58, 135, 199),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(size.width * 0.08),
              width: size.width * 0.90,
              padding: EdgeInsets.all(size.width * 0.07),
              child: Column(
                children: [
                  TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.05),
                      helperStyle: GoogleFonts.poppins(color: Colors.white),
                      errorStyle: GoogleFonts.poppins(
                          fontSize: size.width * 0.03, color: Colors.white),
                      hintStyle: GoogleFonts.poppins(color: Colors.white),
                      labelText: 'Email',
                      errorText: emailError,
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        size: size.width * 0.035,
                        color: Colors.white,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 9.0),
                  TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.05),
                      helperStyle: GoogleFonts.poppins(color: Colors.white),
                      errorStyle: GoogleFonts.poppins(
                          fontSize: size.width * 0.03, color: Colors.red),
                      hintStyle: GoogleFonts.poppins(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                        size: size.width * 0.035,
                      ),
                      labelText: 'Password',
                      errorText: passwordError,
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
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                  ),
                  const SizedBox(height: 9.0),
                  TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    controller: confirmpasswordController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.05),
                      helperStyle: GoogleFonts.poppins(color: Colors.white),
                      errorStyle: GoogleFonts.poppins(
                          fontSize: size.width * 0.03, color: Colors.red),
                      hintStyle: GoogleFonts.poppins(color: Colors.white),
                      labelText: 'Confirm Password',
                      errorText: passwordError,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                        size: size.width * 0.035,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisibleConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisibleConfirm =
                                !_isPasswordVisibleConfirm;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisibleConfirm,
                  ),
                  const SizedBox(height: 9.0),
                  TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    controller: firstnameController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: size.width * 0.05),
                        helperStyle: GoogleFonts.poppins(color: Colors.white),
                        errorStyle: GoogleFonts.poppins(
                            fontSize: size.width * 0.03, color: Colors.red),
                        hintStyle: GoogleFonts.poppins(color: Colors.white),
                        errorText: firstnameError,
                        labelText: 'Fisrt Name',
                        prefixIcon: Icon(
                          Icons.person,
                          size: size.width * 0.04,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(height: 9.0),
                  TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    controller: lastnameController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.white, fontSize: size.width * 0.05),
                        helperStyle: GoogleFonts.poppins(color: Colors.white),
                        errorStyle: GoogleFonts.poppins(
                            fontSize: size.width * 0.03, color: Colors.red),
                        hintStyle: GoogleFonts.poppins(color: Colors.white),
                        labelText: 'Last Name',
                        errorText: lastnameError,
                        prefixIcon: Icon(
                          Icons.class_outlined,
                          color: Colors.white,
                          size: size.width * 0.04,
                        )),
                  ),
                  const SizedBox(height: 9.0),
                  // const SizedBox(height: 9.0),
                  TextField(
                    style: GoogleFonts.poppins(color: Colors.white),
                    controller: mobileController,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                          color: Colors.white, fontSize: size.width * 0.05),
                      helperStyle: GoogleFonts.poppins(color: Colors.white),
                      errorStyle: GoogleFonts.poppins(
                          fontSize: size.width * 0.03, color: Colors.red),
                      hintStyle: GoogleFonts.poppins(color: Colors.white),
                      labelText: 'Mobile',
                      errorText: mobileError,
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: size.width * 0.04,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Validate inputs
                      if (_validateInputs()) {
                        signUp(
                          firstnameController.text,
                          emailController.text,
                          passwordController.text,
                          lastnameController.text,
                          mobileController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          147, 255, 214, 64), // Set the background color
                    ),
                    child: Text(
                      'Regsiter',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: size.width * 0.05),
                    ),
                  ),
                  isloading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.black,
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    bool isValid = true;

    setState(() {
      emailError = '';
      passwordError = '';
      firstnameError = '';
      lastnameError = '';
      mobileError = '';
    });

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

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Password is required';
      });
      isValid = false;
    } else if (passwordController.text != confirmpasswordController.text) {
      setState(() {
        passwordError = 'Password and confirm password not matched';
      });
    }

    if (firstnameController.text.isEmpty) {
      setState(() {
        firstnameError = 'First Name is required';
      });
      isValid = false;
    }

    if (lastnameController.text.isEmpty) {
      setState(() {
        lastnameError = 'Last Name is required';
      });
      isValid = false;
    }

    if (mobileController.text.isEmpty) {
      setState(() {
        mobileError = 'Mobile Number is required';
      });
      isValid = false;
    }

    return isValid;
  }
}
