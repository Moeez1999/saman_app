import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saman/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:saman/model/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:saman/localization/localization_constants.dart';
import 'package:saman/components/appbar_widget.dart';
import 'package:saman/services/auth.dart';
import 'package:saman/views/history/history_screen.dart';
import 'package:saman/views/welcome/components/rounded_button.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;

class EditProfileBusiness extends StatefulWidget {
  const EditProfileBusiness({Key key}) : super(key: key);

  @override
  _EditProfileBusinessState createState() => _EditProfileBusinessState();
}

class _EditProfileBusinessState extends State<EditProfileBusiness> {
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
                          // getTranslated(context, "history"),
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
                          // getTranslated(context, "wallet"),
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
                          "profile",
                          // getTranslated(context, "profile"),
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
                          // getTranslated(context, "logOut"),
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

  SharedPreference storage = SharedPreference();
  String userId;
  String userType;
  String _value = 'en';
  bool isLoading = false;
  TextEditingController businessName = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController showRoomAddress = TextEditingController();
  TextEditingController wareHouseAddress = TextEditingController();
  final SharedPreference secureStorage = SharedPreference();
  File _selectedFile;
  bool _inProcess = false;

  void _onCountryChange(CountryCode countryCode) {
    selectedCountryCode = countryCode.toString();
  }

