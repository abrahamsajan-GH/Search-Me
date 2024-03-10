import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/org/payment.dart';

class OrgSubscriptions extends StatefulWidget {
  const OrgSubscriptions({super.key});

  @override
  OrgSubscriptionsState createState() => OrgSubscriptionsState();
}

class OrgSubscriptionsState extends State<OrgSubscriptions> {
  int _current = 0;
  dynamic _selectedIndex = {};

  final CarouselController _carouselController = CarouselController();

  final List<Map<String, dynamic>> _products = [
    {
      'plan': 'SILVER',
      'image': 'assets/constellation.svg',
      'description': [
        '84 Days Validity',
        'Longer posts',
        'Undo post',
        'Post longer videos',
        'No ads in for you',
        'Media studio',
        'Analytics',
        'ID verification',
      ],
      'price': '99',
      'color': whiteClr,
    },
    {
      'plan': 'GOLD',
      'image': 'assets/constellation.svg',
      'description': [
        '168 Days Validity',
        'Longer posts',
        'Undo post',
        'Post longer videos',
        'No ads in for you',
        'Media studio',
        'Analytics',
        'ID verification',
      ],
      'price': '199',
      'color': yellowClr,
    },
    {
      'plan': 'PLATINUM',
      'image': 'assets/constellation.svg',
      'description': [
        '336 Days Validity',
        'Longer posts',
        'Undo post',
        'Post longer videos',
        'No ads in for you',
        'Media studio',
        'Analytics',
        'ID verification',
      ],
      'price': '399',
      'color': tealAccentClr,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex != null && _selectedIndex.length > 0
          ? FloatingActionButton(
              onPressed: () {},
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPortal(
                          plan: _products[_current]['plan'],
                          price: _products[_current]['price'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send)))
          : null,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 20)),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Container(
                  color: bGreyClr,
                  height: 60,
                  width: 200,
                  child: Center(
                    child: Text(
                      _products[_current]['plan'],
                      style: TextStyle(
                          color: _products[_current]['color'],
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
                  ),
                ),
              ),
              h20,
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: 450.0,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.70,
                  enlargeCenterPage: true,
                  pageSnapping: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: _products.map((product) {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedIndex == product) {
                              _selectedIndex = {};
                            } else {
                              _selectedIndex = product;
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: whiteClr,
                            borderRadius: br20,
                            border: _selectedIndex == product
                                ? Border.all(color: blueClr.shade500, width: 1)
                                : null,
                            boxShadow: _selectedIndex == product
                                ? [
                                    BoxShadow(
                                        color: blueClr.shade100,
                                        blurRadius: 30,
                                        offset: const Offset(0, 10))
                                  ]
                                : [
                                    BoxShadow(
                                        color: greyClr.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 5))
                                  ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 450,
                                  child: ClipRRect(
                                    borderRadius: br20,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        SvgPicture.asset(
                                          product['image'],
                                          fit: BoxFit.cover,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      product['description']
                                                          .length;
                                                  i++)
                                                Column(
                                                  children: [
                                                    if (i > 0) h10,
                                                    Text(
                                                      '• ${product['description'][i]}',
                                                      style: const TextStyle(
                                                        color: whiteClr,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              h30,
              ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: greyClr, width: 2),
                    borderRadius: br30,
                  ),
                  height: 60,
                  width: 200,
                  child: Center(
                    child: Text(
                      'Get for ₹${_products[_current]['price']}',
                      style: const TextStyle(
                        color: blackClr,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
