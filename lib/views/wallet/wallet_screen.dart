import 'package:flutter/material.dart';
import 'package:saman/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/history/history_screen.dart';
import 'package:saman/views/wallet/balance_card.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  final String userType;

  const WalletScreen({Key key, this.userId, this.userType}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  SharedPreference storage = SharedPreference();
  // String userType;
  // String userId;
  // String _value = 'en';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('User Id in wallet ${widget.userId}');
    return Scaffold(
        backgroundColor: businessHomepageColor,
        // drawer: drawerWidget(userId),
        appBar: AppbarWidget(
          check: false,
          title: "Wallet",
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
                    // Text(
                    //   "Your Wallet",
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection("wallet")
                          .where("userId", isEqualTo: widget.userId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        print('Documentsw is${snapshot.data.documents}');
                        if (snapshot.data == null)
                          return Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      yellowColor),
                                ),
                              ),
                            ),
                          );
                        return snapshot.data.documents.length == 0
                            ? Container(
                                child: Center(
                                  child: Text("Sorry No Amount Available"),
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
                                        BalanceCard(
                                          amount: snapshot.data.documents[index]['price'],
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
            ),
          ],
        ));
  }
}
