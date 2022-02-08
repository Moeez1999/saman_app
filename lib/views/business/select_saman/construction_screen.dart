import 'package:saman/views/welcome/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:saman/constants.dart';
import 'package:saman/components/weightFile.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/views/history/history_screen.dart';

class ConstructionScreen extends StatefulWidget {
  @override
  _ConstructionScreenState createState() => _ConstructionScreenState();
}

class _ConstructionScreenState extends State<ConstructionScreen> {
  String selectedElectronics = "Refrigerator";
  SharedPreference storage = SharedPreference();
  String userId;
  String _value = 'en';
  String userType;
  List value = [
    {
      "name": "cement",
      "check": false,
      "value": 1,
      "weight": WeightConstants.refrigeratorWeight
    },
    {
      "name": "tiles",
      "check": false,
      "value": 1,
      "weight": WeightConstants.airConditionerWeight
    },
    {
      "name": "doors",
      "check": false,
      "value": 1,
      "weight": WeightConstants.microwaveOvenWeight
    },
    {
      "name": "windows",
      "check": false,
      "value": 1,
      "weight": WeightConstants.electricStoveWeight
    },
    {
      "name": "sand",
      "check": false,
      "value": 1,
      "weight": WeightConstants.washingMachineWeight
    },
    {
      "name": "crushed stone",
      "check": false,
      "value": 1,
      "weight": WeightConstants.washingMachineWeight
    },
  ];
  var tmpArray = [];
  String finalWeight;
  int weight = 0;

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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: businessHomepageColor,
        drawer: drawerWidget(userId),
        appBar: AppbarWidget(
          check: false,
          title: "construction",
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
                     "selectTheObject",
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
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (value[0]['check'] == true) {
                                      value[0]['check'] = false;
                                    } else {
                                      value[0]['check'] = true;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 4, color: Colors.yellow),
                                    ),
                                    child: value[0]['check'] == true
                                        ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "CEMENT",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              value[0]['check'] == false
                                  ? Container()
                                  : quantityButtons(0)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (value[1]['check'] == true) {
                                      value[1]['check'] = false;
                                    } else {
                                      value[1]['check'] = true;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 4, color: Colors.yellow),
                                    ),
                                    child: value[1]['check'] == true
                                        ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "TILES",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              value[1]['check'] == false
                                  ? Container()
                                  : quantityButtons(1)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (value[2]['check'] == true) {
                                      value[2]['check'] = false;
                                    } else {
                                      value[2]['check'] = true;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 4, color: Colors.yellow),
                                    ),
                                    child: value[2]['check'] == true
                                        ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "DOORS",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              value[2]['check'] == false
                                  ? Container()
                                  : quantityButtons(2)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (value[3]['check'] == true) {
                                      value[3]['check'] = false;
                                    } else {
                                      value[3]['check'] = true;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 4, color: Colors.yellow),
                                    ),
                                    child: value[3]['check'] == true
                                        ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "WINDOWS",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              value[3]['check'] == false
                                  ? Container()
                                  : quantityButtons(3)
                            ],
                          ),
                        ),
                      ),
                    ),  SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (value[4]['check'] == true) {
                                      value[4]['check'] = false;
                                    } else {
                                      value[4]['check'] = true;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 4, color: Colors.yellow),
                                    ),
                                    child: value[4]['check'] == true
                                        ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "SAND",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              value[4]['check'] == false
                                  ? Container()
                                  : quantityButtons(4)
                            ],
                          ),
                        ),
                      ),
                    ),  SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: selectedColorVehicle,
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 9),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (value[5]['check'] == true) {
                                      value[5]['check'] = false;
                                    } else {
                                      value[5]['check'] = true;
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 4, color: Colors.yellow),
                                    ),
                                    child: value[5]['check'] == true
                                        ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "CRUSHED STONE",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Spacer(),
                              value[5]['check'] == false
                                  ? Container()
                                  : quantityButtons(5)
                            ],
                          ),
                        ),
                      ),
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
                          text: "addOther",
                          color: backButtonColor,
                          textColor: Colors.white,
                          press: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        RoundedButton(
                          height: size.height * 0.05,
                          width: size.width * 0.36,
                          text: "continue",
                          color: languageSelectColor,
                          textColor: Colors.white,
                          press: () async {
                            weightList.clear();
                            tmpArray.clear();
                            if (value[0]['check'] == true ||
                                value[1]['check'] == true ||
                                value[2]['check'] == true ||
                                value[3]['check'] == true ||
                                value[4]['check'] == true ||
                                value[5]['check'] == true) {
                              value.forEach((element) {
                                if (element["check"] == true) {
                                  setState(() {
                                    weightList.add(
                                        int.parse(element['weight']) *
                                            element['value']);
                                    print(weightList);
                                  });
                                  tmpArray.add(element);
                                }
                              });
                              setState(() {
                                weight = weightList.reduce((a, b) => a + b);
                                finalWeight = weight.toString();
                                _showMyDialog(context, tmpArray);
                              });
                            }
                            else{
                              AuthService().displayToastMessage("Please select one Object", context);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  List weightList = [];

  _showMyDialog(context, List selectedList) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: selectedColorVehicle,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: yellowColor, width: 2)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Summary".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 250.0, // Change as per your requirement
                  width: 300.0,
                  child: ListView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff007C4E),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    selectedList[index]['value'].toString(),
                                    style: TextStyle(
                                      color: yellowColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    selectedList[index]['name'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedButton(
                      height: size.height * 0.05,
                      width: size.width * 0.25,
                      text: "cancel",
                      color: backButtonColor,
                      textColor: Colors.white,
                      press: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    RoundedButton(
                      height: size.height * 0.05,
                      width: size.width * 0.25,
                      text: "continue",
                      color: languageSelectColor,
                      textColor: Colors.white,
                      press: () async {
                        // Navigator.pop(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PlaceOrderPage(
                        //           name: selectedList,
                        //           weightOO: finalWeight,
                        //           screenName: "electronics",
                        //         )));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget quantityButtons(int index) {
    return Row(
      children: [
        value[index]['value'] == 1
            ? Container(
          height: 25,
          width: 25,
        )
            : InkWell(
          onTap: () {
            setState(() {
              value[index]['value']--;
            });
          },
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: yellowColor,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: Container(
                  width: 10,
                  height: 2,
                  color: selectedColorVehicle,
                )),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: yellowColor, width: 3)),
          child: Center(child: Text(value[index]['value'].toString())),
        ),
        SizedBox(
          width: 4,
        ),
        value[index]['value'] == 99
            ? Container(
          height: 25,
          width: 25,
        )
            : InkWell(
          onTap: () {
            setState(() {
              value[index]['value']++;
            });
          },
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: yellowColor,
                borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: selectedColorVehicle,
                )),
          ),
        ),
        SizedBox(
          width: 8,
        )
      ],
    );
  }
}
