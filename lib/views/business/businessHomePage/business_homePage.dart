import 'package:flutter/material.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/business/select_saman/select_saman_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/views/business/map/map_screen.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/history/history_screen.dart';
import 'package:saman/views/business/businessProfile/edit_profile.dart';

class BusinessHomePage extends StatefulWidget {
  @override
  _BusinessHomePageState createState() => _BusinessHomePageState();
}

class _BusinessHomePageState extends State<BusinessHomePage> {
  TextEditingController searchController = TextEditingController();
  SharedPreference storage = SharedPreference();
  String userId;
  String userType;
  String _value = 'en';
  bool isLoading = false;

  @override
  void initState() {
    isLoading = true;
    storage.readSecureData("userId").then((value) => {
          print(value),
          userId = value,
          isLoading = false,
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
                  ), Divider(
                    color: Colors.black,
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfileBusiness()));
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: drawerWidget(userId),
          appBar: AppbarWidget(
            check: true,
            title: getTranslated(context, 'businessHomePage'),
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
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(yellowColor)),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SelectSamanPage()));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        "assets/icons/add.png",
                                        height: 40,
                                      ),
                                      margin: EdgeInsets.fromLTRB(3, 3, 3, 3),
                                    ),
                                    Text(
                                      getTranslated(context, 'addNewOrder'),
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff20BD65)),
                                    ),
                                    Container()
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              getTranslated(context, 'listOfOrders'),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            buildTextField(searchController, "Search Orders"),
                            //Search Wala Container
                            SizedBox(
                              height: 8,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("deliverySaman")
                                  .where("userId", isEqualTo: "$userId")
                                  .orderBy("orderId")
                                  .snapshots(),
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
                                          child: Text("No post"),
                                        ),
                                      )
                                    : Container(
                                        child: ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshot.data.documents.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    MapScreen(
                                                                      docId: snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .documentID,
                                                                    )));
                                                  },
                                                  child: orderTile(
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                              ['orderId']
                                                          .toString(),
                                                      snapshot.data
                                                              .documents[index]
                                                          ['to'],
                                                      snapshot.data
                                                              .documents[index]
                                                          ['status'],
                                                      snapshot.data
                                                              .documents[index]
                                                          ['weightOfObject'],
                                                      snapshot.data
                                                              .documents[index]
                                                          ['price']),
                                                ),
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
                          ],
                        ),
                      ),
                    )
            ],
          )),
    );
  }

  Widget buildTextField(dynamic controller, String text) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            //EdgeInsets.symmetric(vertical: 12, horizontal: 10.0),
            focusColor: Colors.white,
            fillColor: Color(0xff338B6B),
            filled: true,
            hintText: text,
            hintStyle: TextStyle(color: Colors.grey.shade300),
            suffixIcon: Icon(
              Icons.search_outlined,
              color: Colors.grey.shade300,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28.0)),
                borderSide: BorderSide.none),
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget orderTile(String orderId, deliveryLocation, status, size, price) {
    return Container(
      decoration: BoxDecoration(
          color:status == "waiting..." ? yellowColor : selectedColorVehicle, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getTranslated(context, "orderId") + orderId,
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
                  getTranslated(context, 'to'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  status == "waiting..." ? selectedColorVehicle : yellowColor
                      ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Text(
                    deliveryLocation,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 16, color:  status == "waiting..." ? selectedColorVehicle : yellowColor),
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width /9,
                  child: Text(
                    getTranslated(context, 'status'),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:  status == "waiting..." ? selectedColorVehicle : yellowColor),
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ), //text1
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  getTranslated(context, 'weight'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  status == "waiting..." ? selectedColorVehicle : yellowColor),
                ),
                Text(
                  size + getTranslated(context, 'kg'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:  status == "waiting..." ? selectedColorVehicle : yellowColor),
                ),
                Spacer(),
                Text(
                  getTranslated(context, 'rs') + "$price/-",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:  status == "waiting..." ? selectedColorVehicle : yellowColor),
                ),
              ],
            ), //text2
            SizedBox(
              height: 7,
            ),
          ],
        ),
      ),
    );
  }
}
