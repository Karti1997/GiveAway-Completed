import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BestDonationWidget extends StatefulWidget {
  @override
  _BestDonationWidgetState createState() => _BestDonationWidgetState();
}

class _BestDonationWidgetState extends State<BestDonationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          BestDonationTitle(),
          Expanded(
            child: BestDonationList(),
          )
        ],
      ),
    );
  }
}

class BestDonationTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Your GiveAways",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BestDonationTiles extends StatelessWidget {
  String name;
  String imageUrl;
  double rating;
  String numberOfRating;
  String price;
  String slug;

  String Alertmsg1 = "Lets Wait for Some time";
  BestDonationTiles(
      {Key key,
      @required this.name,
      @required this.imageUrl,
      @required this.rating,
      @required this.numberOfRating,
      @required this.price,
      @required this.slug})
      : super(key: key);
  Future<void> _showMyDialog(BuildContext context, String docid, String text1,
      String text2, String text3) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text1),
                Text(text2),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: text3 != "Repost"
                  ? RaisedButton(
                      color: Colors.green,
                      child: Text(text3),
                      onPressed: () {
                        DocumentReference ds = FirebaseFirestore.instance
                            .collection('Donation')
                            .doc(docid);
                        ds.update({"Status": "Accepted"});
                        Navigator.of(context).pop();
                      },
                    )
                  : Center(
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                              color: Colors.green,
                              child: Text("Repost"),
                              onPressed: () {
                                DocumentReference ds = FirebaseFirestore
                                    .instance
                                    .collection('Donation')
                                    .doc(docid);
                                ds.update({"Status": "Posted"});
                                Navigator.of(context).pop();
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          RaisedButton(
                              color: Colors.green,
                              child: Text("Delivered"),
                              onPressed: () {
                                DocumentReference ds = FirebaseFirestore
                                    .instance
                                    .collection('Donation')
                                    .doc(docid);
                                ds.update({"Status": "Delivered"});
                                Navigator.of(context).pop();
                              })
                        ],
                      ),
                    ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: 210.0,
                child: Row(children: [
                  Container(
                      height: 75.0,
                      width: 75.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color(0xFFFFE3DF)),
                      child: Center(
                          child: Image.asset(imageUrl,
                              height: 50.0, width: 50.0))),
                  SizedBox(width: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,
                          style: GoogleFonts.notoSans(
                              fontSize: 14.0, fontWeight: FontWeight.w400)),
                      Row(
                        children: <Widget>[
                          Text(
                            'Status',
                            style: GoogleFonts.lato(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                textStyle: TextStyle(color: Color(0xFFF68D7F))),
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            price,
                            style: GoogleFonts.lato(
                                fontSize: 14.0,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                textStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.4))),
                          )
                        ],
                      )
                    ],
                  )
                ])),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                print(numberOfRating);
                if (price == "Posted") {
                  _showMyDialog(
                      context,
                      numberOfRating,
                      "Your Donation Has not been Requested Yet!!",
                      'Lets Wait for Some Time',
                      'Ok');
                } else if (price == "Requested") {
                  _showMyDialog(
                      context,
                      numberOfRating,
                      'Your Donation Has been Requested!!',
                      'Would you like to approve this Request?',
                      'Accept');
                } else {
                  _showMyDialog(context, numberOfRating,
                      'GiveAway Delivered Successfully??', '', 'Repost');
                }
              },
              child:
                  Center(child: Icon(Icons.track_changes, color: Colors.white)),
              backgroundColor: Color(0xFFFE7D6A),
            )
          ],
        ));
    /*return InkWell(
      onTap: () {},
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
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                'assets/images/bestfood/' + imageUrl + ".jpeg",
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 1,
              margin: EdgeInsets.all(5),
            ),
          ),
        ],
      ),
    );*/
  }
}

class BestDonationList extends StatefulWidget {
  @override
  _BestDonationListState createState() => _BestDonationListState();
}

class _BestDonationListState extends State<BestDonationList> {
  List<BestDonationTiles> Items = [];
  Readrequests() {
    String id = FirebaseAuth.instance.currentUser.uid;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(id);
    docRef.get().then((doc) {
      if (doc.exists) {
        var elt = doc.data();
        elt['DonationCart'].forEach((elt) {
          print(elt);
          DocumentReference ds =
              FirebaseFirestore.instance.collection('Donation').doc(elt);
          ds.get().then((value) {
            String donationid = value.id;
            var elt = value.data();
            print(elt['Itemname']);
            setState(() {
              if (elt['Status'] != 'Delivered') {
                Items.add(BestDonationTiles(
                    name: elt['Itemname'],
                    imageUrl: "assets/images/topmenu/ic_elec.png",
                    rating: 4.9,
                    numberOfRating: donationid,
                    price: elt['Status'],
                    slug: ""));
              }
            });
          }).catchError((err) => {print("error")});
        });
      } else {
        // doc.data() will be undefined in this case
        print("No such document!");
      }
    }).catchError((error) {
      print("Error");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Readrequests();
    setState(() {
      Items.sort((a, b) => b.price.compareTo(a.price));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Items.length,
      itemBuilder: (context, index) => _builder(index),
    );
  }

  _builder(int index) {
    BestDonationTiles _card = Items[index];
    return _card;
  }
}
