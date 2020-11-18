import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/TimelineWidget.dart';
import 'package:intl/intl.dart';
/*class DonationDetailsPage extends StatefulWidget {
  @override
  _DonationDetailsPageState createState() => _DonationDetailsPageState();
}*/

class DonationDetailsPage extends StatelessWidget {
  String productId;
  String distance;
  String imageUrl;
  String productName;
  String productQuantity;
  String productHost;
  String productDescription;
  String productLocation;
  String productContact;

  DonationDetailsPage(
      {Key key,
      @required this.productId,
      @required this.distance,
      @required this.imageUrl,
      @required this.productName,
      @required this.productQuantity,
      @required this.productHost,
      @required this.productDescription,
      @required this.productLocation,
      @required this.productContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          brightness: Brightness.light,
        ),
        body: Container(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.asset(
                  'assets/images/popular_foods/' + "$imageUrl" + ".png",
                  height: 200,
                  width: 200,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                elevation: 1,
                margin: EdgeInsets.all(5),
              ),
              DonationTitleWidget(
                  productName: productName,
                  productQuantity: productQuantity,
                  productHost: productHost),
              SizedBox(
                height: 1,
              ),
              AddToCartMenu(
                productId: productId,
              ),
              SizedBox(
                height: 15,
              ),
              PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: TabBar(
                  labelColor: Color(0xFFfd3f40),
                  indicatorColor: Color(0xFFfd3f40),

                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      text: 'Details',
                    ),
                  ], // list of tabs
                ),
              ),
              Container(
                height: 150,
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.white24,
                      child: DetailContentMenu(
                        productLocation: productLocation,
                        productDescription: productDescription,
                        productContact: productContact,
                      ),
                    ),
                    // class name
                  ],
                ),
              ),
              BottomMenu(
                distance: distance,
                productHost: productHost,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DonationTitleWidget extends StatelessWidget {
  String productName;
  String productQuantity;
  String productHost;

  DonationTitleWidget({
    Key key,
    @required this.productName,
    @required this.productQuantity,
    @required this.productHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              productName,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              productQuantity,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Text(
              "",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFa9a9a9),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1f1f1f),
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}

class BottomMenu extends StatelessWidget {
  String distance;
  String productHost;
  BottomMenu({
    Key key,
    @required this.distance,
    @required this.productHost,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.timelapse,
                color: Color(0xFF404aff),
                size: 35,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                productHost,
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2F4F4F),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions,
                color: Color(0xFF23c58a),
                size: 35,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                distance,
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2F4F4F),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          
        ],
      ),
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  String productId;
  AddToCartMenu({
    Key key,
    @required this.productId,
  }) : super(key: key);
  _additem() async {
    String id = FirebaseAuth.instance.currentUser.uid;
    print(id);
    CollectionReference ds = FirebaseFirestore.instance.collection('Donation');
    ds.doc(productId).update({"Benefactor": id, "Status": "Requested"});
    print("Itemupdated");
    CollectionReference ds1 = FirebaseFirestore.instance.collection('users');
    DateTime now = DateTime.now();
    String cur_time = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    ds1.doc(id).update({
      "RequestsCart": FieldValue.arrayUnion([
        {"ID": productId}
      ])
    });
    print("Itemupdated");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              width: 200.0,
              height: 45.0,
              decoration: new BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: () {
                  _additem();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TimelinePage(title: 'Your GiveAway History')),
                  );
                },
                child: Center(
                  child: Text(
                    'Get It',
                    style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailContentMenu extends StatelessWidget {
  String productLocation;
  String productDescription;
  String productContact;
  DetailContentMenu(
      {Key key,
      @required this.productLocation,
      @required this.productDescription,
      @required this.productContact})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: RichText(
      text: TextSpan(
        text: 'Location:\n',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: productLocation + '\n\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
              text: 'Contact:\n', style: DefaultTextStyle.of(context).style),
          TextSpan(
              text: "+91" + productContact + '\n\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(
              text: productDescription,
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    ));
  }
}
