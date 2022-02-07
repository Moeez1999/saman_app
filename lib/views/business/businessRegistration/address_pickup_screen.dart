import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart' as loc;
import 'package:saman/constants.dart';


class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLoading = false;
  TextEditingController search = TextEditingController();

  FocusNode _focusNode = FocusNode();
  int radius = 5;
  int startingPrice;
  int endingPrice = 0;
  String vehicleType = "";
  GoogleMapController _controller;
  List<Marker> myMarker = [];
  double lat, lng;
  String address;
  String city;
  String userType;
  List data = [];
  List<dynamic> _placeList = [];

  @override
  void initState() {
    print('init');
    super.initState();
    isLoading = true;
    getLocationFunction();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading == false
            ? Stack(
          children: [
            GoogleMap(
              onTap: _mapTap,
              markers: Set.from(myMarker),
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              myLocationButtonEnabled: true,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4,
                  bottom: MediaQuery.of(context).size.height / 3),
              myLocationEnabled: true,
              initialCameraPosition:
              CameraPosition(target: LatLng(lat, lng), zoom: 12),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(50.0),
                          color: Colors.white,
                        ),
                        child: TextField(
                          onChanged: (val) {
                            getSuggestion(val);
                            if (search.text.isEmpty || search.text == null || search.text == ""){
                              setState(() {
                                _placeList.clear();
                              });
                              print(_placeList);
                            }
                          },
                          focusNode: _focusNode,
                          autofocus: false,
                          controller: search,
                          decoration: InputDecoration(
                            suffixIcon: Icon(
                              Icons.search,
                              size: 25,
                            ),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(50.0),
                            ),
                            hintText:
                            "Search location",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Container(
                        color: Colors.white,
                        // height: 100,
                        child: ListView.builder(
                          physics:
                          ClampingScrollPhysics(),
                          itemCount: _placeList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Divider(
                                  thickness: 1,
                                  color:
                                  yellowColor,
                                ),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      search.text = _placeList[index]['description'].toString();
                                      getCordsFromAddress(search.text).whenComplete(() => {
                                        _placeList.clear(),
                                        _focusNode.unfocus(),
                                      });

                                    });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height / 18,
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              _placeList[index]['description'],
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    color: yellowColor,
                    onPressed: (){
                      print(address);
                      Navigator.pop(context,address);
                    },
                    child: Text("Confirm"),
                  ),
                ),

              ],
            ),
          ],
        )
            : SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              )),
        ),
      ),
    );
  }

  _mapTap(LatLng location) {
    print(location);
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(location.toString()),
        position: location,
      ));
      lat = location.latitude;
      lng = location.longitude;
    });
    changeCordsToReadable(location.latitude, location.longitude);
  }

  changeCordsToReadable(lat, lng) async {
    print("change cords run hua hy");
    List<loc.Placemark> placemarks = await loc.placemarkFromCoordinates(lat, lng);
    loc.Placemark placeMark = placemarks[0];
    address =
    "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
    city = placeMark.subAdministrativeArea;
    print(city);
    // SharedPreferenceHelper().saveLocationName(address.toString());
  }
  Future getCordsFromAddress(String search)async{
    _focusNode.unfocus();
    print("cords run hua hy");
    List<loc.Location> locations = await loc.locationFromAddress(search);
    print (locations);
    lat = locations[0].latitude;
    lng = locations[0].longitude;
    print("yeh abhi wala lat hy" + "$lat");
    LatLng point = LatLng(locations[0].latitude,locations[0].longitude);
    print("yeh point hy" "$point");
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: point,zoom: 12)));
    _mapTap(point);
    changeCordsToReadable(lat,lng);
    print("yeh search k lat lng hyn " + "$point");
  }
  getLocationFunction()async{
    Location location = new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
    setState(() {
      lat = _locationData.latitude;
      lng = _locationData.longitude;
      changeCordsToReadable(lat,lng);
      isLoading = false;
    });
  }
  void getSuggestion(String input) async {
    String type = 'pk';
    String fullURL =
        "${urlPlaceAPI}?input=${input}&key=${kPLACES_API_KEY}&types=${placeType}&location=${pointOfSearchLat},${pointOfSearchLon}&radius=${searchRadius}&strictbounds=";

    // String baseURL =
    //     'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    // String request =
    //     '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=123456789';
    var response = await http.get(fullURL);
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        _placeList = map['predictions'];
        // print(response.body);
        // print(_placeList[0]['description']);
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
