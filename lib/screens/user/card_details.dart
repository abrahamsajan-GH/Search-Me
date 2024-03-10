import 'package:flutter/material.dart';
import 'package:search_me/constants/constants.dart';

class CardDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> cardData;

  const CardDetailsScreen({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bGreyClr,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              child: Image.network(
                cardData["image_url"],
                fit: BoxFit.cover,
                width: size.width,
                height: size.height * 0.3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardData["org_name"],
                    style: const TextStyle(
                        color: whiteClr,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    thickness: 1.5,
                    color: whiteClr,
                  ),
                  h20,
                  Visibility(
                    visible: cardData["description"].isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cardData["description"],
                          style: TextStyle(
                            color: blueClr[100],
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        h20,
                      ],
                    ),
                  ),
                  Text(
                    'Category: ${cardData["category"]}',
                    style: TextStyle(
                        color: blueClr[100],
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  h10,
                  Text(
                    'Location: ${cardData["location"]}',
                    style: TextStyle(
                        color: blueClr[100],
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  h20,
                  const Divider(
                    thickness: 1.5,
                    color: whiteClr,
                  ),
                  h20,
                  Visibility(
                    visible: cardData["website_url"].isNotEmpty,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.link,
                              color: whiteClr,
                            ),
                            w5,
                            Text(
                              cardData["website_url"],
                              style: TextStyle(
                                  color: blueClr[100],
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        h10,
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        color: whiteClr,
                      ),
                      w5,
                      Text(
                        cardData["contact_no"],
                        style: TextStyle(
                            color: blueClr[100],
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  h10,
                  Row(
                    children: [
                      const Icon(
                        Icons.mail,
                        color: whiteClr,
                      ),
                      w5,
                      Text(
                        cardData["email"],
                        style: TextStyle(
                            color: blueClr[100],
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
