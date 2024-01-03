// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:admin/auth/phone_add.dart';
import 'package:admin/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  const OtpVerification({required this.verificationId, super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  @override
  Widget build(BuildContext context) {
    var code = "";
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Size size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(8, 8, 8, 0.315)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          // title: Text(
          //   'OTP Verification',
          //   style: GoogleFonts.poppins(
          //     color: Colors.white,
          //     fontSize: size.width * 0.05,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // centerTitle: true,
          // backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          )),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.width * 0.30,
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
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
              ),
              SizedBox(
                height: size.width * 0.02,
              ),
              SizedBox(height: size.width * 0.02),
              SizedBox(
                height: size.width * 0.15,
                width: size.width * 0.90,
                child: ElevatedButton(
                  onPressed: () async {
                    print(code);
                    print(widget.verificationId);
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: code,
                      );
                      await auth.signInWithCredential(credential);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login Successful'),
                          backgroundColor: Color.fromARGB(255, 14, 109, 18),
                        ),
                      );
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()));
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Wrong OTP'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        117, 31, 173, 18), // // Set the background color
                  ),
                  child: Text(
                    'Verify Phone Number',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(size.width * 0.02),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const PhoneAdd()));
                  },
                  child: Text(
                    'Edit phone number?',
                    style: GoogleFonts.poppins(
                      color: Color.fromARGB(195, 0, 0, 0),
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w700,
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
