import 'package:flutter/material.dart';
class RequestRowDesign extends StatelessWidget {
  const RequestRowDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        /*  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                incident!.incident_type!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                incident!.id!,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                incident!.notes!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                incident!.job_id!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Colors.black),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
