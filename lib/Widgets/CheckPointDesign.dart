import 'package:flutter/material.dart';
import '../Helper/Constants.dart';
import '../Models/CheckPoint.dart';

class CheckPointDesign extends StatelessWidget {
  double? width;
  CheckPoint? checkPoint;
  void Function()? function_handle;

  CheckPointDesign({this.checkPoint, this.width, this.function_handle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: function_handle,
        child: Card(
          elevation: 3,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Check call at ${checkPoint!.time!.split(' ').last}:',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: checkPoint!.status == '1'
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, right: 8, left: 8),
                      margin: const EdgeInsets.only(right: 5),
                      child: Icon(
                        checkPoint!.status == '1'
                            ? Constants.ic_tik
                            : Constants.ic_cross,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const Text(
                      'Take\nPicture ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
