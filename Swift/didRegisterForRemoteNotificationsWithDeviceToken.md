```swift
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  ...
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     // handle
     return super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
```