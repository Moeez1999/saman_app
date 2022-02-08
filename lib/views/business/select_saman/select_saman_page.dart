import 'package:flutter/material.dart';
import 'package:saman/constants.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:saman/views/business/select_saman/electronics_saman.dart';
import 'package:saman/views/business/select_saman/custom_saman_page.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/history/history_screen.dart';
import 'package:saman/views/business/select_saman/furniture_screen.dart';
import 'package:saman/views/business/select_saman/construction_screen.dart';
import 'package:saman/views/business/select_saman/animal_screen.dart';



class SelectSamanPage extends StatefulWidget {
  @override
  _SelectSamanPageState createState() => _SelectSamanPageState();
}

class _SelectSamanPageState extends State<SelectSamanPage> {
  String _value = 'en';
  SharedPreference storage = SharedPreference();
  String userId;
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: businessHomepageColor,
        drawer: drawerWidget(userId),
        appBar: AppbarWidget(
          check: false,
          title: "selectSaman",
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
                  Text(
                    "selectCategory",textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ElectronicsSaman()));
                      },
                      child: selectSamanTile("electronics",'assets/icons/electronics.png')),
                  SizedBox(height: 15,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FurnitureScreen()));
                      },
                      child: selectSamanTile("furniture",'assets/icons/furniture.png')),
                  SizedBox(height: 15,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AnimalScreen()));

                      },
                      child: selectSamanTile("animals",'assets/icons/animal.png')),
                  SizedBox(height: 15,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ConstructionScreen()));
                      },
                      child: selectSamanTile("construction",'assets/icons/construction.png')),
                  SizedBox(height: 15,),
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomSamanPage()));

                      },
                      child: selectSamanTile("customSaman",'assets/icons/custom.png')),
                  SizedBox(height: 20,),

                  Center(
                    child:    RoundedButton(
                      height: size.height * 0.05,
                      width: size.width * 0.30,
                      text: "back",
                      fontSize: size.width/23 ,
                      color: whiteColor,
                      textColor: accountSelectionBackgroundColor,
                      press: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
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

  Widget selectSamanTile(name,pic){
    return  Container(
      height: 100,
      decoration: BoxDecoration(
          color: selectedColorVehicle,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 8,right: 8),
            height: 80,
            child: Image(
              image: AssetImage(pic,),),
          ),
          SizedBox(width: 9,),
          Text(  name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ],
      ),
    );
 }
}