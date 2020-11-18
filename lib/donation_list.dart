import 'package:flutter/material.dart';
import 'widgets/BestDonationWidget.dart';
import 'widgets/SearchWidget.dart';
import 'widgets/DonationDetailsPage.dart';
import 'Animations/ScaleRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String Category = "";
  String Cur_User_ID = FirebaseAuth.instance.currentUser.uid;
  List<PopularDonationTiles> _Itemdetails = [];
  double lati = 0.0, longi = 0.0;
  Future populateitems() async {
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
        if (Category == "" || Category == "Others") {
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
                            productHost: elt['PostedTime'].toString(),
                          ));
                        })
                      }
                  })
              .catchError((onError) => {print("******" + onError.toString())});
        } else if (Category == elt['Itemtype']) {
          double distance;
          Geolocator()
              .distanceBetween(position.latitude, position.longitude,
                  loc.latitude, loc.longitude)
              .then((value) => {
              var cur_time = new DateTime();
              var dDay = new DateTime(elt['PostedTime']);
              Duration difference = cur_time.difference(dDay);
                    if ((value / 1000).round() < 25 &&
                        elt['Benefactor'] == null &&
                        elt['Donor'] != Cur_User_ID)
                      {
                        setState(() {
                          if(elt['Itemtype']=='Foods' && difference.inhours<elt['Expire'])
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
                            productHost: elt['PostedTime'].toString(),
                          ));
                          else if(elt['Itemtype']!='Foods')
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
                              productHost: elt['PostedTime'].toString(),
                            ));
                        })
                      }
                  })
              .catchError((onError) => {print("******" + onError.toString())});
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Category = "";
    populateitems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        //backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          "What you need?",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchWidget(),
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 19.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Category = "Foods";
                          print(Category);
                          populateitems();
                        });
                      },
                      child: TopMenuTiles(
                          name: "Foods", imageUrl: "ic_burger", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Category = "Clothes";
                          print(Category);
                          populateitems();
                        });
                      },
                      child: TopMenuTiles(
                          name: "Clothes", imageUrl: "ic_clothes", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Category = "Education";
                          print(Category);
                          populateitems();
                        });
                      },
                      child: TopMenuTiles(
                          name: "Education", imageUrl: "ic_books", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Category = "Electronics";
                          print(Category);
                          populateitems();
                        });
                      },
                      child: TopMenuTiles(
                          name: "Electronics", imageUrl: "ic_elec", slug: ""),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Category = "Others";
                          print(Category);
                          populateitems();
                        });
                      },
                      child: TopMenuTiles(
                          name: "Others", imageUrl: "ic_others", slug: ""),
                    ),
                  ],
                ),
              ),
            ), //TopMenus
            //PopularDonationsWidget(searchCategory: Category),
            Container(
              height: 265,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  PopularDonationTitle(),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _Itemdetails.length,
                      itemBuilder: (context, index) => _builder(index),
                    ),
                  )
                ],
              ),
            ),
            BestDonationWidget(),
          ],
        ),
      ),
    );
  }

  _builder(int index) {
    PopularDonationTiles _card = _Itemdetails[index];
    return _card;
  }
}

class TopMenuTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String slug;

  TopMenuTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Image.asset(
                    'assets/images/topmenu/' + imageUrl + ".png",
                    width: 24,
                    height: 24,
                  )),
                )),
          ),
          Text(name,
              style: TextStyle(
                  color: Color(0xFF6e6e71),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

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
  String productHost;

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
      @required this.productContact,
      @required this.productHost})
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
                    productHost: productHost)));
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
            "",
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w100),
          )
        ],
      ),
    );
  }
}
