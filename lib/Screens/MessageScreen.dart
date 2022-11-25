import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';

import '../APIs/RestClient.dart';
import '../Helper/Helper.dart';
import '../Models/Message.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/MessageScreen';

  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final restClient = RestClient();
  bool isLoding = true;
  List<Message>? msg_list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSms();
  }

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

  void loadSms() async {
    print('getting sms list start');
    final parameters = {
      'type': Constants.MESSAGE_LIST,
      'office_name': officeName,
      'guard_id': gard_id,
      'device_type': deviceType
    };

    final respose = await restClient.post(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);
    print('sms list response is here     ${respose.data}');

    //Navigator.pop(context);
  }
}
