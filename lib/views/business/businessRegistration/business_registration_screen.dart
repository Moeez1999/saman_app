import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:saman/components/language_button.dart';
import 'package:saman/components/phone_otp.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/welcome/welcome_screen.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import '../../../constants.dart';
import 'package:saman/views/business/businessRegistration/address_pickup_screen.dart';

class BusinessRegistrationScreen extends StatefulWidget {
  final String userId;
  final String status;

  BusinessRegistrationScreen({@required this.userId , this.status});

  @override
  _BusinessRegistrationScreenState createState() =>
      _BusinessRegistrationScreenState();
}

class _BusinessRegistrationScreenState
    extends State<BusinessRegistrationScreen> {
  TextEditingController businessName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController showRoomAddress = TextEditingController();
  TextEditingController wareHouseAddress = TextEditingController();
  final SharedPreference secureStorage = SharedPreference();
  String selectedCountryCode = '+92';

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  bool isLoading = false;
  FocusNode allNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: yellowColor),
        actions: [LanguageButton()],
        title: Text(
          "Business Registration",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: accountSelectionBackgroundColor,
      ),
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          buildTextField(
                              "businessName",
                              businessName,
                              "assets/icons/building2-icon.png",
                              1,
                              TextInputType.name,
                              true),
                          buildTextField(
                              "firstName",
                              firstName,
                              "assets/icons/person.png",
                              1,
                              TextInputType.name,
                              true),
                          buildTextField(
                              "lastName",
                              lastName,
                              "assets/icons/id-card.png",
                              1,
                              TextInputType.name,
                              true),
                          // Row(
                          //   children: [
                          //     Theme(
                          //       data: ThemeData(
                          //         primaryColor: toastColor,
                          //         primaryColorDark: toastColor,
                          //         textSelectionTheme: TextSelectionThemeData(
                          //             cursorColor: toastColor),
                          //       ),
                          //       child: CountryCodePicker(
                          //         textStyle: TextStyle(color: Colors.white),
                          //         initialSelection: selectedCountryCode,
                          //         onChanged: _onCountryChange,
                          //         showCountryOnly: false,
                          //         showOnlyCountryWhenClosed: false,
                          //         searchDecoration: InputDecoration(
                          //           border: OutlineInputBorder(),
                          //         ),
                          //         boxDecoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(7),
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: buildTextField(
                          //           getTranslated(context, 'number'),
                          //           number,
                          //           "assets/icons/yellow-call-icon.png",
                          //           1,
                          //           TextInputType.phone,
                          //           true),
                          //     ),
                          //   ],
                          // ),
                          InkWell(
                            onTap: () async {
                              final address = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapScreen()));
                              setState(() {
                                showRoomAddress.text = address;
                              });
                            },
                            child: buildTextField(
                                "showRoomAddress",
                                showRoomAddress,
                                "assets/icons/building1-icon.png",
                                3,
                                TextInputType.streetAddress,
                                false),
                          ),
                          InkWell(
                            onTap: () async {
                              final address = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapScreen()));
                              setState(() {
                                wareHouseAddress.text = address;
                              });
                            },
                            child: buildTextField(
                                "wareHouseAddress",
                                wareHouseAddress,
                                "assets/icons/warehouse.png",
                                3,
                                TextInputType.streetAddress,
                                false),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedButton(
                                height: size.height * 0.05,
                                width: size.width * 0.36,
                                text: "cancel",
                                color: backButtonColor,
                                textColor: Colors.white,
                                press: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WelcomeScreen()),
                                      (route) => false);
                                },
                              ),
                              Spacer(),
                              RoundedButton(
                                height: size.height * 0.05,
                                width: size.width * 0.36,
                                text: "save",
                                color: yellowColor,
                                textColor: textBoxColor,
                                press: () async {
                                  if (firstName.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        "enterFirstName",
                                        context);
                                  } else if (lastName.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        "enterLastName",
                                        context);
                                  } else if (businessName.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                       "enterBusinessName",
                                        context);
                                  } else if (showRoomAddress.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        "enterShowRoomAddress",
                                        context);
                                  } else if (wareHouseAddress.text.isEmpty) {
                                    AuthService().displayToastMessage(
                                        "enterWarehouseAddress",
                                        context);
                                  } else {
                                    isLoading = true;
                                    businessRegistrationFunction();
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
        ),
      ),
    );
  }

  businessRegistrationFunction() {
    print(widget.userId);
    Map<String, dynamic> data = {
      "businessName": businessName.text,
      "firstName": firstName.text,
      "lastName": lastName.text,
      // "number": selectedCountryCode + number.text,
      "showRoomAddress": showRoomAddress.text,
      "wareHouseAddress": wareHouseAddress.text,
      "profilePic": ""
    };
    Firestore.instance
        .collection("users")
        .where("userId", isEqualTo: int.parse(widget.userId))
        .getDocuments()
        .then((val) => {
              Firestore.instance
                  .collection("users")
                  .document(val.documents[0].documentID)
                  .updateData(data)
                  .then((value) => {
                        isLoading = false,
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                      name: "Business",
                                      userId: widget.userId,
                                  status: widget.status,
                                    )),
                            (route) => false),
                      })
                  .catchError((e) {
                isLoading = false;
              }),
            })
        .catchError((onError) {
      isLoading = false;
    });
  }

  Widget buildTextField(
      text, dynamic controller, icon, int lines, dynamic type, bool enabled) {
    return Column(
      children: [
        TextField(
          keyboardType: type,
          controller: controller,
          enabled: enabled,
          // focusNode: allNode,
          style: TextStyle(color: Colors.white),
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
              hintStyle: TextStyle(color: Colors.white),
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
