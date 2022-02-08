import 'package:flutter/material.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants.dart';
import 'package:saman/constants.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/views/history/history_screen.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/driver/saman_pickup_screens/order_pickup.dart';
import 'package:saman/views/driver/driverProfile/edit_profile.dart';


class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  Color _inactiveColor = Color(0xff76B09B);
  Color _activeColor = Colors.amber;
  bool _switchValue = false;
  SharedPreference storage = SharedPreference();
  Stream<QuerySnapshot> posts;
  String _value = 'en';
  String userId;
  String userType;

  @override
  void initState() {
    super.initState();
    storage.readSecureData("userId").then((value) => {
          userId = value,
          Firestore.instance
              .collection("users")
              .where("userId", isEqualTo: int.parse(value))
              .getDocuments()
              .then((val) => {
                    print(val.documents[0].documentID),
                    Firestore.instance
                        .collection("users")
                        .document(val.documents[0].documentID)
                        .get()
                        .then((v) => {
                              posts = Firestore.instance
                                  .collection("deliverySaman")
                                  .where("modeOfTransportation",
                                      isEqualTo: v.data['vehicleType'])
                                  .snapshots(),
                            })
                  }),
        });
    storage.readSecureData("userType").then((value) => {
      print(value),
      userType = value,
    });
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
                              snapshot.data.documents[0]['firstName'],
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
                          "history",
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
                         "wallet",
                          style: TextStyle(
                              color: yellowColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ), Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileDriver()));
                    },
                    title: Row(
                      children: [
                        Image.asset(
                          "assets/icons/user.png",
                          height: 30,
                          color: yellowColor,
                        ),
                        SizedBox(width: 20),
                        Text(
                          "profile",
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
                          "logOut",
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
    return SafeArea(
      child: Scaffold(
          drawer: drawerWidget(userId),
          appBar: AppbarWidget(
            title:"driverHomepage",
            check: true,
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
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "pickUpOrders",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "inactive",
                            style: TextStyle(
                                color: _switchValue == true
                                    ? _inactiveColor
                                    : _activeColor,
                                fontSize: 16),
                          ),
                          InkWell(
                              onTap: () {
                                if (_switchValue == true) {
                                  setState(() {
                                    _switchValue = false;
                                  });
                                } else {
                                  setState(() {
                                    _switchValue = true;
                                  });
                                }
                              },
                              child: Image.asset(
                                _switchValue == true
                                    ? "assets/icons/sw-on.png"
                                    : "assets/icons/sw-off.png",
                                height: 70,
                              )),
                          Text(
                            "active",
                            style: TextStyle(
                                color: _switchValue == true
                                    ? _activeColor
                                    : _inactiveColor,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "listOfOrders",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _switchValue == true
                          ? StreamBuilder<QuerySnapshot>(
                              stream: posts,
                              builder: (context, snapshot) {
                                if (snapshot.data == null)
                                  return Center(
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                AlwaysStoppedAnimation<
                                                    Color>(yellowColor)))),
                                  );
                                return snapshot.data.documents.length == 0
                                    ? Container(
                                        child: Center(
                                          child: Text("No Active Orders"),
                                        ),
                                      )
                                    : Container(
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshot.data.documents.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                orderTile(
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                            ['orderId']
                                                        .toString(),
                                                    snapshot.data
                                                        .documents[index]['to'],
                                                    snapshot.data
                                                            .documents[index]
                                                        ['from'],
                                                    snapshot.data
                                                            .documents[index]
                                                        ['weightOfObject'],
                                                    snapshot.data
                                                            .documents[index]
                                                        ['price'], () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderPickUp(
                                                                  docId: snapshot
                                                                      .data
                                                                      .documents[
                                                                          index]
                                                                      .documentID)));
                                                }),
                                                SizedBox(
                                                  height: 15,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      );
                              },
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget orderTile(
      String orderId, deliveryLocation, from, size, price, Function navigate) {
    return Container(
      decoration: BoxDecoration(
          color: selectedColorVehicle, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "orderId" + orderId,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "to",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: yellowColor),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    deliveryLocation,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 16, color: yellowColor),
                  ),
                ),
                Spacer(),
                Text(
                 "from",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: yellowColor),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    from,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ],
            ), //text1
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                 "weight",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: yellowColor),
                ),
                Text(
                  size + "kg",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: yellowColor),
                ),
                Spacer(),
                Text(
                 "rs" + "$price/-",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: yellowColor),
                ),
              ],
            ), //text2
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: navigate,
                  child: Container(
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: Center(
                        child: Text(
                          "accept",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selectedColorVehicle),
                    )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
