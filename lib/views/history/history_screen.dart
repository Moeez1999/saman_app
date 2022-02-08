import 'package:flutter/material.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:saman/localization/localization_constants.dart';

class History extends StatefulWidget {
  final String userId;
  final String userType;

  const History({Key key, this.userId, this.userType}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    print(widget.userType);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppbarWidget(
        check: true,
        title: "History",
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
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 24),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection("history")
                  .where(
                      widget.userType == "Business" ? "userId" : "driverUserId",
                      isEqualTo: "${widget.userId}")
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    yellowColor)))),
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
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                orderTile(
                                    snapshot.data.documents[index]['orderId']
                                        .toString(),
                                    snapshot.data.documents[index]['to'],
                                    snapshot.data.documents[index]['status'],
                                    snapshot.data.documents[index]
                                        ['weightOfObject'],
                                    snapshot.data.documents[index]['price']),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            );
                          },
                        ),
                      );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget orderTile(String orderId, deliveryLocation, status, size, price) {
    return Container(
      decoration: BoxDecoration(
          color: selectedColorVehicle, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
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
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Text(
                    deliveryLocation,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(fontSize: 16, color: yellowColor),
                  ),
                ),
                Spacer(),
                Text(
                  "status",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: yellowColor),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  child: Text(
                    status,
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
          ],
        ),
      ),
    );
  }
}
