import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/admin/list_item_details.dart';

class AdminRegistration extends StatelessWidget {
  const AdminRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            bottom: TabBar(
              tabAlignment: TabAlignment.fill,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: blackClr,
              isScrollable: false,
              indicatorPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
              unselectedLabelColor: blackClr,
              indicator: BoxDecoration(
                color: blackClr,
                borderRadius: br30,
              ),
              labelStyle: TextStyle(
                color: whiteClr,
                fontSize: 16,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
              tabs: const [
                Tab(
                  text: "Approved",
                ),
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Rejected",
                ),
              ],
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
          child: TabBarView(
            children: [
              ApprovedList(),
              PendingList(),
              RejectedList(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> fetchData(String collectionName) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection(collectionName).get();
  return querySnapshot.docs.map((doc) {
    final data = doc.data();
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
      'password': data['password'],
    };
  }).toList();
}

class ApprovedList extends StatelessWidget {
  const ApprovedList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData('approved_regs'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final imageUrl = data[index]['image_url'];
                final orgName = data[index]['org_name'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: br8,
                      color: blackClr,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Center(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: br8,
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            orgName,
                            style: const TextStyle(
                              color: whiteClr,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}

class PendingList extends StatelessWidget {
  const PendingList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData('reg_requests'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final orgName = data[index]['org_name'];
                final imageUrl = data[index]['image_url'];
                final allData = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: br8,
                      color: blackClr,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Center(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: br8,
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            orgName,
                            style: const TextStyle(
                              color: whiteClr,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ListItemDetails(data: allData),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}

class RejectedList extends StatelessWidget {
  const RejectedList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchData('rejected_regs'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final orgName = data[index]['org_name'];
                final imageUrl = data[index]['image_url'];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: br8,
                      color: blackClr,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: Center(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: br8,
                            child: Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            orgName,
                            style: const TextStyle(
                              color: whiteClr,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
