import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:saman/constants.dart';
import 'package:saman/components/language_button.dart';
import 'dart:typed_data' as i;
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  final String docId;

  MapScreen({this.docId});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng waitingSaman;
  GoogleMapController mapController;
  bool isLoading = false;
  String status;
String time;
  Future<i.Uint8List> getBytesFromAsset(String path, int width) async {
    i.ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getLatLng();
  }
  getLatLng(){
    print(widget.docId);
    Firestore.instance.collection("deliverySaman").document(widget.docId).get().then((value) => {
      status = value.data['status'],
      if(value.data['status'] == "Picking up"){
        getTime(value.data['toLat1'],value.data['toLng1'],value.data['fromLat2'],value.data['fromLng2']),

        add(value.data['driverLat'],value.data['driverLng'])
      }else{
        // getTime(value.data['toLat1'],value.data['toLng1'],value.data['driverLat'],value.data['driverLng']),
        add(value.data['fromLat2'],value.data['fromLng2'])
      }
    });
  }
  getTime(lat1, lng1, lat2, lng2) async {
    var response = await http.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$lat1,$lng1&destinations=$lat2,$lng2&key=AIzaSyC3PcQErVp_pXff99I8WMF_A6IionYOtbY");
   setState(() {
     Map map = json.decode(response.body);
     print(map['rows'][0]['elements'][0]['duration']['text']);
     time = map['rows'][0]['elements'][0]['duration']['text'];
     // print(map);
   });
  }
  final Set<Marker> listMarkers = {};

  add(lat,lng) async {
    LatLng _center = LatLng(lat, lng);
    setState(() {
      waitingSaman = _center;
      isLoading = false;
    });
    final i.Uint8List markerIcon =
        await getBytesFromAsset('assets/icons/pointer.png', 150);
    listMarkers.add(Marker(
        markerId: MarkerId('2'),
        position: _center,
        infoWindow: InfoWindow(title: status,),
        icon: BitmapDescriptor.fromBytes(markerIcon)));
    // icon: BitmapDescriptor.fromAssetImage(configuration, assnhetName)
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(yellowColor))
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios)),
                actions: [LanguageButton()],
                title: Text(
                  'Order Tracking',
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

                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: waitingSaman,
                    zoom: 10.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedColorVehicle,
                        borderRadius: BorderRadius.circular(20)),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Status:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Text(
                          status == "Picking up" ? "Delivering in ${time == null ? "" : time}" : "Waiting...",
                          style: TextStyle(
                              color: yellowColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    getLatLng();
  }
}
