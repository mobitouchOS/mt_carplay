//
//  FCPStreamHandlerPlugin.swift
//  mt_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

import Flutter

@available(iOS 14.0, *)
class FCPStreamHandlerPlugin: NSObject, FlutterStreamHandler {
  private static var eventSink: FlutterEventSink?

  /// The most recent CarPlay connection status, kept for late listeners.
  ///
  /// CarPlay can launch the app with only its own scene connected. The scene
  /// connects before Dart subscribes to this channel, so the `connected` event
  /// would be dropped and Dart would never learn that CarPlay is up. It is
  /// replayed from `onListen` instead.
  private static var lastConnectionStatus: String?

  public required init(registrar: FlutterPluginRegistrar) {
    super.init()
    let eventChannel = FlutterEventChannel(
      name: makeFCPChannelId(event: "/event"),
      binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(self)
    return
  }

  public func onListen(
    withArguments arguments: Any?,
    eventSink: @escaping FlutterEventSink
  ) -> FlutterError? {
    FCPStreamHandlerPlugin.eventSink = eventSink
    if let status = FCPStreamHandlerPlugin.lastConnectionStatus {
      FCPStreamHandlerPlugin.sendEvent(
        type: FCPChannelTypes.onCarplayConnectionChange, data: ["status": status])
    }
    return nil
  }

  public func sendCarplayConnectionChangeEvent(status: String) {
    FCPStreamHandlerPlugin.sendEvent(
      type: FCPChannelTypes.onCarplayConnectionChange, data: ["status": status])
  }

  public static func sendEvent(type: String, data: [String: Any]) {
    if type == FCPChannelTypes.onCarplayConnectionChange, let status = data["status"] as? String {
      lastConnectionStatus = status
    }

    guard let eventSink = FCPStreamHandlerPlugin.eventSink else {
      return
    }

    eventSink(
      [
        "type": type,
        "data": data,
      ] as [String: Any])
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    FCPStreamHandlerPlugin.eventSink = nil
    return nil
  }
}
