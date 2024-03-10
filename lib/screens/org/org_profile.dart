import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/org/edit_profile.dart';
import 'package:search_me/screens/org/subscription_details.dart';
import 'package:search_me/screens/user/home_screen.dart';

class OrgProfile extends StatelessWidget {
  const OrgProfile({super.key});

  Future<Map<String, dynamic>> fetchData(String userId) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('approved_regs').doc(userId);

    DocumentSnapshot documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      final imageUrl = data['image_url'];
      return {
        'org_name': data['org_name'],
        'image_url': imageUrl,
        'location': data['location'],
        'category': data['category'],
        'license_number': data['license_number'],
        'website_url': data['website_url'],
        'description': data['description'],
        'contact_no': data['contact_no'],
        'email': data['email'],
      };
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FutureBuilder(
        future: fetchData(user.uid),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> data = snapshot.data ?? {};
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Profile'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: TextButton.icon(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      style: ButtonStyle(
                        padding: const MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 0, horizontal: 8.0)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: br8)),
                        backgroundColor: const MaterialStatePropertyAll(redClr),
                        foregroundColor:
                            const MaterialStatePropertyAll(whiteClr),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                    ),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(data['image_url'] ?? ''),
                        ),
                        w20,
                        ElevatedButton(
                            style: ButtonStyle(
                                minimumSize: const MaterialStatePropertyAll(
                                    Size(100, 30)),
                                backgroundColor:
                                    const MaterialStatePropertyAll(blueClr),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: br8))),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfile(profileData: data),
                                ),
                              );
                            },
                            child: const Text(
                              'Edit profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: whiteClr,
                              ),
                            )),
                      ],
                    ),
                    h10,
                    const Divider(),
                    h10,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Name: ${data['org_name']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'Location: ${data['location']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'Category: ${data['category']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'License Number: ${data['license_number']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'Website: ${data['website_url']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'Contact: ${data['contact_no']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        h20,
                        Text(
                          'Email: ${data['email']}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    h10,
                    const Divider(),
                    h10,
                    ElevatedButton(
                        style: ButtonStyle(
                            fixedSize:
                                const MaterialStatePropertyAll(Size(170, 40)),
                            backgroundColor:
                                const MaterialStatePropertyAll(indigoClr),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: br8))),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SubscriptionDetails()),
                          );
                        },
                        child: const Text(
                          'My Subscription',
                          style: TextStyle(
                            color: whiteClr,
                          ),
                        ))
                  ],
                ),
              ),
            );
          }
        },
      );
    } else {
      return const Scaffold(
        body: Center(
            child: Text(
          'User not found',
          style: TextStyle(color: redClr),
        )),
      );
    }
  }
}
