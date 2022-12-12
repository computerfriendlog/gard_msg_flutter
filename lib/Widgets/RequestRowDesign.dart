import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Models/GaurdRequest.dart';

class RequestRowDesign extends StatelessWidget {
  GaurdRequest? request;

  RequestRowDesign({this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 30, left: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              request!.label == 'T'
                  ? 'Time Off'
                  : request!.label == 'H'
                      ? 'Holiday'
                      : "other",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request!.from_date!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Colors.black),
              ),
              Text(
                request!.to_date!,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                request!.start_time!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Colors.black),
              ),
              Text(
                request!.end_time!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Colors.black),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                request!.approval_status!,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w100,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
