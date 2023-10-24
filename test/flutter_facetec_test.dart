import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_facetec/flutter_facetec.dart';
import 'package:flutter_facetec/flutter_facetec_platform_interface.dart';
import 'package:flutter_facetec/flutter_facetec_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFacetecPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFacetecPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFacetecPlatform initialPlatform = FlutterFacetecPlatform.instance;

  test('$MethodChannelFlutterFacetec is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFacetec>());
  });

  test('getPlatformVersion', () async {
    FlutterFacetec flutterFacetecPlugin = FlutterFacetec();
    MockFlutterFacetecPlatform fakePlatform = MockFlutterFacetecPlatform();
    FlutterFacetecPlatform.instance = fakePlatform;

    expect(await flutterFacetecPlugin.getPlatformVersion(), '42');
  });
}
