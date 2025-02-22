import UIKit
import Flutter
import Libserver

// https://docs.flutter.dev/add-to-app/ios/project-setup
// https://docs.flutter.dev/platform-integration/platform-channels
@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let serverChannel = FlutterMethodChannel(name: "honmaple.com/maple_file",
                                                  binaryMessenger: controller.binaryMessenger)
        serverChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "Start":
                let args = call.arguments as? String
                var error: NSError?
                if let addr = ServerStart(args, &error) as? String {
                    result(addr)
                } else {
                    result(FlutterError(code: "GRPC", message: error.debugDescription, details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
