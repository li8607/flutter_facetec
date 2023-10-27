import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_facetec_platform_interface.dart';

/// An implementation of [FlutterFacetecPlatform] that uses method channels.
class MethodChannelFlutterFacetec extends FlutterFacetecPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_facetec');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> initialize(String productionKeyText, String deviceKeyIdentifier,
      String publicFaceScanEncryptionKey, String baseUrl, String token,
      {bool productionMode = false}) async {
    final result = await methodChannel.invokeMethod<bool?>('initialize', {
      "productionKeyText": productionKeyText,
      "deviceKeyIdentifier": deviceKeyIdentifier,
      "publicFaceScanEncryptionKey": publicFaceScanEncryptionKey,
      "baseUrl": baseUrl,
      "token": token,
      "productionMode": productionMode,
    });
    return result;
  }

  @override
  Future<bool?> startLiveness() async {
    final result = await methodChannel.invokeMethod<bool?>('startLiveness');
    return result;
  }

  @override
  Future<bool?> setLocale(String language, String country) async {
    final result = await methodChannel.invokeMethod<bool?>('setLocale', {
      "language": language,
      "country": country,
    });
    return result;
  }
}
