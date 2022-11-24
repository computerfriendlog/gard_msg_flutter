import 'package:flutter/material.dart';

class BoxForHome extends StatelessWidget {
  var hight_box, width_box;
  Color backgroundColor = Colors.red;
  String lableText = '';
  String picture = 'assets/images/logo.svg';

  BoxForHome(
      {required this.width_box,
      required this.hight_box,
      required this.lableText,
      required this.picture});

  @override
  Widget build(BuildContext context) {
    backgroundColor = Theme.of(context).primaryColor;
    return Container(
      width: width_box,
      height: hight_box,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        color: backgroundColor,
        borderOnForeground: true,
        elevation: 5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: hight_box * 0.5,
                width: width_box * 0.7,
                child: Image.asset(
                    picture)),
            Text(
              lableText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w100,
                color: Colors.white,
              ), //_width * .1 font size
            ),
          ],
        ),
      ),
    );
  }
}
