import Flutter
import UIKit
import SwiftDate

public class SwiftBzPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bz_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftBzPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
    case "isToday":
        isToday(call, result)
    default:
        result(nil)
    }
  }
  
   private func isToday(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! Dictionary<String, Any>
        let dateTime = arguments["dateTime"] as! String;
        // Convert to local
        let localDate = dateTime.toDate(nil, region: Region.current)
        // Check isToday
        let checkToday = localDate?.isToday
        result(checkToday)
    }
}
