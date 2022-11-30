import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String lable;
  final void Function()? _function_handler;
  final double width;
  Color? background;

  CustomButton(this.lable, this.width, this._function_handler,
      {this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              background ?? Theme.of(context).primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
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
