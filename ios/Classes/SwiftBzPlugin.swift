import Flutter
import UIKit
import BVSwift

public class SwiftBzPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bz_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftBzPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     switch call.method {
     case "init":
         initPlugin(call, result)
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "BVPageViewEvent":
        BVPageViewEvent(call, result)
    default:
        result(nil)
    }
  }
    
 private func initPlugin(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
     let arguments = call.arguments as! Dictionary<String, Any>
     let clientId = arguments["clientId"] as! String
     let passkey = arguments["passkey"] as! String
     
     let config: BVConversationsConfiguration =
       { () -> BVConversationsConfiguration in
      
         let analyticsConfig: BVAnalyticsConfiguration = .configuration(locale: Locale(identifier: "sg"), configType: .production(clientId: clientId))
      
         return BVConversationsConfiguration.all(
           clientKey: passkey,
           configType: .production(clientId: clientId),
           analyticsConfig: analyticsConfig)
       }()
     
     BVManager.sharedManager.addConfiguration(config)
 }
  
  private func BVPageViewEvent(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
      let arguments = call.arguments as! Dictionary<String, Any>
      let productId = arguments["productId"] as! String
      let category = arguments["category"] as! String
      
      
    let pageView: BVAnalyticsEvent =
                      .pageView(
                          bvProduct: .reviews,
                          productId: productId,
                          brand: "brandName",
                          categoryId: category,
                          rootCategoryId: "rootCategoryId",
                          additional: nil)
    BVPixel.track(pageView)
  }
    
    private func BVConversionEvent(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let category = arguments["category"] as! String
    
        let conversion: BVAnalyticsEvent =
            .conversion(
                type: "CategoryClick",
                value: category,
                label: "",
                additional: [:])
        BVPixel.track(conversion)
    }
}
