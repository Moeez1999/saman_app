import 'package:flutter/material.dart';

const primaryColor = Color(0xFF1B5E20);//
const primaryLightColor = Color(0xFFC8E6C9);
const primaryDarkerLighterColor = Color(0xFFA5D6A7);
const accountSelectionBackgroundColor = Color(0xFF02B773);
const selectedColor = Color(0xFF1B8444);
const drawerColor = Color(0xff00A468);

const driverRegistrationBackgroundColor = Color(0xFF00784C);
const businessHomepageColor = Color(0xFF005D3B);
const Color toastColor = Color(0xFF1B5E20);
const Color yellowColor = Color(0xFFFEE802);
const Color selectedColorVehicle = Color(0xff00B774);
const Color languageSelectColor = Color(0xffD2C221);
const Color greenDark = Color(0xFF007B4E);
const Color greenLight = Color(0xFF00784C);
const Color blueColor=Color(0xFF3B5999);
const Color textBoxColor = Color(0xFF348F6E);
const Color skyBlueColor = Color(0xFF01A7D0);
const Color whiteColor = Color(0xFFFFFFFF);
const Color backButtonColor = Color(0xFF01A5D3);
const Color driverScreenDirectionButton = Color(0xFF0FDAD3);

const TextStyle ktextsmall = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);
const TextStyle ktextmedium = TextStyle(
  fontSize: 23.0,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

// urls for Google Places API
var urlPlaceAPI =
    "https://maps.googleapis.com/maps/api/place/autocomplete/json";
var urlPlaceDetailsAPI =
    "https://maps.googleapis.com/maps/api/place/details/json";
//api key
String kPLACES_API_KEY = "AIzaSyC3PcQErVp_pXff99I8WMF_A6IionYOtbY";
//center of Lahore
double pointOfSearchLat = 31.504044999531175;
double pointOfSearchLon = 74.33637675420063;

//restrict place request by radius(meters) around center of Lahore
var searchRadius = 28000;
// Place names restriction in placeAPI
var placeType = "(regions)";


//icons

const PERSON_ICON = 'assets/icons/person.png';
const ID_CARD_ICON = 'assets/icons/id-card.png';
const TELEPHONE_ICON = 'assets/icons/yellow-call-icon.png';
const LANGUAGE_ICON = 'assets/icons/language-icon.png';
const DRIVING_LICENSE_ICON = 'assets/icons/driving-license.png';