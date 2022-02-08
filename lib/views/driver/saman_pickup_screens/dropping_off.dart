import 'dart:async';
import 'package:saman/views/driver/driverHomePage/driver_homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:saman/constants.dart';
import 'package:saman/components/language_button.dart';
import 'dart:typed_data' as i;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DroppingOff extends StatefulWidget {
  final String docId;

  DroppingOff({this.docId});

  @override
  _DroppingOffState createState() => _DroppingOffState();
}

class _DroppingOffState extends State<DroppingOff> {
  final SharedPreference secureStorage = SharedPreference();
  LatLng origionPoint;
  GoogleMapController mapController;
  bool isLoading = false;
  String status,userId;
  String dropoffAddress;
  String ownerName, phone;
  List names = [];
  LatLng destination;
  double CAMERA_ZOOM = 16;
  double CAMERA_TILT = 80;
  double CAMERA_BEARING = 30;

  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> _polylines = {};

// this is the key object - the PolylinePoints
// which generates every polyline between start and finish
  PolylinePoints polylinePoints = PolylinePoints();
  StreamSubscription<LocationData> locationSubscription;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    _getCurrentLocation();
    getLatLng();
  }
@override
  void dispose() {
  locationSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(yellowColor))),
          )
        : Scaffold(
            appBar: AppBar(
                leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios)),
                actions: [LanguageButton()],
                title: Text("dropOff",
                ),
                centerTitle: true,
                iconTheme: IconThemeData(color: yellowColor),
                backgroundColor: selectedColorVehicle),
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  mapType: MapType.terrain,
                  markers: listMarkers,
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  polylines: Set<Polyline>.of(_polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: destination,
                    zoom: 15.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(20)),
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "dropOffAddress",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text("    "),
                                  Icon(
                                    Icons.my_location_outlined,
                                    color: yellowColor,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "$dropoffAddress",
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1.5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text("      "),
                                  Image.asset("assets/icons/Group.png"),
                                  Text(
                                    "  $ownerName",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _makePhoneCall('tel:$phone');
                                      });
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color: yellowColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: ()=>MapsLauncher.launchCoordinates(origionPoint.latitude, origionPoint.longitude),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  color: driverScreenDirectionButton,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                               "direction",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () async {
                              isLoading = true;
                              String userId =
                                  await secureStorage.readSecureData("userId");
                              Firestore.instance
                                  .collection("deliverySaman")
                                  .document(widget.docId)
                                  .updateData({"status": "Delivered"})
                                  .then((value) => {
                                        Firestore.instance
                                            .collection("deliverySaman")
                                            .document(widget.docId)
                                            .get()
                                            .then((value1) => {
                                                  Firestore.instance
                                                      .collection("history")
                                                      .document()
                                                      .setData({
                                                    "weightOfObject": value1
                                                        .data['weightOfObject'],
                                                    "userId":
                                                        value1.data['userId'],
                                                    "from": value1.data['from'],
                                                    "to": value1.data['to'],
                                                    "price":
                                                        value1.data['price'],
                                                    "status":
                                                        value1.data['status'],
                                                    "quantity":
                                                        value1.data['quantity'],
                                                    "nameOfProduct": value1
                                                        .data['nameOfProduct'],
                                                    "orderId":
                                                        value1.data['orderId'],
                                                    "driverUserId": userId
                                                  }).then((value) => {
                                                            Firestore.instance
                                                                .collection(
                                                                    "deliverySaman")
                                                                .document(widget
                                                                    .docId)
                                                                .delete(),
                                                          }),
                                                })
                                      })
                                  .then((data) => {
                                        isLoading = false,
                                getToken(),
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DriverHomePage()),
                                            (route) => false),
                                      });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  color: yellowColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                  child: Text(
                                "orderDelivered",
                                style: TextStyle(
                                    color: selectedColorVehicle,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }

  setPolylines(lat1, lng1, lat2, lng2) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kPLACES_API_KEY,
      PointLatLng(lat1, lng1),
      PointLatLng(lat2, lng2),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.yellow, points: polylineCoordinates,width: 3);
    _polylines[id] = polyline;
    setState(() {
      isLoading = false;
    });
  }
  final String serverToken = 'AAAAkDXhekg:APA91bFiOLoANJyHIYkc7ovEfDJw8Mu7kQ0dW-3Kmrd1SpXL71zkJpSJ1e_X5JOHV8WcaYmNmQ6O5NUpCuFwoC4EmpGYFy1uilx_cmbrjxT_elgsYN8yAZWyA6361bJDzJMi6XHG3gE5';

  getToken() {
    Firestore.instance.collection("tokens").document(userId).get().then((
        value) => {
      sendMessage(value.data['token']),
    });
  }

  Future<Map<String, dynamic>> sendMessage(token) async {
    var response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Driver reached for pickup',
            'title': 'Saman'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
    print(response);
  }
  getLatLng() {
    print(widget.docId);
    Firestore.instance
        .collection("deliverySaman")
        .document(widget.docId)
        .get()
        .then((value) => {
              status = value.data['status'],
              names = value.data['nameOfProduct'],
      userId = value.data['userId'],
              getOwnerDetails(int.parse(value.data['userId'])),
              dropoffAddress = value.data['to'],
              origionPoint = LatLng(value.data['toLat1'], value.data['toLng1']),
              print("drier"),
              print(value.data['driverLng']),
              add(value.data['toLat1'], value.data['toLng1']),
              setPolylines(value.data['driverLat'], value.data['driverLng'],
                  value.data['toLat1'], value.data['toLng1']),
            });
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  getOwnerDetails(int userId) {
    Firestore.instance
        .collection("users")
        .where('userId', isEqualTo: userId)
        .getDocuments()
        .then((value) => {
              ownerName = value.documents[0]['name'],
              phone = value.documents[0]['number'],
              print(ownerName + phone),
            });
  }

  Future<i.Uint8List> getBytesFromAsset(String path, int width) async {
    i.ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  final Set<Marker> listMarkers = {};

  add(lat, lng) async {
    LatLng _center = LatLng(lat, lng);
    setState(() {
      origionPoint = _center;
    });
    final i.Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/pointer.png', 150);
    listMarkers.add(Marker(
        markerId: MarkerId('2'),
        position: _center,
        infoWindow: InfoWindow(
          title: status,
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon)));
    // icon: BitmapDescriptor.fromAssetImage(configuration, assnhetName)
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLatLng();
  }

  Location location = new Location();

  Future _getCurrentLocation() async {
    locationSubscription = location.onLocationChanged.listen((event) {
      updateDetailsInDb(event.latitude, event.longitude);
      destination = LatLng(event.latitude, event.longitude);
      print(destination);
      // polylineCoordinates.clear();
      // getLatLng();
    });
    location.getLocation().then((value) => {
          updateDetailsInDb(value.latitude, value.longitude),
        });
    print('------------------------------');
    print(destination);
  }

  updateDetailsInDb(lat, lng) async {
    Firestore.instance
        .collection("deliverySaman")
        .document(widget.docId)
        .updateData({"driverLat": lat, "driverLng": lng});
  }
// void updatePinOnMap() async {
//   final i.Uint8List markerIcon =
//   await getBytesFromAsset('assets/icons/pointer.png', 150);
//   // create a new CameraPosition instance
//   // every time the location changes, so the camera
//   // follows the pin as it moves with an animation
//   CameraPosition cPosition = CameraPosition(
//     zoom: CAMERA_ZOOM,
//     tilt: CAMERA_TILT,
//     bearing: CAMERA_BEARING,
//     target: LatLng(destination.latitude,
//         destination.longitude),
//   );
//   final GoogleMapController controller = await _controller.future;
//   controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
//   // do this inside the setState() so Flutter gets notified
//   // that a widget update is due
//   setState(() {
//     // updated position
//     var pinPosition = LatLng(destination.latitude,
//         destination.longitude);
//
//     // the trick is to remove the marker (by id)
//     // and add it again at the updated location
//     listMarkers.removeWhere(
//             (m) => m.markerId.value == '2');
//     listMarkers.add(Marker(
//         markerId: MarkerId('2'),
//         position: pinPosition, // updated position
//         icon: BitmapDescriptor.fromBytes(markerIcon)
//     ));
//   });
// }
}
