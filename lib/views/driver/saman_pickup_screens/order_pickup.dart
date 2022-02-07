import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saman/constants.dart';
import 'package:saman/components/language_button.dart';
import 'dart:typed_data' as i;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/views/driver/saman_pickup_screens/picking_up.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:saman/localization/localization_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class OrderPickUp extends StatefulWidget {
  final String docId;

  const OrderPickUp({Key key, this.docId}) : super(key: key);

  @override
  _OrderPickUpState createState() => _OrderPickUpState();
}

class _OrderPickUpState extends State<OrderPickUp> {
  LatLng waitingSaman;
  GoogleMapController mapController;
  bool isLoading = false;
  String status;
  String dropoffAddress;
  String pickUpAddress;
  String ownerName, phone;
  List names = [];
  String userId;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getLatLng();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
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
          title: Text(
            getTranslated(context, "orderPickUp"),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: yellowColor),
          backgroundColor: selectedColorVehicle),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.terrain,
              markers: listMarkers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: waitingSaman,
                zoom: 18.0,
              ),
            ),
          ),
          Container(
            color: businessHomepageColor,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedColorVehicle,
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 8,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Text(getTranslated(context, 'samanToPickup'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              itemCount: names.length,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      names[index]['name'] +
                                          "(${names[index]['value']
                                              .toString()})",
                                      style: TextStyle(
                                          color: yellowColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedColorVehicle,
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 5,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(getTranslated(context, 'pickUpAddress'),
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
                                Image.asset(
                                    "assets/icons/icon - currentLocation.png"),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "$pickUpAddress",
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            getTranslated(context, 'dropOffAddress'),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedColorVehicle,
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 13,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Center(
                      child: Padding(
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
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2,
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
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      print(widget.docId);
                      Firestore.instance
                          .collection("deliverySaman")
                          .document(widget.docId)
                          .updateData({"status": "Picking up"}).then(
                              (value) =>
                          {
                            print("then"),
                            getToken(),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PickingUp(
                                            docId:
                                            widget.docId))),
                          });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: yellowColor,
                          borderRadius: BorderRadius.circular(20)),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 14,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(getTranslated(context, 'confirm'),
                                style: TextStyle(
                                    color: selectedColorVehicle,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
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
        .then((value) =>
    {
      status = value.data['status'],
      names = value.data['nameOfProduct'],
      userId = value.data['userId'],
      getOwnerDetails(int.parse(value.data['userId'])),
      dropoffAddress = value.data['to'],
      pickUpAddress = value.data['from'],
      print(names),
      add(value.data['fromLat2'], value.data['fromLng2']),
      add1(value.data['toLat1'], value.data['toLng1']
      ),
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
        .then((value) =>
    {
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
      waitingSaman = _center;
      isLoading = false;
      print(isLoading);
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

  add1(lat, lng) async {
    LatLng _center = LatLng(lat, lng);
    setState(() {
      waitingSaman = _center;
      isLoading = false;
      print(isLoading);
    });
    final i.Uint8List markerIcon =
    await getBytesFromAsset('assets/icons/pointer.png', 150);
    listMarkers.add(Marker(
        markerId: MarkerId('3'),
        position: _center,
        infoWindow: InfoWindow(
          title: "Drop off Address",
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon)));
    // icon: BitmapDescriptor.fromAssetImage(configuration, assnhetName)
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLatLng();
  }
}
