import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String lable;
  final void Function()? _function_handler;
  final double width;

  CustomButton(this.lable, this.width, this._function_handler);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
              fontWeight: FontWeight.w800, fontSize: 16), 
        ),
        onPressed: _function_handler,
        child: Text(
          lable,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
    );
  }
}
