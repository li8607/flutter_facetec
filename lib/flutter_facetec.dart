import 'flutter_facetec_platform_interface.dart';

class FlutterFacetec {
  Future<String?> getPlatformVersion() {
    return FlutterFacetecPlatform.instance.getPlatformVersion();
  }

  Future<bool?> initialize(String productionKeyText, String deviceKeyIdentifier,
      String publicFaceScanEncryptionKey, String baseUrl, String token,
      {bool productionMode = false}) {
    return FlutterFacetecPlatform.instance.initialize(productionKeyText,
        deviceKeyIdentifier, publicFaceScanEncryptionKey, baseUrl, token,
        productionMode: productionMode);
  }

  Future<bool?> startLiveness() {
    return FlutterFacetecPlatform.instance.startLiveness();
  }

  Future<bool?> setLocale(String language, String country) {
    return FlutterFacetecPlatform.instance.setLocale(language, country);
  }
}
