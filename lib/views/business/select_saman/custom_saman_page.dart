import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/business/place_order/place_order_page.dart';
import 'package:saman/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/views/history/history_screen.dart';


class CustomSamanPage extends StatefulWidget {
  @override
  _CustomSamanPageState createState() => _CustomSamanPageState();
}

class _CustomSamanPageState extends State<CustomSamanPage> {
  TextEditingController heightObject = TextEditingController();
  TextEditingController widthObject = TextEditingController();
  TextEditingController lengthObject = TextEditingController();
  TextEditingController weightObject = TextEditingController();
  TextEditingController quatity = TextEditingController();
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
                  ), Divider(
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
        check: false,
        title: getTranslated(context, 'customSaman'),
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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    getTranslated(context, 'customObjectDetail'),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'heightOfObject'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: heightObject,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Color(0xff338B6B),
                                filled: true,
                                hintText: 'cm(s)',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade200)),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'widthOfObject'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: widthObject,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Color(0xff338B6B),
                                filled: true,
                                hintText: 'cm(s)',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade200)),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'lengthOfObject'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: lengthObject,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Color(0xff338B6B),
                                filled: true,
                                hintText: 'cm(s)',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade200)),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'weightOfObject'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: weightObject,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Color(0xff338B6B),
                                filled: true,
                                hintText: 'Kg(s)',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade200)),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'quantityOfObject'),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            controller: quatity,
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Color(0xff338B6B),
                                filled: true,
                                hintText: '0',
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade200)),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.white,
                            maxLength: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: RoundedButton(
                      height: size.height * 0.05,
                      width: size.width * 0.36,
                      text: getTranslated(context, 'confirm'),
                      color: whiteColor,
                      textColor: accountSelectionBackgroundColor,
                      press: () {
                        if (heightObject.text.isEmpty) {
                          AuthService().displayToastMessage(
                              getTranslated(context, 'fillTheForm'), context);
                        } else if (widthObject.text.isEmpty) {
                          AuthService().displayToastMessage(
                              getTranslated(context, 'fillTheForm'), context);
                        } else if (lengthObject.text.isEmpty) {
                          AuthService().displayToastMessage(
                              getTranslated(context, 'fillTheForm'), context);
                        } else if (weightObject.text.isEmpty) {
                          AuthService().displayToastMessage(
                              getTranslated(context, 'fillTheForm'), context);
                        } else if (quatity.text.isEmpty) {
                          AuthService().displayToastMessage(
                              getTranslated(context, 'fillTheForm'), context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaceOrderPage(
                                        name: [{"name":"Custom Saman","value":quatity.text}],
                                        heightOO: heightObject.text,
                                        lengthOO: lengthObject.text,
                                        weightOO: weightObject.text,
                                        widthOO: widthObject.text,
                                        screenName: "customSaman",
                                      )));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
