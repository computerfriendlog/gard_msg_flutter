import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController _controller;
  final String hint, label;
  final double _width;
  final TextInputType keyboardType;

  CustomTextField(
      this._width, this.hint, this.label, this.keyboardType, this._controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      margin: const EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          TextFormField(
            cursorColor: Colors.white,
            controller: _controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: InputDecoration(
                fillColor: Colors.white.withOpacity(0.6),
                filled: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  borderSide: BorderSide(color: Color(0xff8d62d6), width: 3.0),
                ),
                contentPadding: const EdgeInsets.all(10),
                hintText: hint,
                hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontWeight: FontWeight.w300)
                //labelText: hint,
                ),
          ),
        ],
      ),
    );
  }
}
