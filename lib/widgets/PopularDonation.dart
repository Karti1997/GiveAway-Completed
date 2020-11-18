/*
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Animations/ScaleRoute.dart';
import 'DonationDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
 */
/*
class PopularDonationsWidget extends StatelessWidget {
  String searchCategory;
  PopularDonationsWidget({
    Key key,
    @required this.searchCategory,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 265,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          PopularDonationTitle(),
          Expanded(
            child: PopularDonationItems(category: searchCategory),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class PopularDonationTiles extends StatelessWidget {
  String Id;
  String name;
  String imageUrl;
  String rating;
  String numberOfRating;
  String quantity;
  String productDescription;
  String productLocation;
  String productContact;

  PopularDonationTiles(
      {Key key,
      @required this.Id,
      @required this.name,
      @required this.imageUrl,
      @required this.rating,
      @required this.numberOfRating,
      @required this.quantity,
      @required this.productDescription,
      @required this.productLocation,
      @required this.productContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            ScaleRoute(
                page: DonationDetailsPage(
                    productId: Id,
                    productContact: productContact,
                    productDescription: productDescription,
                    productLocation: productLocation,
                    distance: numberOfRating,
                    imageUrl: imageUrl,
                    productName: name,
                    productQuantity: quantity,
                    productHost: "")));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(boxShadow: [
              /* BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),*/
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: 170,
                  height: 210,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white70,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFfae3e2),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Image.asset(
                              'assets/images/popular_foods/' +
                                  imageUrl +
                                  ".png",
                              width: 130,
                              height: 140,
                            )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(name,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFfae3e2),
                                      blurRadius: 25.0,
                                      offset: Offset(0.0, 0.75),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text(rating,
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text("($numberOfRating)",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5, right: 5),
                            child: Text(quantity,
                                style: TextStyle(
                                    color: Colors.lightGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

//heading
class PopularDonationTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "GiveAways Near you!",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
          Text(
            "See all",
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w100),
          )
        ],
      ),
    );
  }
}

class PopularDonationItems extends StatefulWidget {
  final String category;

  const PopularDonationItems({Key key, this.category}) : super(key: key);
  @override
  _PopularDonationItemsState createState() => _PopularDonationItemsState();
}

class _PopularDonationItemsState extends State<PopularDonationItems> {
  String Cur_User_ID = FirebaseAuth.instance.currentUser.uid;
  List<PopularDonationTiles> _Itemdetails = [];
  double lati = 0.0, longi = 0.0;
  String foo;
  _PopularDonationItemsState({this.foo});
  Future populateitems() async {
    print("*******");
    print(foo);
    await Firebase.initializeApp();
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var s = FirebaseFirestore.instance.collection('Donation').snapshots();
    s.toList();
    setState(() {
      _Itemdetails.clear();
    });
    s.forEach((element) {
      element.docs.forEach((element) {
        String id = element.id;
        var elt = element.data();
        GeoPoint loc = elt['locationpoint'];
        String imageurl = "ic_popular_food_1";
        switch (elt['Itemtype']) {
          case 'Clothes':
            imageurl = "ic_popular_food_3";
            break;
          case 'Education':
            imageurl = "ic_popular_food_4";
            break;
          case 'Medicine':
            imageurl = "ic_popular_food_6";
            break;
          case 'Food':
            imageurl = "ic_popular_food_1";
            break;
          default:
            imageurl = "ic_popular_food_5";
            break;
        }
        double distance;
        Geolocator()
            .distanceBetween(position.latitude, position.longitude,
                loc.latitude, loc.longitude)
            .then((value) => {
                  if ((value / 1000).round() < 25 &&
                      elt['Benefactor'] == null &&
                      elt['Donor'] != Cur_User_ID)
                    {
                      setState(() {
                        _Itemdetails.add(PopularDonationTiles(
                          Id: id,
                          name: elt['Itemname'],
                          imageUrl: imageurl,
                          rating: 'Distance',
                          numberOfRating:
                              (value / 1000).round().toString() + 'Km',
                          quantity: elt['Itemquantity'],
                          productDescription: elt['ItemDescription'],
                          productLocation: elt['Itemloc'],
                          productContact: elt['Itemcontact'],
                        ));
                      })
                    }
                })
            .catchError((onError) => {print("******" + onError.toString())});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    populateitems();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _Itemdetails.length,
      itemBuilder: (context, index) => _builder(index),
    );
  }

  _builder(int index) {
    PopularDonationTiles _card = _Itemdetails[index];
    return _card;
  }
}
*/
