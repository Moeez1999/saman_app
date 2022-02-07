import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:saman/localization/localization_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:saman/views/business/businessHomePage/business_homePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/views/history/history_screen.dart';

class PlaceOrderPage extends StatefulWidget {
  final List name;
  final String heightOO;
  final String widthOO;
  final String lengthOO;
  final String weightOO;
  final String screenName;

  PlaceOrderPage(
      {this.name,
      this.heightOO,
      this.lengthOO,
      this.weightOO,
      this.widthOO,
      this.screenName});

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  FocusNode toFocus = FocusNode();
  FocusNode fromFocus = FocusNode();
  bool isLoading = false;
  final SharedPreference secureStorage = SharedPreference();
  String index = "openPickup";
  SharedPreference storage = SharedPreference();
  String userId;
  String _value = 'en';
  String userType;

  @override
  void initState() {
    storage.readSecureData("userId").then((value) => {
          print(value),
          userId = value,
        });
    storage.readSecureData("userType").then((value) => {
          print(value),
          userType = value,
        });
    super.initState();
  }

  Widget drawerWidget(userId) {
    getLocale().then((locale) {
      setState(() {
        _value = locale.languageCode;
      });
    });
    return ClipRRect(
      borderRadius: _value == "en"
          ? BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0))
          : BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0)),
      child: Theme(
        data: ThemeData(canvasColor: Colors.transparent),
        child: Drawer(
          child: Container(
              color: drawerColor,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Image.asset(
                                "assets/icons/drawer.png",
                                height: 25,
                              ),
                            ],
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("users")
                          .where("userId", isEqualTo: int.parse(userId))
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null)
                          return Container(
                              height: 30, width: 30, child: Text(""));
                        return snapshot.data.documents.length == 0
                            ? Container(
                                child: Center(
                                  child: Text(""),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data.documents[0]['businessName'],
                                    style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                      }),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => History(
                                    userId: userId,
                                    userType: userType,
                                  )));
                    },
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/icons/history.png",
                          height: 30,
                        ),
                        SizedBox(width: 20),
                        Text(
                          getTranslated(context, "history"),
                          style: TextStyle(
                              color: yellowColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/icons/wallet.png",
                          height: 30,
                        ),
                        SizedBox(width: 20),
                        Text(
                          getTranslated(context, "wallet"),
                          style: TextStyle(
                              color: yellowColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/icons/user.png",
                          height: 30,
                          color: yellowColor,
                        ),
                        SizedBox(width: 20),
                        Text(
                          getTranslated(context, "profile"),
                          style: TextStyle(
                              color: yellowColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        AuthService().signOut(context);
                      });
                    },
                    title: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 30,
                          color: yellowColor,
                        ),
                        SizedBox(width: 20),
                        Text(
                          getTranslated(context, "logOut"),
                          style: TextStyle(
                              color: yellowColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: drawerWidget(userId),
      appBar: AppbarWidget(
        check: true,
        title: getTranslated(context, 'placeAnOrder'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Image.asset(
              'assets/icons/sp-screen.png',
              width: size.width,
              color: Color(0xff007A4D),
              height: size.height,
              fit: BoxFit.cover,
            ),
          ),
          isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(yellowColor)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildTextField(
                            getTranslated(context, 'from'),
                            from,
                            "assets/icons/building2-icon.png",
                            1,
                            TextInputType.name, (e) {
                          getSuggestion(e);
                        }, fromFocus, true),
                        buildTextField(
                            getTranslated(context, 'to1'),
                            to,
                            "assets/icons/person.png",
                            1,
                            TextInputType.name, (e) {
                          getSuggestion1(e);
                        }, toFocus, true),
                        Container(
                          width: size.width,
                          height: 35,
                          decoration: BoxDecoration(
                              color: selectedColorVehicle,
                              borderRadius: BorderRadius.circular(18)),
                          child: Center(
                            child: Text(
                              getTranslated(context, 'fitting'),
                              style: TextStyle(
                                  color: yellowColor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              getTranslated(context, 'modeOfTransportation'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = "openPickup";
                                });
                              },
                              child: Container(
                                width: size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: index == "openPickup"
                                        ? selectedColorVehicle
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: yellowColor,
                                        width: 2,
                                        style: BorderStyle.solid)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/icons/open-pickup.png",
                                        height: 40,
                                      ),
                                      Text(getTranslated(context, 'openPickup'),
                                          style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              fontWeight: FontWeight.bold,
                                              color: yellowColor)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = "closePickup";
                                });
                              },
                              child: Container(
                                width: size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: index == "closePickup"
                                        ? selectedColorVehicle
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: yellowColor,
                                        width: 2,
                                        style: BorderStyle.solid)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          getTranslated(context, 'closePickup'),
                                          style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              color: yellowColor,
                                              fontWeight: FontWeight.bold)),
                                      Image.asset(
                                        "assets/icons/closed-pickup.png",
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = "loaderRicksha";
                                });
                              },
                              child: Container(
                                width: size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: index == "loaderRicksha"
                                        ? selectedColorVehicle
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: yellowColor,
                                        width: 2,
                                        style: BorderStyle.solid)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/icons/ricksha.png",
                                        height: 40,
                                      ),
                                      Text(
                                          getTranslated(
                                              context, 'loaderRicksha'),
                                          style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              color: yellowColor,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  index = "deliveryTruck";
                                });
                              },
                              child: Container(
                                width: size.width / 2.3,
                                decoration: BoxDecoration(
                                    color: index == "deliveryTruck"
                                        ? selectedColorVehicle
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color: yellowColor,
                                        width: 2,
                                        style: BorderStyle.solid)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                          getTranslated(
                                              context, 'deliveryTruck'),
                                          style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              color: yellowColor,
                                              fontWeight: FontWeight.bold)),
                                      Image.asset(
                                        "assets/icons/truck.png",
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedButton(
                              height: size.height * 0.05,
                              width: size.width * 0.36,
                              text: getTranslated(context, 'cancel'),
                              color: whiteColor,
                              textColor: accountSelectionBackgroundColor,
                              press: () {
                                Navigator.pop(context);
                              },
                            ),
                            Spacer(),
                            RoundedButton(
                              height: size.height * 0.05,
                              width: size.width * 0.36,
                              text: getTranslated(context, 'save'),
                              color: yellowColor,
                              textColor: accountSelectionBackgroundColor,
                              press: () async {
                                if (from.text.isEmpty) {
                                  AuthService().displayToastMessage(
                                      "Please select From Place", context);
                                } else if (to.text.isEmpty) {
                                  AuthService().displayToastMessage(
                                      "Please select To Place", context);
                                } else {
                                  isLoading = true;
                                  getCordsFromAddress();
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
          _placeList.isEmpty || _placeList == "" || _placeList == null
              ? Container()
              : Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Container(
                      color: accountSelectionBackgroundColor,
                      height: 400,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                String userId = await secureStorage
                                    .readSecureData("userId");
                                setState(() {
                                  Firestore.instance
                                      .collection("users")
                                      .where("userId",
                                          isEqualTo: int.parse(userId))
                                      .getDocuments()
                                      .then((value) => {
                                            Firestore.instance
                                                .collection("users")
                                                .document(value
                                                    .documents.first.documentID)
                                                .get()
                                                .then((value1) => {
                                                      fromFocus.unfocus(),
                                                      from.text = value1[
                                                          'showRoomAddress'],
                                                      _placeList.clear(),
                                                    })
                                          });
                                });
                              },
                              title: Text(
                                "Showroom Address",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                              trailing: Image.asset(
                                  "assets/icons/building1-icon.png"),
                            ),
                            ListTile(
                              onTap: () async {
                                String userId = await secureStorage
                                    .readSecureData("userId");
                                setState(() {
                                  Firestore.instance
                                      .collection("users")
                                      .where("userId",
                                          isEqualTo: int.parse(userId))
                                      .getDocuments()
                                      .then((value) => {
                                            Firestore.instance
                                                .collection("users")
                                                .document(value
                                                    .documents.first.documentID)
                                                .get()
                                                .then((value1) => {
                                                      fromFocus.unfocus(),
                                                      from.text = value1[
                                                          'wareHouseAddress'],
                                                      _placeList.clear(),
                                                    })
                                          });
                                });
                              },
                              title: Text(
                                "Warehouse Address",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                              trailing:
                                  Image.asset("assets/icons/warehouse.png"),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: _placeList.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        fromFocus.unfocus();
                                        from.text =
                                            _placeList[index]['description'];
                                        _placeList.clear();
                                      });
                                    },
                                    title: Text(
                                      _placeList[index]['description'],
                                      style: TextStyle(
                                        color: whiteColor,
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          _placeList1.isEmpty || _placeList1 == "" || _placeList1 == null
              ? Container()
              : Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Container(
                      color: Colors.white,
                      height: 400,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _placeList1.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  toFocus.unfocus();
                                  to.text = _placeList1[index]['description'];
                                  _placeList1.clear();
                                });
                              },
                              title: Text(_placeList1[index]['description']),
                            );
                          }),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future getCordsFromAddress() async {
    final Distance distance1 = new Distance();
    print("cords run hua hy");
    List locations = await locationFromAddress(to.text);
    List locations1 = await locationFromAddress(from.text);
    print("locations");
    print(locations);
    print(locations1);
    final double distance = distance1.as(
        LengthUnit.Kilometer,
        new LatLng(locations[0].latitude, locations[0].longitude),
        new LatLng(locations1[0].latitude, locations1[0].longitude));
    // double distance = calculateDistance(
    //     locations[0].latitude,
    //     locations[0].longitude,
    //     locations1[0].latitude,
    //     locations1[0].longitude);
    print(distance.round().toString());
    if (index == "openPickup" || index == "closePickup") {
      print("open pick");
      if (distance.round() >= 5) {
        print(">5");
        int last = distance.round() - 5;
        int distancePrice = last * 115;
        if (int.parse(widget.weightOO) >= 250) {
          print(">250");
          int lastWeight = int.parse(widget.weightOO) - 250;
          int weightPrice = lastWeight * 1;
          int finalPrice = distancePrice + weightPrice;
          storeCustomSaman(
              from.text,
              to.text,
              locations[0].latitude,
              locations1[0].latitude,
              locations[0].longitude,
              locations1[0].longitude,
              finalPrice);
        } else {
          print("elese1");
          storeCustomSaman(
              from.text,
              to.text,
              locations[0].latitude,
              locations1[0].latitude,
              locations[0].longitude,
              locations1[0].longitude,
              distancePrice);
        }
      } else if (int.parse(widget.weightOO) >= 250) {
        int lastWeight = int.parse(widget.weightOO) - 250;
        int weightPrice = lastWeight * 1;
        storeCustomSaman(
            from.text,
            to.text,
            locations[0].latitude,
            locations1[0].latitude,
            locations[0].longitude,
            locations1[0].longitude,
            weightPrice);
      } else {
        print("elese");
        storeCustomSaman(
            from.text,
            to.text,
            locations[0].latitude,
            locations1[0].latitude,
            locations[0].longitude,
            locations1[0].longitude,
            0);
      }
    } else if (index == "loaderRicksha") {
      print(widget.weightOO);
      print("distance" + distance.toString());
      if (distance.round() >= 5) {
        int last = distance.round() - 5;
        int distancePrice = last * 40;
        if (int.parse(widget.weightOO) >= 250) {
          print("hello");
          int lastWeight = int.parse(widget.weightOO) - 250;
          int weightPrice = lastWeight * 1;
          int finalPrice = distancePrice + weightPrice;
          print("final Price" + finalPrice.toString());
          storeCustomSaman(
              from.text,
              to.text,
              locations[0].latitude,
              locations1[0].latitude,
              locations[0].longitude,
              locations1[0].longitude,
              finalPrice);
        } else {
          storeCustomSaman(
              from.text,
              to.text,
              locations[0].latitude,
              locations1[0].latitude,
              locations[0].longitude,
              locations1[0].longitude,
              distancePrice);
        }
      } else if (int.parse(widget.weightOO) >= 250) {
        int lastWeight = int.parse(widget.weightOO) - 250;
        int weightPrice = lastWeight * 1;
        storeCustomSaman(
            from.text,
            to.text,
            locations[0].latitude,
            locations1[0].latitude,
            locations[0].longitude,
            locations1[0].longitude,
            weightPrice);
      } else {
        storeCustomSaman(
            from.text,
            to.text,
            locations[0].latitude,
            locations1[0].latitude,
            locations[0].longitude,
            locations1[0].longitude,
            0);
      }
    } else if (index == "deliveryTruck") {
      if (distance.round() >= 5) {
        int last = distance.round() - 5;
        int distancePrice = last * 215;
        if (int.parse(widget.weightOO) >= 250) {
          int lastWeight = int.parse(widget.weightOO) - 250;

          int weightPrice = lastWeight * 1;
          int finalPrice = distancePrice + weightPrice;
          storeCustomSaman(
              from.text,
              to.text,
              locations[0].latitude,
              locations1[0].latitude,
              locations[0].longitude,
              locations1[0].longitude,
              finalPrice);
        } else {
          storeCustomSaman(
              from.text,
              to.text,
              locations[0].latitude,
              locations1[0].latitude,
              locations[0].longitude,
              locations1[0].longitude,
              distancePrice);
        }
      } else if (int.parse(widget.weightOO) >= 250) {
        int lastWeight = int.parse(widget.weightOO) - 250;
        int weightPrice = lastWeight * 1;
        storeCustomSaman(
            from.text,
            to.text,
            locations[0].latitude,
            locations1[0].latitude,
            locations[0].longitude,
            locations1[0].longitude,
            weightPrice);
      } else {
        storeCustomSaman(
            from.text,
            to.text,
            locations[0].latitude,
            locations1[0].latitude,
            locations[0].longitude,
            locations1[0].longitude,
            0);
      }
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List _placeList = [];
  List _placeList1 = [];

  void getSuggestion(String input) async {
    String fullURL =
        "${urlPlaceAPI}?input=${input}&key=${kPLACES_API_KEY}&types=${placeType}&location=${pointOfSearchLat},${pointOfSearchLon}&radius=${searchRadius}&strictbounds=";

    var response = await http.get(fullURL);
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        _placeList = map['predictions'];
        print(response.body);
        print(_placeList[0]['description']);
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  void getSuggestion1(String input) async {
    String fullURL =
        "${urlPlaceAPI}?input=${input}&key=${kPLACES_API_KEY}&types=${placeType}&location=${pointOfSearchLat},${pointOfSearchLon}&radius=${searchRadius}&strictbounds=";

    var response = await http.get(fullURL);
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> map = json.decode(response.body);
        _placeList1 = map['predictions'];
        print(_placeList1[0]['description']);
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  storeCustomSaman(from, to, lat1, lat2, lng1, lng2, price) async {
    String userId = await secureStorage.readSecureData("userId");
    Firestore.instance.collection("orders").getDocuments().then((value) => {
          Firestore.instance.collection("deliverySaman").document().setData({
            "heightOfObject": widget.heightOO,
            "widthOfObject": widget.widthOO,
            "lengthOfObject": widget.lengthOO,
            "weightOfObject": widget.weightOO,
            "userId": userId,
            "from": from,
            "to": to,
            "toLat1": lat1,
            "toLng1": lng1,
            "fromLat2": lat2,
            "fromLng2": lng2,
            "modeOfTransportation": index,
            "price": price,
            "status": "waiting...",
            "quantity": widget.name,
            "nameOfProduct": widget.name,
            "orderId": value.documents[0]['orderNumber'] + 1
          }).then((val) => {
                Firestore.instance
                    .collection("orders")
                    .document(value.documents[0].documentID)
                    .updateData({
                  "orderNumber": value.documents[0]['orderNumber'] + 1
                }).then((value) => {
                          isLoading = false,
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BusinessHomePage()),
                              (route) => false),
                        })
              }),
        });
  }

  Widget buildTextField(text, dynamic controller, icon, int lines, dynamic type,
      Function chnge, FocusNode node, bool enabled) {
    return Column(
      children: [
        TextField(
          style: TextStyle(color: Colors.white),
          enabled: enabled,
          focusNode: node,
          keyboardType: type,
          controller: controller,
          onChanged: chnge,
          maxLines: lines,
          decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  icon,
                  height: 8,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(28.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey.shade200),
              hintText: text,
              fillColor: Color(0xff338F6D)),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
