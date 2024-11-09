import 'package:flutter/material.dart';

class VnPayScreen extends StatefulWidget {
  final String paymentUrl;
  final Function(Map<String, dynamic>)? onPaymentSuccess;
  final Function(Map<String, dynamic>)? onPaymentError;
  final Function()? onWebPaymentComplete;

  const VnPayScreen({super.key, 
    required this.paymentUrl,
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onWebPaymentComplete,
  });

  @override
  _VnPayScreenState createState() => _VnPayScreenState();
}

class _VnPayScreenState extends State<VnPayScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VnPay'),
      ),
      body: Center(
        
      )
    );
  }
}
