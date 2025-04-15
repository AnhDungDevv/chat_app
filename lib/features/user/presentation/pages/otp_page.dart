import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/user/presentation/pages/inital_profile_submit_page.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isMounted = true; // Track if widget is mounted

  void _submitSmsCode() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a valid OTP")));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const InitalProfileSubmitPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter your OTP for the App Verification (so that you will be moved for the further steps to complete)",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        PinCodeTextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          autoDisposeControllers: true,
                          length: 6,
                          appContext: context,
                          onChanged: (value) {},
                          onCompleted: (pinCode) {
                            if (_isMounted) {
                              _submitSmsCode();
                            }
                          },
                          pinTheme: PinTheme(
                            activeColor: tabColor,
                            selectedColor: Colors.blueAccent,
                            inactiveColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitSmsCode,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
