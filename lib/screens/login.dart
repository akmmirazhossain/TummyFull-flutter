import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerificationForm extends StatefulWidget {
  @override
  _PhoneVerificationFormState createState() => _PhoneVerificationFormState();
}

class _PhoneVerificationFormState extends State<PhoneVerificationForm> {
  late TextEditingController _otpController;
  late FocusNode _otpFocusNode; // FocusNode for OTP input field

  bool _showOTPField = false;
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isButtonDisabled = false;
  bool _showResendLines = false;
  int _resendTimer = 10;
  late Timer _timer;

  bool _validateOTP() {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter OTP'),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpFocusNode = FocusNode(); // Initialize FocusNode
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_showOTPField) // Show only if OTP field is not shown
                  Column(
                    children: [
                      TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'^01[0-9]{9}$');
                          if (!regex.hasMatch(value!)) {
                            return 'Enter a valid 11-digit phone number starting with 01';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            _isButtonDisabled ? null : _verifyPhoneNumber,
                        child: Text('Send OTP'),
                      ),
                      Divider(), // HR
                      SizedBox(height: 10),
                    ],
                  ),
                if (_showOTPField) // Show OTP field only when _showOTPField is true
                  Column(
                    children: [
                      TextFormField(
                        controller: _otpController,
                        focusNode: _otpFocusNode, // Assign the FocusNode
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          // Add validation logic if needed
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _isButtonDisabled ? null : _verifyOTP,
                        child: Text('Verify'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verifyPhoneNumber() async {
    if (_validatePhoneNumber()) {
      final String phoneNumber = _phoneNumberController.text;
      final String apiUrl = 'http://192.168.0.216:8000/api/send-otp';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'phoneNumber': phoneNumber},
      );

      if (response.statusCode == 200) {
        // Successfully sent the phone number for verification
        print('Phone number verification successful');

        // Set _showOTPField to true after successfully sending OTP
        setState(() {
          _showOTPField = true;
        });

        // Set _showResendLines to true after successfully sending OTP
        setState(() {
          _showResendLines = true;
        });

        // Schedule a callback to hide the lines after _resendTimer seconds
        Future.delayed(Duration(seconds: _resendTimer), () {
          setState(() {
            _showResendLines = false;
          });
        });
      } else {
        // Handle error response
        print('Error: ${response.statusCode}');
        print('Error message: ${response.body}');
      }

      _isButtonDisabled = true;
      _startResendTimer();
    }
  }

  void _resendOtp() async {
    final String phoneNumber = _phoneNumberController.text;
    final String apiUrl =
        'http://192.168.0.216:8000/api/send-otp'; // Replace with your actual API URL

    print('Resending OTP...');

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'phoneNumber': phoneNumber},
    );

    if (response.statusCode == 200) {
      print('OTP resent successfully');
    } else {
      print('Error: ${response.statusCode}');
      print('Error message: ${response.body}');
    }

    _isButtonDisabled = true;
    _startResendTimer();
  }

  bool _validatePhoneNumber() {
    RegExp regex = RegExp(r'^01[0-9]{9}$');
    if (!regex.hasMatch(_phoneNumberController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a valid 11-digit phone number starting with 01',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _isButtonDisabled = false;
          timer.cancel();
        }
      });
    });
  }

  bool _isVerifyButtonDisabled = true; // Add this line

  // ... Other existing code ...

  void _verifyOTP() async {
    if (_validateOTP()) {
      final String otp = _otpController.text;
      final String phoneNumber = _phoneNumberController.text;
      final String apiUrl = 'http://192.168.0.216:8000/api/verify-otp';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'phoneNumber': phoneNumber, 'otp': otp},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = jsonDecode(response.body);

        // Extract data from the JSON response
        final status = jsonResponse['status'];
        final message = jsonResponse['message'];

        // Print the response data
        print('Status: $status');
        print('Message: $message');

        if (status == 'success') {
          // Set shared preference to indicate user is logged in
          await _setLoggedIn(true);
          print('User logged in successfully');

          // Redirect to the HomeScreen
          Navigator.of(context).pushReplacementNamed('/screens/home');
        } else {
          print('Failed to log in');
          // Handle failed login (e.g., display error message)
        }
      } else {
        // Handle HTTP error response
        print('HTTP error: ${response.statusCode}');
      }
    }
  }

  Future<void> _setLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
}

void main() {
  runApp(MaterialApp(
    home: PhoneVerificationForm(),
  ));
}
