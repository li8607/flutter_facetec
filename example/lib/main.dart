import 'package:flutter/material.dart';

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
  final _flutterFacetecPlugin = FlutterFacetec();

  @override
  void initState() {
    super.initState();
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
            ElevatedButton(
              onPressed: () async {
                await _flutterFacetecPlugin.initializeInDevelopmentMode(
                    FaceTecConfig.deviceKeyIdentifier,
                    FaceTecConfig.publicFaceScanEncryptionKey);
              },
              child: const Text('Initialize'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _flutterFacetecPlugin.startLiveness(
                    FaceTecConfig.baseURL,
                    FaceTecConfig.deviceKeyIdentifier,
                    "testtesttest",
                    "123213");
              },
              child: const Text('startLiveness'),
            ),
          ],
        ),
      ),
    );
  }
}
