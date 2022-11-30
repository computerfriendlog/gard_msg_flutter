import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Models/Incident.dart';

class IncidentsRowDesign extends StatelessWidget {
  Incident? incident;

  IncidentsRowDesign({this.incident});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
