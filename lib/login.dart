import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie/home.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController MobileNumber = TextEditingController();
  TextEditingController OTP = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController otp = TextEditingController();
  String otpPin = "";
  String countryDial = "+91";
  String verID = " ";
  int screenState = 0;
  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!");
        verID = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!");
      },
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> verifyOTP() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      );
      auth.signInWithCredential(credential).then((result) {
        if (result.user != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        }
      }).catchError((e) {
        print(e);
        showSnackBarText("Incorrect OTP!, Try Again");
      });
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
          image: AssetImage('images/login.jpg'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ))),
        Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 90),
            child: Container(
              width: double.infinity,
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome User",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 184, 42, 32)),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: IntlPhoneField(
                        controller: phoneController,
                        showCountryFlag: true,
                        flagsButtonPadding: EdgeInsets.only(left: 20),
                        showDropdownIcon: false,
                        disableLengthCheck: false,
                        initialValue: countryDial,
                        onCountryChanged: (country) {
                          setState(() {
                            countryDial = "+" + country.dialCode;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: OTP,
                        onChanged: (value) {
                          setState(() {
                            otpPin = value;
                          });
                        },
                        decoration: InputDecoration(
                          counterText: "",
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5)),
                          labelText: 'OTP',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (phoneController.text != "") {
                            verifyPhone(countryDial + phoneController.text);
                          } else {
                            Fluttertoast.showToast(msg: 'Enter Mobile Number');
                          }
                        });
                      },
                      child: const Text(
                        'Send OTP',
                      ),
                    )),
                    Container(
                        child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (OTP.text.length >= 6) {
                            verifyOTP();
                          } else {
                            Fluttertoast.showToast(msg: 'Enter OTP');
                          }
                        });
                      },
                      child: const Text(
                        'Login',
                      ),
                    )),
                  ]),
            ))
      ]),
    ));
  }
}
