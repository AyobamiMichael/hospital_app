import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hospital_app/hospitalwidgets/recordeddatalist.dart';
import 'package:hospital_app/errorwidget.dart';
import 'package:provider/provider.dart';
//import 'package:hospital_app/pages/home/widget/space.dart';

class Loads extends StatefulWidget {
  const Loads({super.key});

  @override
  State<Loads> createState() => _LoadsState();
}

class _LoadsState extends State<Loads> {
  late Timer loadTimer;

  @override
  void initState() {
    super.initState();
    //loadTimer.cancel();
  }

  @override
  void dispose() {
    super.dispose();
    //loadTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PatientRecordedDataListScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue, backgroundColor: Colors.white

          // You can customize other properties like padding, shape, etc. here
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .center, // Aligns children vertically at the center

        children: [
          Icon(
            Icons.upload_file,
            size: 75,
            color: Colors.blue,
          ),
          SizedBox(height: 8),
          Text(
            "LOAD",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}

/*
class Loads extends StatelessWidget {
  const Loads({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        loadTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PatientRecordedDataListScreen()),
          );
        });
        //  loadTimer.cancel();
      },
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue, backgroundColor: Colors.white

          // You can customize other properties like padding, shape, etc. here
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment
            .center, // Aligns children vertically at the center

        children: [
          Icon(
            Icons.upload_file,
            size: 75,
            color: Colors.blue,
          ),
          SizedBox(height: 8),
          Text(
            "LOAD",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ],
      ),
    );
  }
}
*/