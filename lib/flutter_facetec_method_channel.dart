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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
