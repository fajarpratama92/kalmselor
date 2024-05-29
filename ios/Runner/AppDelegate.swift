import UIKit
import Flutter
// Add this line
import WonderPush
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
                 UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
             }
             GeneratedPluginRegistrant.register(with: self)
             // Add the following 5 lines
       WonderPush.setClientId("e50b5c2da3c64420ec4644d3ba9642bf30f60102", secret:"090f67bf6c65b45a1ba8aeac317a5f8885e197b1bcf9dc5abd4ea71fbd3d6f93")
             WonderPush.setupDelegate(for: application)
             if #available(iOS 10.0, *) {
                 WonderPush.setupDelegateForUserNotificationCenter()
             }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
