import UIKit
import Flutter
import Libserver

// https://docs.flutter.dev/add-to-app/ios/project-setup
// https://docs.flutter.dev/platform-integration/platform-channels
@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

        let serverChannel = FlutterMethodChannel(
            name: "honmaple.com/maple_file",
            binaryMessenger: engineBridge.applicationRegistrar.messenger()
        )
        serverChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "Start":
                let args = call.arguments as? String
                var error: NSError?
                let response = ServerStart(args, &error)
                guard error == nil, !response.isEmpty else {
                    result(FlutterError(code: "GRPC",
                                        message: error?.localizedDescription ?? "Server returned an empty startup response",
                                        details: nil))
                    return
                }
                result(response)
            case "Stop":
                ServerStop()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
}
