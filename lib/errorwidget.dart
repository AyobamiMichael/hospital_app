import 'package:flutter/material.dart';

class MyCustomErrorApp extends StatelessWidget {
  final FlutterErrorDetails details;

  MyCustomErrorApp({required this.details});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Error Occurred'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 20.0,
              ),
              SizedBox(height: 10.0),
              Text(
                'An error occurred:',
                style: TextStyle(fontSize: 10.0),
              ),
              SizedBox(height: 5.0),
              Text(
                '${details.exception}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              if (details.stack != null) SizedBox(height: 10.0),
              Text(
                'Stack Trace:',
                style: TextStyle(fontSize: 10.0),
              ),
              SizedBox(height: 5.0),
              Text(
                '${details.stack}',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  // You can add any logic here, e.g., navigating back
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
