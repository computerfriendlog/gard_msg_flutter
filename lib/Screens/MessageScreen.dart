import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';
import 'package:gard_msg_flutter/Widgets/CustomTextField.dart';
import 'package:gard_msg_flutter/Widgets/SmsRowDesign.dart';
import '../APIs/RestClient.dart';
import '../Helper/Helper.dart';
import '../Models/Message.dart';
import '../Widgets/JobsDesign.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/MessageScreen';

  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final restClient = RestClient();
  bool isLoding = true;
  List<Message> msg_list = [];
  TextEditingController _controller_msg =TextEditingController();

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
        actions: [
          InkWell(
            onTap: () {
              Helper.makePhoneCall(office_phone);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 5,right: 5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Constants.ic_phone,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    office_phone,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: width,
        height: hight,
        child: Column(
          children: [
            Expanded(
              child: !isLoding
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: msg_list.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return SmsRowDesign(
                          message: msg_list[index],
                        );
                      },
                    )
                  : Helper.LoadingWidget(context),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width*0.82,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        controller: _controller_msg,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                        decoration: InputDecoration(
                            fillColor: Colors.white.withOpacity(0.6),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                              borderSide: BorderSide(color: Color(0xff8d62d6), width: 3.0),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Enter text here',
                            hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.8),
                                fontWeight: FontWeight.w300)
                          //labelText: hint,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: width*0.14,
                        child: TextButton(onPressed: ()async{
                          if( _controller_msg.text.trim().isNotEmpty){
                            await APICalls.sendSmsViaApp(context, _controller_msg.text.trim());
                            _controller_msg.text='';
                            loadSms();
                          }else{
                            Helper.Toast('Enter text', Constants.toast_grey);
                          }

                        }, child: const Icon(Icons.send_rounded,color: Colors.black,size: 30,)))
                  ],
                ),
              ],
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
    msg_list.clear();
    if (respose.data['RESULT'] == 'OK') {
      respose.data['DATA'].forEach((value) {
        msg_list.add(Message(
            job_id: value['job_id'],
            id: value['id'],
            attachment: value['attachment'],
            created: value['created'],
            date: value['date'],
            device_type: value['device_type'],
            from_type: value['from_type'],
            from_user_id: value['from_user_id'],
            msg_text: value['msg_text'],
            read_msg: value['read_msg'],
            team_id: value['team_id'],
            to_type: value['to_type'],
            to_user_id: value['to_user_id'],
            type: value['type'],
            viewed: value['viewed'],
            voice_msg_file: value['voice_msg_file']));
      });
      isLoding = false;
      setState(() {});
    }

    //Navigator.pop(context);
  }
}
