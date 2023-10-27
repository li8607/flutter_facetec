import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_facetec_method_channel.dart';

abstract class FlutterFacetecPlatform extends PlatformInterface {
  /// Constructs a FlutterFacetecPlatform.
  FlutterFacetecPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFacetecPlatform _instance = MethodChannelFlutterFacetec();

  /// The default instance of [FlutterFacetecPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFacetec].
  static FlutterFacetecPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFacetecPlatform] when
  /// they register themselves.
  static set instance(FlutterFacetecPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> initialize(String productionKeyText, String deviceKeyIdentifier, String publicFaceScanEncryptionKey, String baseUrl, String token, {bool productionMode = false}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<bool?> startLiveness() {
    throw UnimplementedError('startLiveness() has not been implemented.');
  }
}
