import Flutter
import UIKit
import FaceTecSDK

public class FlutterFacetecPlugin: NSObject, FlutterPlugin, URLSessionDelegate  {
    
    
  var latestSessionResult: FaceTecSessionResult!
  var latestProcessor: Processor!
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_facetec", binaryMessenger: registrar.messenger())
    let instance = FlutterFacetecPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let deviceKeyIdentifier = args["deviceKeyIdentifier"] as? String,
              let faceScanEncryptionKey = args["publicFaceScanEncryptionKey"] as? String,
              let productionKeyText = args["productionKeyText"] as? String
        else {
            return result(FlutterError())
        }
        initializeInDevelopmentMode(productionKeyText:productionKeyText, deviceKeyIdentifier: deviceKeyIdentifier, publicFaceScanEncryptionKey: faceScanEncryptionKey, result: result)
    case "setLocale":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let language = args["language"] as? String,
              let _ = args["country"] as? String?
        else {
            return result(FlutterError())
        }
        setLocale(language: language, result: result)
    case "startLiveness":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let deviceKeyIdentifier = args["deviceKeyIdentifier"] as? String,
              let baseUrl = args["baseUrl"] as? String
        else {
            return result(FlutterError())
        }
        return startLiveness(baseUrl:baseUrl, deviceKeyIdentifier:deviceKeyIdentifier, result: result);
    case "initializeInDevelopmentMode":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let deviceKeyIdentifier = args["deviceKeyIdentifier"] as? String,
              let faceScanEncryptionKey = args["publicFaceScanEncryptionKey"] as? String
        else {
            return result(FlutterError())
        }
        initializeInDevelopmentMode(deviceKeyIdentifier: deviceKeyIdentifier, publicFaceScanEncryptionKey: faceScanEncryptionKey, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    private func setLocale(language: String, result: @escaping FlutterResult) {
        FaceTec.sdk.setLanguage(language)
        result(true)
    }
    
    private func initializeInDevelopmentMode(productionKeyText: String, deviceKeyIdentifier: String, publicFaceScanEncryptionKey: String, result: @escaping FlutterResult) {
        
        var ftCustomization = FaceTecCustomization()
        ftCustomization.overlayCustomization.brandingImage = UIImage(named: "flutter_logo")
        FaceTec.sdk.setCustomization(ftCustomization)
        FaceTec.sdk.initializeInProductionMode(productionKeyText: productionKeyText, deviceKeyIdentifier: deviceKeyIdentifier, faceScanEncryptionKey: publicFaceScanEncryptionKey, completion: { initializationSuccessful in
            if (initializationSuccessful) {
                result(true)
            }
            else {
                let statusStr = FaceTec.sdk.description(for: FaceTec.sdk.getStatus())
                result(FlutterError(code: "InitError", message: statusStr, details: nil))
            }
        })
    }
    
    private func initializeInDevelopmentMode(deviceKeyIdentifier: String, publicFaceScanEncryptionKey: String, result: @escaping FlutterResult) {
        
        var ftCustomization = FaceTecCustomization()
        ftCustomization.overlayCustomization.brandingImage = UIImage(named: "flutter_logo")
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
    
    private func startLiveness(baseUrl: String, deviceKeyIdentifier: String, result: @escaping FlutterResult) {
        // Get a Session Token from the FaceTec SDK, then start the 3D Liveness Check.
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            getSessionToken(baseUrl:baseUrl, deviceKeyIdentifier:deviceKeyIdentifier) { sessionToken in
                self.latestProcessor = LivenessCheckProcessor(baseUrl: baseUrl, deviceKeyIdentifier: deviceKeyIdentifier, sessionToken: sessionToken, fromViewController: rootViewController)
            }
        } else {
            print("view not found")
        }
    }
    
    func getSessionToken(baseUrl: String, deviceKeyIdentifier: String, sessionTokenCallback: @escaping (String) -> ()) {
        let endpoint = baseUrl + "/session-token"
        let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL)
        request.httpMethod = "GET"
        // Required parameters to interact with the FaceTec Managed Testing API.
        request.addValue(deviceKeyIdentifier, forHTTPHeaderField: "X-Device-Key")
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString(""), forHTTPHeaderField: "User-Agent")
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString(""), forHTTPHeaderField: "X-User-Agent")

        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            // Ensure the data object is not nil otherwise callback with empty dictionary.
            guard let data = data else {
                print("Exception raised while attempting HTTPS call 1.")
                return
            }
            if let responseJSONObj = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] {
                if((responseJSONObj["sessionToken"] as? String) != nil) {
                    sessionTokenCallback(responseJSONObj["sessionToken"] as! String)
                    return
                } else {
                    print("Exception raised while attempting HTTPS call 2. \(responseJSONObj)")
                }
            }
        })
        task.resume()
    }
}
