// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPortal extends StatefulWidget {
  final String plan;
  final String price;

  const PaymentPortal({super.key, required this.plan, required this.price});

  @override
  State<PaymentPortal> createState() => _PaymentPortalState();
}

class _PaymentPortalState extends State<PaymentPortal> {
  final _razorpay = Razorpay();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _paymentInProgress = false;

  _PaymentPortalState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    setState(() {
      _paymentInProgress = true;
    });

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userSnapshot =
        await _firestore.collection('approved_regs').doc(userId).get();
    String userName = (userSnapshot.data()
            as Map<String, dynamic>?)?['org_name'] as String? ??
        '';
    String userEmail = FirebaseAuth.instance.currentUser!.email ?? '';
    String plan = widget.plan;
    String amount = widget.price;
    DateTime dateTime = DateTime.now();

    DateTime expiryDate;
    switch (plan) {
      case 'SILVER':
        expiryDate = dateTime.add(const Duration(days: 84));
        break;
      case 'GOLD':
        expiryDate = dateTime.add(const Duration(days: 168));
        break;
      case 'PLATINUM':
        expiryDate = dateTime.add(const Duration(days: 336));
        break;
      default:
        expiryDate = dateTime;
        break;
    }

    _firestore.collection('payments').add({
      'User Id': userId,
      'Org Name': userName,
      'Email': userEmail,
      'Chosen Plan': plan,
      'Amount Paid': amount,
      'Date': Timestamp.fromDate(dateTime),
      'Expiry Date': Timestamp.fromDate(expiryDate),
    });

    setState(() {
      _paymentInProgress = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Payment successful. Thank you for subscribing.')),
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment failed! Please try again.')),
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('External wallet error! Please try again later.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    var options = {
      'key': 'rzp_test_VNxey0VvhghynT',
      'amount': int.parse(widget.price) * 100,
      'name': 'Search Me',
      'description': '${widget.plan} Payment',
      'timeout': 120,
      'prefill': {'contact': '9446518037'}
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan Name: ${widget.plan}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Plan Price: ₹${widget.price}',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a suitable payment method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Column(
                    children: [
                      if (_paymentInProgress)
                        const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        )
                      else
                        ListTile(
                          onTap: () {
                            _razorpay.open(options);
                          },
                          leading: Image.asset(
                            'assets/qr.png',
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          title: const Text(
                            'Scan QR Code',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () {
                          _razorpay.open(options);
                        },
                        leading: Image.asset(
                          'assets/google-pay.png',
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: const Text(
                          'Google Pay',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () {
                          _razorpay.open(options);
                        },
                        leading: Image.asset(
                          'assets/credit-card.png',
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: const Text(
                          'Credit Card',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        onTap: () {
                          _razorpay.open(options);
                        },
                        leading: Image.asset(
                          'assets/bank-transfer.png',
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: const Text(
                          'Bank Transfer',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/cod.png',
                          width: 40,
                          fit: BoxFit.cover,
                        ),
                        title: const Text(
                          'Payment in Person',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
