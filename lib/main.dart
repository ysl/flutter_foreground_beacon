import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MethodChannel methodChannel =
      MethodChannel('samples.flutter.io/battery');
  static const EventChannel eventChannel =
      EventChannel('samples.flutter.io/charging');

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final Map params = <String, dynamic>{
        'name': 'Hank',
        'age': 25,
      };
      final int? result =
          await methodChannel.invokeMethod('getBatteryLevel', params);
      batteryLevel = 'Battery level: $result%.';
    } on PlatformException {
      batteryLevel = 'Failed to get battery level.';
    }
    print('Test: batteryLevel=' + batteryLevel);
  }

  @override
  void initState() {
    super.initState();
    getPermisssion();
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  Future<void> getPermisssion() async {
    await Permission.locationAlways.request();
  }

  void _onEvent(Object? event) {
    print("Test: Battery status: ${event == 'charging' ? '' : 'dis'}charging.");
  }

  void _onError(Object error) {
    print('Test: Battery status: unknown.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Start scanning and advertising',
            ),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Get battery level'),
            )
          ],
        ),
      ),
    );
  }
}
