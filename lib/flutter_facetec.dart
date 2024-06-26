import 'flutter_facetec_platform_interface.dart';

class FlutterFacetec {
  Future<bool?> initialize(String productionKeyText, String deviceKeyIdentifier,
      String publicFaceScanEncryptionKey) {
    return FlutterFacetecPlatform.instance.initialize(
      productionKeyText,
      deviceKeyIdentifier,
      publicFaceScanEncryptionKey,
    );
  }

  Future<String?> startLiveness(
      String baseUrl,
      String deviceKeyIdentifier,
      String externalDatabaseRefID,
      String token,
      String successMessage,
      String stillUploading) {
    return FlutterFacetecPlatform.instance.startLiveness(
      baseUrl,
      deviceKeyIdentifier,
      externalDatabaseRefID,
      token,
      successMessage,
      stillUploading,
    );
  }

  Future<bool?> setLocale(String language, String country) {
    return FlutterFacetecPlatform.instance.setLocale(language, country);
  }

  Future<bool?> initializeInDevelopmentMode(
      String deviceKeyIdentifier, String publicFaceScanEncryptionKey) async {
    return FlutterFacetecPlatform.instance.initializeInDevelopmentMode(
        deviceKeyIdentifier, publicFaceScanEncryptionKey);
  }

  Future<String?> createFaceTecAPIUserAgentString() {
    return FlutterFacetecPlatform.instance.createFaceTecAPIUserAgentString("");
  }
}
