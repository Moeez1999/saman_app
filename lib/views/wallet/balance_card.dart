import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceCard extends StatelessWidget {
  final String amount;
  const BalanceCard({Key key , this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .27,
            color: Color(0xff15294a),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total Balance,',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff6d7f99)),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$amount',
                          style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 35,
                              fontWeight: FontWeight.w800,
                              color: Color(0xffe7ad03)),
                        ),
                        Text(
                          ' Rs',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                              color: Color(0xfffbbd5c).withAlpha(200)),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     Text(
                    //       'Eq:',
                    //       style: GoogleFonts.mulish(
                    //           textStyle: Theme.of(context).textTheme.headline4,
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.w600,
                    //           color: LightColor.lightNavyBlue),
                    //     ),
                    //     Text(
                    //       ' \$10,000',
                    //       style: TextStyle(
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.w500,
                    //           color: Colors.white),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //     width: 85,
                    //     padding:
                    //         EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(Radius.circular(12)),
                    //         border: Border.all(color: Colors.white, width: 1)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         Icon(
                    //           Icons.add,
                    //           color: Colors.white,
                    //           size: 20,
                    //         ),
                    //         SizedBox(width: 5),
                    //         Text("Top up",
                    //             style: TextStyle(color: Colors.white)),
                    //       ],
                    //     ))
                  ],
                ),
                Positioned(
                  left: -170,
                  top: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Color(0xff3554d3),
                  ),
                ),
                Positioned(
                  left: -160,
                  top: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Color(0xff375efd),
                  ),
                ),
                Positioned(
                  right: -170,
                  bottom: -170,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Color(0xffe7ad03),
                  ),
                ),
                Positioned(
                  right: -160,
                  bottom: -190,
                  child: CircleAvatar(
                    radius: 130,
                    backgroundColor: Color(0xfffbbd5c),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
