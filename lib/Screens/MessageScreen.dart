import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';

import '../Helper/Helper.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/MessageScreen';

  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Message',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: SizedBox(
        width: width,
        height: hight,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Helper.makePhoneCall(office_phone);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Constants.ic_phone,
                      color: Colors.grey,
                      size: 30,
                    ),
                    const SizedBox(),
                    const SizedBox(),
                    Text(
                      office_phone,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
