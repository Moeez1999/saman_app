import 'package:flutter/material.dart';
import 'package:saman/constants.dart';
import 'package:saman/components/language_button.dart';


class AppbarWidget extends StatelessWidget implements PreferredSizeWidget{
final String title;
final bool check;
   AppbarWidget({this.title, this.check});
@override
Size get preferredSize => const Size.fromHeight(55);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        actions: [
          check == true ?   LanguageButton() : Container()
        ],
        title: Text(
          title,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: yellowColor),
        backgroundColor: selectedColorVehicle);
  }
}

