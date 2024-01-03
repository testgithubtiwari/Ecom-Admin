// ignore_for_file: prefer_const_constructors

import 'package:admin/auth/otp_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneAdd extends StatefulWidget {
  const PhoneAdd({super.key});

  static String verify = "";

  @override
  State<PhoneAdd> createState() => _PhoneAddState();
}

class _PhoneAddState extends State<PhoneAdd> {
  final TextEditingController _phoneNumberController = TextEditingController();
  // TextEditingController _countryCodeController = TextEditingController();
  String _selectedCountryCode = '+1';

  List<String> countryCodes = [
    '+1',
    '+44',
    '+81',
    '+86',
    '+91',
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Phone Add',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.width * 0.10,
              ),
              Container(
                height: size.width * 0.60,
                width: size.width * 0.60,
                padding: EdgeInsets.all(size.width * 0.02),
                child: Image.asset(
                  'assets/images/img1.png',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Text(
                'Phone Verification',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Text(
                'We need to register your phone before getting started!',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(141, 0, 0, 0),
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.03),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: _selectedCountryCode,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCountryCode = value!;
                          });
                        },
                        items: countryCodes.map((String code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.width * 0.02),
              SizedBox(
                height: size.width * 0.10,
                width: size.width * 0.90,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber:
                          _selectedCountryCode + _phoneNumberController.text,
                      verificationCompleted:
                          (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        PhoneAdd.verify = verificationId;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OtpVerification()));
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    );
                    // ignore: use_build_context_synchronously
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const OtpVerification()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        117, 31, 173, 18), // Set the background color
                  ),
                  child: Text(
                    'Get OTP',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
