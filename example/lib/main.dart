import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_facetec/flutter_facetec.dart';
import 'package:flutter_facetec_example/facetec_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterFacetecPlugin = FlutterFacetec();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterFacetecPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
              onPressed: () async {
                final result2 = await _flutterFacetecPlugin.initialize(
                  "",
                  FaceTecConfig.deviceKeyIdentifier,
                  FaceTecConfig.publicFaceScanEncryptionKey,
                  FaceTecConfig.baseURL,
                  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ3YWxsZXQiOiIweDIyMDQ1QzRENUI0ODM2ZjFGMTZkQ0NBMUE4QzJFYjdhNzkwNjQ0NDciLCJuaWNrbmFtZSI6ImFnZ2llIiwiaWQiOiI2NGRmMzJhYzhmMTU3NzU5YTczMGZmNmQiLCJleHAiOjE2OTg5NzgxOTEsImlhdCI6MTY5ODM3MzM5MSwidXNlcm5hbWUiOiJhZ2dpZSJ9.Bf6uGGgf7oJkwzCcPRQGpDzobwXUwW9m75yQW8DVN3o",
                );
                print("reuslt = $result2");
              },
              child: const Text('Initialize'),
            ),
            ElevatedButton(
              onPressed: () async {
                final reuslt = await _flutterFacetecPlugin.startLiveness();
                print("reuslt = $reuslt");
              },
              child: const Text('startLiveness'),
            ),
          ],
        ),
      ),
    );
  }
}
