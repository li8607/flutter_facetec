import Flutter
import UIKit
import FaceTecSDK

public class FlutterFacetecPlugin: NSObject, FlutterPlugin, FaceTecFaceScanProcessorDelegate  {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_facetec", binaryMessenger: registrar.messenger())
    let instance = FlutterFacetecPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "initialize":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let deviceKeyIdentifier = args["deviceKeyIdentifier"] as? String,
              let faceScanEncryptionKey = args["publicFaceScanEncryptionKey"] as? String
        else {
            return result(FlutterError())
            }
        return initialize(deviceKeyIdentifier: deviceKeyIdentifier, publicFaceScanEncryptionKey: faceScanEncryptionKey, result: result);
    case "startLiveness":
        return startLiveness(result: result);
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    private func initialize(deviceKeyIdentifier: String, publicFaceScanEncryptionKey: String, result: @escaping FlutterResult) {
        
        var ftCustomization = FaceTecCustomization()
//        ftCustomization.overlayCustomization.brandingImage = UIImage(named: "flutter_logo")
        FaceTec.sdk.setCustomization(ftCustomization)
        
        FaceTec.sdk.initializeInDevelopmentMode(deviceKeyIdentifier: deviceKeyIdentifier, faceScanEncryptionKey: publicFaceScanEncryptionKey, completion: { initializationSuccessful in
            if (initializationSuccessful) {
                result(true)
            }
            else {
                let statusStr = FaceTec.sdk.description(for: FaceTec.sdk.getStatus())
                result(FlutterError(code: "InitError", message: statusStr, details: nil))
            }
        })
    }
    
    private func startLiveness(result: @escaping FlutterResult) {
//         let livenessCheckViewController = FaceTec.sdk.createSessionVC(faceScanProcessorDelegate: self)
//         let controller: FlutterViewController = window?.rootViewController as! FlutterViewController;
//         controller.present(livenessCheckViewController, animated: true, completion: nil)
     }
    
    // FaceTecFaceScanProcessorDelegate method
    public func processSessionWhileFaceTecSDKWaits(sessionResult: FaceTecSessionResult, faceScanResultCallback: FaceTecFaceScanResultCallback) {
         fatalError("FaceTecSDK: This needs to be implemented")
     }
     
     // FaceTecFaceScanProcessorDelegate method
    public func onFaceTecSDKCompletelyDone() {
         fatalError("FaceTecSDK: This needs to be implemented")
     }
}
