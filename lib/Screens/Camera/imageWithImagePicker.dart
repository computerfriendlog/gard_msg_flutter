import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:image_picker/image_picker.dart';

import '../../Helper/Helper.dart';

class ImgePickerByCamera extends StatefulWidget {
  const ImgePickerByCamera({Key? key}) : super(key: key);

  @override
  State<ImgePickerByCamera> createState() => _ImgePickerByCameraState();
}

class _ImgePickerByCameraState extends State<ImgePickerByCamera> {
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
        child: Center(
          child: CustomButton("click imge", width, () async {
            try {
              final ImagePicker _picker = ImagePicker();
              final XFile? photo =
                  await _picker.pickImage(source: ImageSource.camera);
              Helper.msgDialog(context, photo!.path, () {
                Navigator.pop(context);
              });
            } catch (e) {
              Helper.msgDialog(context, 'exception...  ${e.toString()}', () {
                Navigator.pop(context);
              });
            }
          }),
        ),
      ),
    );
  }
}
