import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';

class SearchResultsWidget extends StatefulWidget {
  const SearchResultsWidget(
      {super.key, required this.searchQuery, required this.location});
  final String searchQuery;
  final String location;

  @override
  State<SearchResultsWidget> createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {
  Future<List<Map<String, dynamic>>> searchFirestore() async {
    
    Query query = FirebaseFirestore.instance
        .collection('approved_regs')
        .orderBy('org_name');

    if (widget.location.isNotEmpty) {
      query = query.where('location', isEqualTo: widget.location);
    }

    QuerySnapshot querySnapshot = await query.get();

    List<Map<String, dynamic>> data = [];
    for (var doc in querySnapshot.docs) {
      String orgName = doc['org_name'].toLowerCase();
      String category = doc['category'].toLowerCase();
      String searchQuery = widget.searchQuery.toLowerCase();
      if ((orgName.startsWith(searchQuery) ||
          category.startsWith(searchQuery))) {
        data.add({
          'image_url': doc['image_url'],
          'org_name': doc['org_name'],
          'location': doc['location'],
          'category': doc['category'],
          'website_url': doc['website_url'],
          'email': doc['email'],
        });
      }
    }

    return data;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: searchFirestore(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Results Found'),
                  const Divider(
                    thickness: 1.5,
                    color: blackClr,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      var item = snapshot.data?[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: blackClr, borderRadius: br6),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: br6,
                                  child: Image.network(item?['image_url'] ?? '',
                                      height: 60, width: 80, fit: BoxFit.cover),
                                ),
                                title: Text(
                                  item?['org_name'] ?? '',
                                  style: const TextStyle(color: whiteClr),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  item?['location'] ?? '',
                                  style: const TextStyle(color: greyClr),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: whiteClr.withOpacity(0.8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
