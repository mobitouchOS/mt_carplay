//
//  FCPSharedNowPlaying.swift
//  mt_carplay
//
//  Created by Koen Van Looveren on 16/09/2022.
//

import CarPlay

@available(iOS 14.0, *)
class FCPSharedNowPlayingTemplate {
  /// Registered on the shared template once and kept alive here, because the
  /// template does not promise to retain its observers.
  private static var upNextObserver: FCPNowPlayingUpNextObserver?

  var get: CPTemplate {
    return CPNowPlayingTemplate.shared
  }

  init() {}

  public func update(with: any FCPTemplate) {
    guard let with = with as? FCPSharedNowPlayingTemplate else {
      return
    }
  }

  /// Shows or hides the Up Next button in the top-right corner of the shared
  /// Now Playing template and starts forwarding its taps to Dart.
  static func setUpNextButton(enabled: Bool, title: String?) {
    let template = CPNowPlayingTemplate.shared
    if upNextObserver == nil {
      let observer = FCPNowPlayingUpNextObserver()
      template.add(observer)
      upNextObserver = observer
    }
    if let title = title {
      template.upNextTitle = title
    }
    template.isUpNextButtonEnabled = enabled
  }
}

@available(iOS 14.0, *)
extension FCPSharedNowPlayingTemplate: FCPTemplate {
  var elementId: String {
    return "FCPSharedNowPlayingTemplate"
  }
}

@available(iOS 14.0, *)
private class FCPNowPlayingUpNextObserver: NSObject, CPNowPlayingTemplateObserver {
  func nowPlayingTemplateUpNextButtonTapped(_ nowPlayingTemplate: CPNowPlayingTemplate) {
    FCPStreamHandlerPlugin.sendEvent(
      type: FCPChannelTypes.onNowPlayingUpNextButtonPressed, data: [:])
  }
}
