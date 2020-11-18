import 'package:flutter/material.dart';
import 'Donation_form.dart';
import 'Userprofile.dart';
import 'donation_list.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Donar extends StatefulWidget {
  @override
  _DonarState createState() => _DonarState();
}

class _DonarState extends State<Donar> {
  int pageIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  //final DonationList _homePage = new DonationList();
  final HomePage _homePage = new HomePage();
  final Donationform _donationPage = new Donationform();
  final Profile _profilePage = new Profile();

  //Widget _showPage = new DonationList();

  Widget _showPage = new HomePage();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _homePage;
        break;
      case 1:
        return _donationPage;
        break;
      case 2:
        return _profilePage;
        break;
      default:
        return new Container(
          child: new Center(
            child: new Text(
              'No Page found',
              style: new TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.add, size: 25),
            Icon(Icons.perm_identity, size: 20),
          ],
          color: Colors.green,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (int tappedindex) {
            setState(() {
              _showPage = _pageChooser(tappedindex);
            });
          },
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}
