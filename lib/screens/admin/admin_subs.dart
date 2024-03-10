import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:search_me/constants/constants.dart';

class AdminSubscriptions extends StatelessWidget {
  const AdminSubscriptions({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              unselectedLabelColor: blackClr,
              indicator: BoxDecoration(color: blackClr, borderRadius: br30),
              labelStyle: TextStyle(
                color: whiteClr,
                fontSize: 16,
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
              tabs: const [
                Tab(
                  text: "Subscribed",
                ),
                Tab(
                  text: "Expired",
                ),
              ],
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
          child: TabBarView(
            children: [
              SubscriptionList(isSubscribed: true),
              SubscriptionList(isSubscribed: false),
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionList extends StatelessWidget {
  final bool isSubscribed;

  const SubscriptionList({super.key, required this.isSubscribed});

  @override
  Widget build(BuildContext context) {
    Query query = FirebaseFirestore.instance.collection('payments');
    if (isSubscribed) {
      query = query.where('Expiry Date', isGreaterThan: DateTime.now());
    } else {
      query = query.where('Expiry Date', isLessThan: DateTime.now());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            var data =
                snapshot.data?.docs[index].data() as Map<String, dynamic>;

            DateTime expiryDate = (data['Expiry Date'] as Timestamp).toDate();

            String formattedExpiryDate = DateFormat.yMMMd().format(expiryDate);

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              child: Container(
                decoration: BoxDecoration(color: blackClr, borderRadius: br6),
                child: ListTile(
                  title: Text(
                    data['Org Name'],
                    style: const TextStyle(color: whiteClr, fontSize: 16),
                  ),
                  subtitle: Text(data['Email'],
                      style: const TextStyle(color: greyClr, fontSize: 12)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(data['Chosen Plan'],
                          style:
                              const TextStyle(color: yellowClr, fontSize: 14)),
                      Text('Till $formattedExpiryDate',
                          style: const TextStyle(color: greyClr, fontSize: 12))
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
