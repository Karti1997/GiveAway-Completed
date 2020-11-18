import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class Donationform extends StatefulWidget {
  @override
  _DonationformState createState() => _DonationformState();
}

class _DonationformState extends State<Donationform> {
  String Taskname,
      Taskquantity,
      Taskunit,
      Taskloc,
      TaskContact,
      TaskDesc,
      cur_time,
      TaskExpire;
  TextEditingController _tasknamecont,
      _taskquantity,
      _taskunit,
      _taskloc,
      _taskcontact,
      _taskDesc,
      _taskExpire;
  double lati = 0.0, longi = 0.0;
  GeoPoint posi;
  getlocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lati = position.latitude;
      longi = position.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _tasknamecont = new TextEditingController();
    _taskquantity = new TextEditingController();
    _taskunit = new TextEditingController();
    _taskloc = new TextEditingController();
    _taskcontact = new TextEditingController();
    _taskDesc = new TextEditingController();
    _taskExpire = new TextEditingController();
    DateTime now = DateTime.now();
    cur_time = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    getlocation();
  }

  int _mytasktype = 0;
  String taskval;
  void _handleTaskType(int value) {
    setState(() {
      _mytasktype = value;
      switch (value) {
        case 1:
          taskval = "Food";
          break;
        case 2:
          taskval = "Clothes";
          break;
        case 3:
          taskval = "Education";
          break;
        case 4:
          taskval = "Medicine";
          break;
        case 5:
          taskval = "others";
          break;
      }
    });
  }

  createData() {
    CollectionReference ds1 = FirebaseFirestore.instance.collection('users');
    CollectionReference ds = FirebaseFirestore.instance.collection('Donation');
    Map<String, dynamic> tasks = {
      'Donor': FirebaseAuth.instance.currentUser.uid,
      'Itemname': _tasknamecont.text,
      'ItemDescription': _taskDesc.text,
      'Itemquantity': _taskquantity.text,
      'Itemunit': _taskunit.text,
      'Itemloc': _taskloc.text,
      'locationpoint': posi,
      'Itemcontact': _taskcontact.text,
      'Itemtype': taskval,
      'PostedTime': cur_time,
      'Status': "Posted",
      'Expire': _taskExpire.text
    };
    print(tasks);
    ds.add(tasks).then((val) => {
          ds1.doc(FirebaseAuth.instance.currentUser.uid).update({
            "DonationCart": FieldValue.arrayUnion([val.id])
          })
        });
  }

  _placepicker() {
    {
      GoogleMapController mapController;
      Set<Marker> markers = Set.from([]);
      String searchaddr;
      void onMapCreated(GoogleMapController controller) {
        setState(() {
          mapController = controller;
        });
      }

      searchandnavigate() {
        Geolocator().placemarkFromAddress(searchaddr).then((result) {
          setState(() {
            posi = GeoPoint(
                result[0].position.latitude, result[0].position.longitude);
          });
          print(result[0].position.latitude);
          print(result[0].position.longitude);
          Marker mk1 = Marker(
              markerId: MarkerId('1'),
              position: LatLng(
                  result[0].position.latitude, result[0].position.longitude));
          setState(() {
            markers.add(mk1);
          });
          mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(result[0].position.latitude,
                      result[0].position.longitude),
                  zoom: 30.0)));
        });
      }

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Scaffold(
              body: Stack(
                children: [
                  GoogleMap(
                    markers: markers,
                    onMapCreated: onMapCreated,
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lati, longi), zoom: 10.0),
                  ),
                  Positioned(
                    top: 30.0,
                    right: 15.0,
                    left: 15.0,
                    child: Container(
                      height: 50.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Enter the address',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 15.0, top: 15.0),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: searchandnavigate,
                              iconSize: 30.0,
                            )),
                        onChanged: (val) {
                          setState(() {
                            searchaddr = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 20,
                    child: FloatingActionButton(
                      child: Icon(Icons.location_on),
                      onPressed: () {
                        setState(() {
                          _taskloc.text = searchaddr;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            );
          });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Giveaway',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new ListTile(
                leading: const Icon(Icons.person),
                title: TextFormField(
                  controller: _tasknamecont,
                  decoration: InputDecoration(
                      labelText: "Item name: ", hintText: "eg: T-shirts"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Item Name';
                    }
                    return null;
                  },
                ),
              ),
              new ListTile(
                leading: const Icon(FontAwesomeIcons.tags),
                title: TextFormField(
                  controller: _taskDesc,
                  decoration:
                      InputDecoration(labelText: "Description: ", hintText: ""),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(
                height: 1.0,
              ),
              new ListTile(
                leading: const Icon(FontAwesomeIcons.buyNLarge),
                title: TextFormField(
                  controller: _taskquantity,
                  decoration: InputDecoration(
                      labelText: "Quantity: ", hintText: "eg: 50"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Quantity';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(
                height: 1.0,
              ),
              new ListTile(
                leading: const Icon(FontAwesomeIcons.list),
                title: TextFormField(
                  controller: _taskunit,
                  decoration:
                      InputDecoration(labelText: "Unit: ", hintText: "eg: kgs"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Unit';
                    }
                    return null;
                  },
                ),
              ),
              const Divider(
                height: 1.0,
              ),
              new ListTile(
                  leading: const Icon(Icons.location_on),
                  title: GestureDetector(
                    child: TextFormField(
                      onTap: _placepicker,
                      controller: _taskloc,
                      decoration: InputDecoration(
                          labelText: "Address: ",
                          hintText: "eg: 295,2nd main road,Tvl-town"),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter Address';
                        }
                        return null;
                      },
                    ),
                  )),
              new ListTile(
                leading: const Icon(Icons.phone),
                title: TextFormField(
                  controller: _taskcontact,
                  decoration: InputDecoration(
                      labelText: "Contact: ", hintText: "eg: 9442770493"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Contact number';
                    }
                    return null;
                  },
                ),
              ),
              new ListTile(
                  title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 1,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  ),
                  Text('Food', style: TextStyle(fontSize: 10.0)),
                  Radio(
                    value: 2,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  ),
                  Text('Clothes', style: TextStyle(fontSize: 10.0)),
                  Radio(
                    value: 3,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  ),
                  Text('Education', style: TextStyle(fontSize: 10.0)),
                  Radio(
                    value: 4,
                    groupValue: _mytasktype,
                    onChanged: _handleTaskType,
                    activeColor: Colors.blue,
                  ),
                  Text('Others', style: TextStyle(fontSize: 10.0))
                ],
              )),
              if (taskval == "Food")
                new ListTile(
                  leading: const Icon(Icons.timer),
                  title: TextFormField(
                    controller: _taskExpire,
                    decoration: InputDecoration(
                        labelText: "Expire Time: ", hintText: "In hours"),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            createData();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Donation added'),
            ));
          }
        },
      ),
    );
  }
}