  String selectedCountryCode = '+92';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: drawerWidget(userId),
      appBar: AppbarWidget(
        check: true,
        title: "profile",
      ),
      body: Stack(alignment: Alignment.topCenter, children: [
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
                valueColor: AlwaysStoppedAnimation<Color>(yellowColor)),
          ),
        )
            : StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .where("userId", isEqualTo: int.parse(userId))
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null)
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(yellowColor)),
                ),
              );
            return snapshot.data.documents.length == 0
                ? Container(
              child: Center(
                child: Text("Something went wrong!"),
              ),
            )
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    _inProcess == true ? CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(yellowColor)) : _displayMedia(snapshot
                        .data.documents[0]
                    ['profilePic']),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return bottomSheet(context);
                              });
                        });
                      },
                      child: Text(
                        "Edit Profile Picture",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: yellowColor),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "Edit details:",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    buildTextField(
                        snapshot.data.documents[0]['businessName'],
                        businessName,
                        "assets/icons/building2-icon.png",
                        1,
                        TextInputType.name),
                    buildTextField(
                        snapshot.data.documents[0]['firstName'],
                        firstName,
                        "assets/icons/person.png",
                        1,
                        TextInputType.name),
                    buildTextField(
                        snapshot.data.documents[0]['lastName'],
                        lastName,
                        "assets/icons/id-card.png",
                        1,
                        TextInputType.name),
                    Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            primaryColor: toastColor,
                            primaryColorDark: toastColor,
                            textSelectionTheme:
                            TextSelectionThemeData(
                                cursorColor: toastColor),
                          ),
                          child: CountryCodePicker(
                            textStyle:
                            TextStyle(color: Colors.white),
                            initialSelection: selectedCountryCode,
                            onChanged: _onCountryChange,
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            searchDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            boxDecoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(7),
                                color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: buildTextField(
                            snapshot.data.documents[0]['number'],
                            number,
                            "assets/icons/yellow-call-icon.png",
                            1,
                            TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    buildTextField(
                        snapshot.data.documents[0]
                        ['showRoomAddress'],
                        showRoomAddress,
                        "assets/icons/building1-icon.png",
                        1,
                        TextInputType.streetAddress),
                    buildTextField(
                        snapshot.data.documents[0]
                        ['wareHouseAddress'],
                        wareHouseAddress,
                        "assets/icons/warehouse.png",
                        1,
                        TextInputType.streetAddress),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedButton(
                          height: size.height * 0.06,
                          width: size.width * 0.36,
                          fontSize: size.width/20 ,
                          text: "cancel",
                          color: whiteColor,
                          textColor: accountSelectionBackgroundColor,
                          press: () {
                            Navigator.pop(context);
                          },
                        ),
                        Spacer(),
                        RoundedButton(
                          height: size.height * 0.06,
                          width: size.width * 0.36,
                          fontSize: size.width/20 ,
                          text: getTranslated(context, 'save'),
                          color: yellowColor,
                          textColor: accountSelectionBackgroundColor,
                          press: () async {
                            profileUpdateFunction(
                                snapshot.data.documents[0]
                                ['number'],
                                snapshot.data.documents[0]
                                ['lastName'],
                                snapshot.data.documents[0]
                                ['firstName'],
                                snapshot.data.documents[0]
                                ['businessName'],
                                snapshot.data.documents[0]
                                ['showRoomAddress'],
                                snapshot.data.documents[0]
                                ['wareHouseAddress']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ]),
    );
  }
  Widget _displayMedia(media) {
    print(media);
    if (media == null || media == "") {
      return Image(image: AssetImage("assets/icons/person.png",),width: 80,height: 80,);
    } else {
      return Container(
        decoration: BoxDecoration(
            color: yellowColor,
            borderRadius: BorderRadius.circular(60)),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: CircleAvatar(
            maxRadius: 60,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(media),
          ),
        ),
      );
    }
  }
  profileUpdateFunction(number1, lastName1, firstName1, businessName1,
      showRoomAddress1, wareHouseAddress1) {
    Firestore.instance
        .collection('users')
        .where("userId", isEqualTo: int.parse(userId))
        .getDocuments()
        .then((value) => {
      Firestore.instance
          .collection('users')
          .document(value.documents.first.documentID)
          .updateData({
        "businessName": businessName.text.isEmpty
            ? businessName1
            : businessName.text,
        "firstName":
        firstName.text.isEmpty ? firstName1 : firstName.text,
        "lastName": lastName.text.isEmpty ? lastName1 : lastName.text,
        "number": number.text.isEmpty
            ? number1
            : selectedCountryCode + number.text,
        "showRoomAddress": showRoomAddress.text.isEmpty
            ? showRoomAddress1
            : showRoomAddress.text,
        "wareHouseAddress": wareHouseAddress.text.isEmpty
            ? wareHouseAddress1
            : wareHouseAddress.text,
      }).then((value) => {
        businessName.clear(),
        firstName.clear(),
        lastName.clear(),
        number.clear(),
        showRoomAddress.clear(),
        wareHouseAddress.clear(),
        AuthService()
            .displayToastMessage("Profile Updated!", context),
      })
    });
  }

  Widget buildTextField(
      text, dynamic controller, icon, int lines, dynamic type) {
    return Column(
      children: [
        TextField(
          keyboardType: type,
          controller: controller,
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

  Widget bottomSheet(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 5,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          Text("choose profile photo",
              style: TextStyle(
                fontSize: 20.0,
              )),
          SizedBox(height: 20),
          Row(
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text("Camera"),
                onPressed: () {
                  getImage(ImageSource.camera, context);
                  Navigator.pop(context);
                },
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                label: Text("Gallery"),
                onPressed: () {
                  getImage(ImageSource.gallery, context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ]));
  }

  void getImage(ImageSource source, BuildContext context) async {
    setState(() {
      _inProcess = true;
    });
    final image = ImagePicker();
    final pickedFile = await image.getImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 4),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: accountSelectionBackgroundColor,
            toolbarTitle: "Crop Image",
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.white,
            activeControlsWidgetColor: accountSelectionBackgroundColor),
        iosUiSettings: IOSUiSettings(
          title: "Crop Image",
        ),
      );

      this.setState(() {
        _selectedFile = cropped;
        // _inProcess = false;
        uploadFile(_selectedFile);
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  Future uploadFile(File imageFile) async {
    final StorageReference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profilePics')
        .child('/${Path.basename(imageFile.path)}');
    final StorageUploadTask uploadTask = ref.putFile(
      io.File(imageFile.path),
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );
    uploadTask.onComplete.then((value) => {
      ref.getDownloadURL().then((fileURL) {
        setState(() {
          sendImageToDb(fileURL);
          print(fileURL);
        });
      }),
    });
  }

  sendImageToDb(url) {
    Firestore.instance
        .collection('users')
        .where("userId", isEqualTo: int.parse(userId))
        .getDocuments()
        .then((value) => {
      Firestore.instance
          .collection('users')
          .document(value.documents.first.documentID)
          .updateData({"profilePic": url}).then((value) => {
        _inProcess = false,
        AuthService()
            .displayToastMessage("Profile Picture Updated!", context),
      })
    });
  }
}