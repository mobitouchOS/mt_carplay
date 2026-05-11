import Flutter

@objc(FlutterCarplayPlugin)
public class FlutterCarplayPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    if #available(iOS 14.0, *) {
      SwiftFlutterCarplayPlugin.register(with: registrar)
    }
  }
}
