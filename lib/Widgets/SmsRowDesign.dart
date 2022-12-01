import 'package:flutter/material.dart';
import '../Helper/Constants.dart';
import '../Models/Message.dart';

class SmsRowDesign extends StatelessWidget {
  Message? message;

  SmsRowDesign({this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message!.from_type == 'Driver'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child:
          /*Card(
          elevation: 3,
          child:  Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize:MainAxisSize.min,
              children: [
                Text(message!.msg_text!,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 14,color: Colors.black.withOpacity(0.8)),),
                Row(
                  mainAxisSize:MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize:MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(message!.date!,style: const  TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.black),),
                        message!.from_type !='Driver'? Container(): Icon(Constants.ic_tik,size: 20,color: message!.viewed=='1'? Theme.of(context).primaryColor :Colors.grey,)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )*/

          Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
            topRight: message!.from_type == 'Operator'
                ? const Radius.circular(20)
                : const Radius.circular(0),
            topLeft: message!.from_type == 'Driver'
                ? const Radius.circular(20)
                : const Radius.circular(0),
          ),
          color: Constants.grey.withOpacity(0.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
                alignment: message!.from_type == 'Driver'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  message!.msg_text!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.8)),
                )),
            Align(
              alignment: message!.from_type == 'Driver'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message!.date!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Colors.black),
                  ),
                  message!.from_type != 'Driver'
                      ? Container()
                      : Icon(
                          Constants.ic_tik,
                          size: 20,
                          color: message!.viewed == '1'
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
    //);
  }
}
