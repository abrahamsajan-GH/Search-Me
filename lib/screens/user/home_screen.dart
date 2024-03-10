import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/user/widgets/cards_widget.dart';
import 'package:search_me/screens/user/widgets/search_results.dart';
import 'package:search_me/screens/user/widgets/searchbox_home.dart';
import 'package:search_me/widgets/ad_plots.dart';

import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  String _location = '';

  void _updateSearchQuery(String query, {bool isLocation = false}) {
    setState(() {
      if (isLocation) {
        _location = query;
      } else {
        _searchQuery = query;
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchData(String category) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('approved_regs')
        .where('category', isEqualTo: category)
        .get();

    List<Map<String, dynamic>> data = [];
    for (var doc in querySnapshot.docs) {
      data.add({
        'image_url': doc['image_url'],
        'org_name': doc['org_name'],
        'location': doc['location'],
        'category': doc['category'],
        'license_number': doc['license_number'],
        'website_url': doc['website_url'],
        'description': doc['description'] ?? '',
        'contact_no': doc['contact_no'],
        'email': doc['email'],
      });
    }

    return data;
  }

  Widget buildCategory(String category) {
    return FutureBuilder(
      future: fetchData(category),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: indigoClr,
                ),
              ),
              CardsWidget(data: snapshot.data ?? []),
              h20,
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteClr,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/contact.png',
              width: 35,
              height: 35,
            ),
            const Column(
              children: [
                Text(
                  'SEARCH ME',
                  style: TextStyle(
                    fontSize: 16,
                    color: indigoClr,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'ONE PLACE FOR ALL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            )
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.notes,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 12.0),
                    child: SearchBoxHome(
                      onChanged: (query, {required isLocation}) =>
                          _updateSearchQuery(query, isLocation: isLocation),
                    ),
                  ),
                  _searchQuery.isEmpty
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildCategory('Restaurants'),
                                  buildCategory('Hospitals'),
                                  buildCategory('Schools'),
                                  const AdPlotMedium(),
                                  buildCategory('Fuel Stations'),
                                  buildCategory('Movie Theatres'),
                                  buildCategory('Museums'),
                                  buildCategory('Football Turfs'),
                                  const AdPlotMedium(),
                                  buildCategory('Workshops'),
                                  buildCategory('Bakery'),
                                  buildCategory('IT & Software'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: greyClr[700],
                                  width: MediaQuery.of(context).size.width * 1,
                                  height: 50,
                                  child: const Center(
                                    child: Text(
                                      'Copyright © 2024 searchme.com | All Rights Reserved',
                                      style: TextStyle(
                                          color: whiteClr, fontSize: 12),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      : SearchResultsWidget(
                          searchQuery: _searchQuery,
                          location: _location.isNotEmpty
                              ? _location.substring(0, 1).toUpperCase() +
                                  _location.substring(1).toLowerCase()
                              : '',
                        ),
                ],
              ),
            ],
          )),
      endDrawer: const AppDrawer(),
    );
  }
}
