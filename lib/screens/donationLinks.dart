import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationLinks extends StatefulWidget {
  const DonationLinks({Key key}) : super(key: key);

  @override
  _DonationLinksState createState() => _DonationLinksState();
}

void _launchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class _DonationLinksState extends State<DonationLinks> {
  final List<Map<String, Object>> urls = [
    {
      "url": "https://www.feedingindia.org/donate/feedingindia",
      "name": "Feeding India"
    },
    {
      "url": "https://www.riseagainsthungerindia.org/donation/",
      "name": "Rise Against Hunger India"
    },
    {
      "url":
          "https://www.akshayapatra.org/active-fundraising-campaigns/poor-people-s-food",
      "name": "Akshaya Patra"
    },
    {
      "url": "https://www.foodforthepoor.org/help-now/",
      "name": "Food for the Poor"
    },
    {"url": "https://chennaifoodbank.com/", "name": "Chennai Food Bank"},
    {
      "url": "http://www.donateinkind.in/donation-of-regular-food-meals",
      "name": "Donate in Kind"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Donation Links',
            style: GoogleFonts.oswald(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: urls.length,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    urls[index]["name"],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    _launchURL(urls[index]["url"]);
                  },
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        ));
  }
}
