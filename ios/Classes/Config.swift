//
// FaceTec Device SDK config file.
// Auto-generated via the FaceTec SDK Configuration Wizard
//
import UIKit
import Foundation
import FaceTecSDK

class Config {
    
    // -------------------------------------
    // This app can modify the customization to demonstrate different look/feel preferences
    // NOTE: This function is auto-populated by the FaceTec SDK Configuration Wizard based on your UI Customizations you picked in the Configuration Wizard GUI.
    public static func retrieveConfigurationWizardCustomization() -> FaceTecCustomization {
        
        
        // For Color Customization
        let outerBackgroundColor = UIColor(hexString: "#ffffff")!
        let frameColor = UIColor(hexString: "#ffffff")!
        let borderColor = UIColor(hexString: "#ffffff")!
        let ovalColor = UIColor(hexString: "#232429")!
        let dualSpinnerColor = UIColor(hexString: "#232429")!
        let textColor = UIColor(hexString: "#232429")!
        let buttonAndFeedbackBarColor =  UIColor(hexString: "#12a14b")!
        let buttonAndFeedbackBarTextColor = UIColor(hexString: "#ffffff")!
        let buttonColorHighlight =  UIColor(hexString: "#0b6f33")!
        let buttonColorDisabled =  UIColor(hexString: "#B9CCDE")!
        let feedbackBackgroundLayer = CAGradientLayer.init()
        feedbackBackgroundLayer.colors = [buttonAndFeedbackBarColor.cgColor, buttonAndFeedbackBarColor.cgColor]
        feedbackBackgroundLayer.locations = [0,1]
        feedbackBackgroundLayer.startPoint = CGPoint.init(x: 0, y: 0)
        feedbackBackgroundLayer.endPoint = CGPoint.init(x: 1, y: 0)
        
        // For Frame Corner Radius Customization
        let frameCornerRadius: Int32 = 20

        let cancelImage = UIImage(named: "FaceTec_cancel")
        let cancelButtonLocation: FaceTecCancelButtonLocation = .topLeft

        // For image Customization
        let yourAppLogoImage = UIImage(named: "FaceTec_your_app_logo")
        let securityWatermarkImage: FaceTecSecurityWatermarkImage = .faceTec
        
        // Set a default customization
        let defaultCustomization = FaceTecCustomization()

        
        // Set Frame Customization
        defaultCustomization.frameCustomization.cornerRadius = frameCornerRadius
        defaultCustomization.frameCustomization.backgroundColor = frameColor
        defaultCustomization.frameCustomization.borderColor = borderColor

        // Set Overlay Customization
        defaultCustomization.overlayCustomization.brandingImage = yourAppLogoImage
        defaultCustomization.overlayCustomization.backgroundColor = outerBackgroundColor

        // Set Guidance Customization
        defaultCustomization.guidanceCustomization.backgroundColors = [frameColor, frameColor]
        defaultCustomization.guidanceCustomization.foregroundColor = textColor
        defaultCustomization.guidanceCustomization.buttonBackgroundNormalColor = buttonAndFeedbackBarColor
        defaultCustomization.guidanceCustomization.buttonBackgroundDisabledColor = buttonColorDisabled
        defaultCustomization.guidanceCustomization.buttonBackgroundHighlightColor = buttonColorHighlight
        defaultCustomization.guidanceCustomization.buttonTextNormalColor = buttonAndFeedbackBarTextColor
        defaultCustomization.guidanceCustomization.buttonTextDisabledColor = buttonAndFeedbackBarTextColor
        defaultCustomization.guidanceCustomization.buttonTextHighlightColor = buttonAndFeedbackBarTextColor
        defaultCustomization.guidanceCustomization.retryScreenImageBorderColor = borderColor
        defaultCustomization.guidanceCustomization.retryScreenOvalStrokeColor = borderColor

        // Set Oval Customization
        defaultCustomization.ovalCustomization.strokeColor = ovalColor
        defaultCustomization.ovalCustomization.progressColor1 = dualSpinnerColor
        defaultCustomization.ovalCustomization.progressColor2 = dualSpinnerColor

        // Set Feedback Customization
        defaultCustomization.feedbackCustomization.backgroundColor = feedbackBackgroundLayer
        defaultCustomization.feedbackCustomization.textColor = buttonAndFeedbackBarTextColor

        // Set Cancel Customization
        defaultCustomization.cancelButtonCustomization.customImage = cancelImage
        defaultCustomization.cancelButtonCustomization.location = cancelButtonLocation

        // Set Result Screen Customization
        defaultCustomization.resultScreenCustomization.backgroundColors = [frameColor, frameColor]
        defaultCustomization.resultScreenCustomization.foregroundColor = textColor
        defaultCustomization.resultScreenCustomization.activityIndicatorColor = buttonAndFeedbackBarColor
        defaultCustomization.resultScreenCustomization.resultAnimationBackgroundColor = buttonAndFeedbackBarColor
        defaultCustomization.resultScreenCustomization.resultAnimationForegroundColor = buttonAndFeedbackBarTextColor
        defaultCustomization.resultScreenCustomization.uploadProgressFillColor = buttonAndFeedbackBarColor
        
        // Set Security Watermark Customization
        defaultCustomization.securityWatermarkImage = securityWatermarkImage

        // Set ID Scan Customization
        defaultCustomization.idScanCustomization.selectionScreenBackgroundColors = [frameColor, frameColor]
        defaultCustomization.idScanCustomization.selectionScreenForegroundColor = textColor
        defaultCustomization.idScanCustomization.reviewScreenBackgroundColors = [frameColor, frameColor]
        defaultCustomization.idScanCustomization.reviewScreenForegroundColor = buttonAndFeedbackBarTextColor
        defaultCustomization.idScanCustomization.reviewScreenTextBackgroundColor = buttonAndFeedbackBarColor
        defaultCustomization.idScanCustomization.captureScreenForegroundColor = buttonAndFeedbackBarTextColor
        defaultCustomization.idScanCustomization.captureScreenTextBackgroundColor = buttonAndFeedbackBarColor
        defaultCustomization.idScanCustomization.buttonBackgroundNormalColor = buttonAndFeedbackBarColor
        defaultCustomization.idScanCustomization.buttonBackgroundDisabledColor = buttonColorDisabled
        defaultCustomization.idScanCustomization.buttonBackgroundHighlightColor = buttonColorHighlight
        defaultCustomization.idScanCustomization.buttonTextNormalColor = buttonAndFeedbackBarTextColor
        defaultCustomization.idScanCustomization.buttonTextDisabledColor = buttonAndFeedbackBarTextColor
        defaultCustomization.idScanCustomization.buttonTextHighlightColor = buttonAndFeedbackBarTextColor
        defaultCustomization.idScanCustomization.captureScreenBackgroundColor = frameColor
        defaultCustomization.idScanCustomization.captureFrameStrokeColor = borderColor

        
        return defaultCustomization
    }
    
    
    public static func retrieveLowLightConfigurationWizardCustomization() -> FaceTecCustomization { 
        return retrieveConfigurationWizardCustomization()
    }
    
        
    public static func retrieveDynamicDimmingConfigurationWizardCustomization() -> FaceTecCustomization {
        return retrieveConfigurationWizardCustomization()
    }
    
    
    static var currentCustomization: FaceTecCustomization = retrieveConfigurationWizardCustomization()
    static var currentLowLightCustomization: FaceTecCustomization = retrieveLowLightConfigurationWizardCustomization()
    static var currentDynamicDimmingCustomization: FaceTecCustomization = retrieveDynamicDimmingConfigurationWizardCustomization()
    
    // -------------------------------------
    // Boolean to indicate the FaceTec SDK Configuration Wizard was used to generate this file.
    // In this Sample App, if this variable is true, a "Config Wizard Theme" will be added to this App's Design Showcase,
    // and choosing this option will set the FaceTec SDK UI/UX Customizations to the Customizations that you selected in the
    // Configuration Wizard.
    static let wasSDKConfiguredWithConfigWizard = true

}

extension UIColor {
   public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat

        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
