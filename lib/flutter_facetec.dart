
import 'flutter_facetec_platform_interface.dart';

class FlutterFacetec {
  Future<String?> getPlatformVersion() {
    return FlutterFacetecPlatform.instance.getPlatformVersion();
  }
}
