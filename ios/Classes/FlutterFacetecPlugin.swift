import Flutter
import UIKit
import FaceTecSDK

public class FlutterFacetecPlugin: NSObject, FlutterPlugin, URLSessionDelegate, ProcessorDelegate  {
  
  var latestSessionResult: FaceTecSessionResult!
  var latestProcessor: Processor!
  var  pendingResult: FlutterResult?
    
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
        initializeInProductionMode(productionKeyText:productionKeyText, deviceKeyIdentifier: deviceKeyIdentifier, publicFaceScanEncryptionKey: faceScanEncryptionKey, result: result)
    case "setLocale":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let language = args["language"] as? String,
              let country = args["country"] as? String?
        else {
            return result(FlutterError())
        }
        setLocale(language: language, country: country, result: result)
    case "startLiveness":
        guard let args = call.arguments as? Dictionary<String, Any>,
              let deviceKeyIdentifier = args["deviceKeyIdentifier"] as? String,
              let baseUrl = args["baseUrl"] as? String,
              let externalDatabaseRefID = args["externalDatabaseRefID"] as? String,
              let token = args["token"] as? String
        else {
            return result(FlutterError())
        }
        
        pendingResult = result
        startLiveness(baseUrl:baseUrl, deviceKeyIdentifier:deviceKeyIdentifier, externalDatabaseRefID: externalDatabaseRefID, token:token, result: result);
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
    
    private func setLocale(language: String, country: String?, result: @escaping FlutterResult) {
        if(country==nil) {
            FaceTec.sdk.setLanguage(language)
        } else {
            FaceTec.sdk.setLanguage(language + "-" + country!)
        }
        result(true)
    }
    
    private func initializeInProductionMode(productionKeyText: String, deviceKeyIdentifier: String, publicFaceScanEncryptionKey: String, result: @escaping FlutterResult) {
        
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
    
    private func startLiveness(baseUrl: String, deviceKeyIdentifier: String, externalDatabaseRefID: String, token: String, result: @escaping FlutterResult) {
        // Get a Session Token from the FaceTec SDK, then start the 3D Liveness Check.
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            getSessionToken(baseUrl:baseUrl, deviceKeyIdentifier:deviceKeyIdentifier, token:token) { sessionToken in
                self.latestProcessor = LivenessCheckProcessor(baseUrl: baseUrl, deviceKeyIdentifier: deviceKeyIdentifier, externalDatabaseRefID:externalDatabaseRefID, sessionToken: sessionToken, token: token, fromViewController: rootViewController, delegate: self)
            }
        } else {
            result(FlutterError(code: "view not found", message: "view not found", details: nil))
        }
    }
    
    func onProcessingComplete(isSuccess: Bool, faceTecSessionResult: FaceTecSessionResult?, errorMsg: String?) {
        if(pendingResult != nil && faceTecSessionResult != nil) {
            if(isSuccess){
                var faceScan = faceTecSessionResult!.faceScanBase64
                pendingResult!(faceScan)
            }else{
                pendingResult!(FlutterError(code: "view not found", message: "view not found", details: nil))
            }
        }
    }
    
    func getSessionToken(baseUrl: String, deviceKeyIdentifier: String, token: String, sessionTokenCallback: @escaping (String) -> ()) {
        let endpoint = baseUrl + "/session-token"
        let request = NSMutableURLRequest(url: NSURL(string: endpoint)! as URL)
        request.httpMethod = "GET"
        // Required parameters to interact with the FaceTec Managed Testing API.
        request.addValue(deviceKeyIdentifier, forHTTPHeaderField: "X-Device-Key")
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString(""), forHTTPHeaderField: "User-Agent")
        request.addValue(FaceTec.sdk.createFaceTecAPIUserAgentString(""), forHTTPHeaderField: "X-User-Agent")
        request.addValue(token, forHTTPHeaderField: "token")

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
