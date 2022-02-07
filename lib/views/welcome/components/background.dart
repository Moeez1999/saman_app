import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final int index;
  const Background({
     this.child,
     this.index
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(child:
            Image.asset(
            index == 1 ? 'assets/icons/sp-screen.png':  'assets/icons/background.png',
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,),
            ),
            // LanguageButton(),

            child,

          ],

        ),
      ),
    );
  }
}
