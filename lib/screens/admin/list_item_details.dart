// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';

class ListItemDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  const ListItemDetails({super.key, required this.data});

  Future<void> _approveOrganization(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data['email'],
        password: data['password'],
      );

      Map<String, dynamic> userData = Map.from(data);
      userData.remove('password');

      await FirebaseFirestore.instance
          .collection('approved_regs')
          .doc(userCredential.user?.uid)
          .set(userData);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reg_requests')
          .where('email', isEqualTo: data['email'])
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Organization approved successfully!'),
        backgroundColor: greenClr,
      ));
    } catch (e) {
      log('Error approving organization: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to approve organization. Please try again.'),
        backgroundColor: redClr,
      ));
    }
  }

  Future<void> _rejectOrganization(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('rejected_regs')
          .doc(data['uid'])
          .set(data);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reg_requests')
          .where('email', isEqualTo: data['email'])
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Organization rejected successfully!'),
        backgroundColor: greenClr,
      ));
    } catch (e) {
      log('Error rejecting organization: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to reject organization. Please try again.'),
        backgroundColor: redClr,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Org Details'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data['image_url'],
                    width: size.width * 0.9,
                    height: size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
                h5,
                const Divider(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Org Name: ${data['org_name']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Location: ${data['location']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Category: ${data['category']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'License Number: ${data['license_number']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Website URL: ${data['website_url']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Contact No: ${data['contact_no']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Email ID: ${data['email']}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _approveOrganization(context),
                      style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(greenClr),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(borderRadius: br8))),
                      child: const Text(
                        'Approve',
                        style: TextStyle(color: whiteClr, fontSize: 16),
                      ),
                    ),
                    w20,
                    ElevatedButton(
                        onPressed: () => _rejectOrganization(context),
                        style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(redClr),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: br8))),
                        child: const Text(
                          'Reject',
                          style: TextStyle(color: whiteClr, fontSize: 16),
                        )),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
