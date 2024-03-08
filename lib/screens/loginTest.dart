import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added import for FilteringTextInputFormatter
import '../services/login/login_services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Verification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OtpVerificationScreen(),
    );
  }
}

class OtpVerificationScreen extends StatefulWidget {
  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  bool _showStep1 = true;
  String _errorMessage = '';
  FocusNode _otpFocusNode = FocusNode();
  OTPServices _otpServices = OTPServices(); // Create an instance of OTPServices

  @override
  void dispose() {
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showStep1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Added input formatter
                    decoration: InputDecoration(
                      hintText: 'Enter 11 digit phone number',
                      errorText:
                          _errorMessage.isNotEmpty ? _errorMessage : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _otpServices.sendOTP(
                        _phoneNumberController,
                        _showStep1,
                        (value) => setState(() => _showStep1 = value),
                        (value) => setState(() => _errorMessage = value),
                        context,
                        _otpFocusNode,
                      );
                    },
                    child: Text('Send OTP'),
                  ),
                ],
              ),
            if (!_showStep1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    focusNode: _otpFocusNode, // Assign focusNode
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Added input formatter
                    decoration: InputDecoration(
                      hintText: 'Enter 4 digit OTP',
                      errorText:
                          _errorMessage.isNotEmpty ? _errorMessage : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _otpServices.verifyOTP(
                        _otpController,
                        (value) => setState(() => _errorMessage = value),
                      );
                    },
                    child: Text('Verify'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
