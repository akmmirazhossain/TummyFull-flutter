import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class OTPServices {
  void sendOTP(
    TextEditingController phoneNumberController,
    bool showStep1,
    Function(bool) setShowStep1,
    Function(String) setErrorMessage,
    BuildContext context,
    FocusNode otpFocusNode,
  ) async {
    String phoneNumber = phoneNumberController.text;
    bool isNumeric = int.tryParse(phoneNumber) != null;
    if (isNumeric && phoneNumber.length == 11 && phoneNumber.startsWith('01')) {
      // Proceed to Step 2
      setShowStep1(false);
      setErrorMessage(''); // Clear any previous error message

      // Set focus to OTP input field
      FocusScope.of(context).requestFocus(FocusNode());
      Future.delayed(Duration.zero, () {
        FocusScope.of(context).requestFocus(otpFocusNode);
      });

      // Send OTP request

      try {
        const String apiUrl = 'http://192.168.0.216/tf-lara/public/api/send-otp';
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {'phoneNumber': phoneNumber},
        );

        if (response.statusCode == 200) {
          // OTP sent successfully
          print('OTP sent successfully');
        } else {
          // OTP sending failed
          setErrorMessage('Failed to send OTP');
        }
      } catch (e) {
        print('Error sending OTP: $e');
        setErrorMessage('Failed to send OTP');
      }
    } else {
      setErrorMessage('Invalid phone number format');
    }
  }

  void verifyOTP(
      TextEditingController otpController, Function(String) setErrorMessage) {
    String otp = otpController.text;
    if (otp.length == 4 && int.tryParse(otp) != null) {
      // Proceed with OTP verification logic
      setErrorMessage(''); // Clear any previous error message
    } else {
      setErrorMessage('Invalid OTP format. OTP must be 4 digits');
    }
  }
}
