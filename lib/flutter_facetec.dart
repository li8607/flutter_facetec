
import 'flutter_facetec_platform_interface.dart';

class FlutterFacetec {
  Future<String?> getPlatformVersion() {
    return FlutterFacetecPlatform.instance.getPlatformVersion();
  }

  Future<bool?> initialize(String deviceKeyIdentifier, String publicFaceScanEncryptionKey) {
    return FlutterFacetecPlatform.instance.initialize(deviceKeyIdentifier, publicFaceScanEncryptionKey);
  }

   Future<String?> startLiveness() {
    return FlutterFacetecPlatform.instance.startLiveness();
  }
}
