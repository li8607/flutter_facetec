import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_facetec_platform_interface.dart';

/// An implementation of [FlutterFacetecPlatform] that uses method channels.
class MethodChannelFlutterFacetec extends FlutterFacetecPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_facetec');

  @override
  Future<bool?> initialize(String productionKeyText, String deviceKeyIdentifier,
      String publicFaceScanEncryptionKey) async {
    final result = await methodChannel.invokeMethod<bool?>('initialize', {
      "productionKeyText": productionKeyText,
      "deviceKeyIdentifier": deviceKeyIdentifier,
      "publicFaceScanEncryptionKey": publicFaceScanEncryptionKey,
    });
    return result;
  }

  @override
  Future<String?> startLiveness(String baseUrl, String deviceKeyIdentifier,
      String externalDatabaseRefID, String token, String successMessage) async {
    final result = await methodChannel.invokeMethod<String?>('startLiveness', {
      "baseUrl": baseUrl,
      "deviceKeyIdentifier": deviceKeyIdentifier,
      "externalDatabaseRefID": externalDatabaseRefID,
      "token": token,
      "successMessage": successMessage,
    });
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

  @override
  Future<bool?> initializeInDevelopmentMode(
      String deviceKeyIdentifier, String publicFaceScanEncryptionKey) async {
    final result =
        await methodChannel.invokeMethod<bool?>('initializeInDevelopmentMode', {
      "deviceKeyIdentifier": deviceKeyIdentifier,
      "publicFaceScanEncryptionKey": publicFaceScanEncryptionKey,
    });
    return result;
  }
}
