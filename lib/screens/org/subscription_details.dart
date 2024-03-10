import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/org/org_subs.dart';

class SubscriptionDetails extends StatelessWidget {
  const SubscriptionDetails({super.key});

  Future<Map<String, dynamic>> fetchData(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('payments')
        .where('User Id', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final data = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return {
        'plan_name': data['Chosen Plan'],
        'amount_paid': data['Amount Paid'],
        'payment_date': _formatDate(data['Date'] as Timestamp),
        'expiry_date': _formatDate(data['Expiry Date'] as Timestamp),
      };
    }

    return {};
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> data = snapshot.data ?? {};
            if (data.isEmpty) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 120,
                        padding: const EdgeInsets.all(12.0),
                        decoration:
                            BoxDecoration(color: greyClr, borderRadius: br6),
                        child: const Center(
                            child: Text(
                          textAlign: TextAlign.center,
                          "SORRY!\nYou haven't made any subscriptions yet🙁\nPlease navigate to the subscriptions tab for choosing a subscription plan.",
                          style: TextStyle(
                            color: whiteClr,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ))),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(blueClr),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: br6))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OrgSubscriptions()));
                      },
                      child: const Text(
                        'Choose Subscription',
                        style: TextStyle(
                            color: whiteClr, fontWeight: FontWeight.bold),
                      ))
                ],
              );
            }

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Center(
                    child: Text(
                      'Your Subscription Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2.5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 10.0),
                    width: 300,
                    decoration:
                        BoxDecoration(color: yellowClr, borderRadius: br8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Subscribed Plan is #${data['plan_name']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: purpleClr),
                        ),
                        h10,
                        Text(
                          'Amount Paid was ₹${data['amount_paid']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: redClr),
                        ),
                        h20,
                        Text(
                          'Payment made on ${data['payment_date']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'Plan expires on ${data['expiry_date']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        h30,
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: blueClr, borderRadius: br6),
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Thank you for being our ${data['plan_name']} member.',
                    style: const TextStyle(color: whiteClr, fontSize: 14),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
