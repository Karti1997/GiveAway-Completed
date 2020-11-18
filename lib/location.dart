import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission/permission.dart';

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  /*var clients = [];
  Set<Marker> markers;
  double lati = 10.7528121;
  double longi = 79.0614088;
  bool location = false;
  GoogleMapController mapController;
  PickResult selectedPlace;
  getlocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lati = position.latitude;
      longi = position.longitude;
      location = true;
      populateClients();
    });
  }

  initmarker(String name, GeoPoint loc) {
    Geolocator()
        .distanceBetween(lati, longi, loc.latitude, loc.longitude)
        .then((dist) {
      print(dist / 1000);
    });
    Marker mk1 = Marker(
      markerId: MarkerId(name),
      position: LatLng(loc.latitude, loc.longitude),
    );
    setState(() {
      print("88888888888888888");
      print(mk1);
      markers.add(mk1);
    });
  }

  populateClients() async {
    await Firebase.initializeApp();
    var s = FirebaseFirestore.instance.collection('Donation').snapshots();
    s.toList();
    s.forEach((element) {
      element.docs.forEach((element) {
        var elt = element.data();
        initmarker(elt['Itemname'], elt['Itemloc']);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
    getlocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: location
              ? GoogleMap(
                  markers: markers,
                  onMapCreated: _onMapCreated,
                  myLocationEnabled: true,
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lati, longi), zoom: 7.0),
                )
              : Center(
                  child: Text(
                    "Give Access on your Location",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ),
        )
      ],
    );
  }

  _onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }*/
  final Set<Polyline> polyline = {};
  GoogleMapController _controller;
  List<LatLng> routeCoords;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyCWEYUOQTintfQUkjQK85kdpREf-eL7t8g");

  getpoints() async {
    var permissions =
        await Permission.getPermissionsStatus([PermissionName.Location]);
    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions =
          await Permission.requestPermissions([PermissionName.Location]);
    } else {
      routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(40.6782, -73.9442),
          destination: LatLng(40.6944, -73.9212),
          mode: RouteMode.driving);
    }
  }

  @override
  void initState() {
    super.initState();
    getpoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: OnMapCreated,
        polylines: polyline,
        initialCameraPosition:
            CameraPosition(target: LatLng(40.6782, -73.9442), zoom: 14.0),
        mapType: MapType.normal,
      ),
    );
  }

  void OnMapCreated(GoogleMapController mapController) {
    setState(() {
      _controller = mapController;
      polyline.add(Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          width: 4,
          color: Colors.green,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap));
    });
  }
}
/*class _FireMapState extends State<FireMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers;
  Position _currentPosition;
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  /*static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );*/
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    markers = Set.from([]);
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          markers: markers,
          mapType: MapType.normal,
          onTap: (position) {
            Marker mk1 = Marker(
              markerId: MarkerId('1'),
              position: position,
            );
            setState(() {
              markers.add(mk1);
            });
          },
          //initialCameraPosition: _kGooglePlex,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(_currentPosition.latitude, _currentPosition.longitude),
              zoom: 15),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            child: Text('Locate'),
            onPressed: () {
              print(_currentAddress);
              print(markers.first.position);
            },
          ),
        )
      ],
    ));
  }
}*/
