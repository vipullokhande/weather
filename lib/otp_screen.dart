import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:weather/home_screen.dart';
import 'package:weather/providers/auth_provider.dart';
import 'package:weather/utils/utils.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  String verificationId;
  OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    final pinPutController = TextEditingController();
    String? otpcode;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Pinput(
              length: 6,
              controller: pinPutController,
              keyboardType: TextInputType.number,
              onCompleted: (value) {
                setState(() {
                  otpcode = value;
                });
              },
            ),
            TextButton(
              onPressed: () {
                if (otpcode != null) {
                  verifyOtp(context, otpcode!);
                } else {
                  showSnackBar(context, 'Enter 6-digit code');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void verifyOtp(BuildContext context, String userotp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userotp,
      onSuccess: () {
        ap.checkExistingUser().then(
          (value) {
            if (value == true) {
              ap.getDataFromFirestore().then(
                    (value) => ap.saveDataToSP().then(
                          (value) => ap.setSignIn().then(
                                (value) =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false,
                                ),
                              ),
                        ),
                  );
            }
          },
        );
      },
    );
  }
}
