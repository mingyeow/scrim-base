//  PushNotificationPresenter.swift
//  Spark
//
//  Created by Ming Yeow Ng
//
//

import UIKit
import BRYXBanner

protocol PushNotificationPresenterDelegate: class {
  func pushNotificationPresenterDidTap(presenter: PushNotificationPresenter, notification: PushNotification)
}

final class PushNotificationPresenter {
  private struct Constants {
    static let animationDuration: TimeInterval = 10
  }
  
  weak var delegate: PushNotificationPresenterDelegate?
  
  init() {
    // Do nothing
  }
  
  func present(pushNotification: PushNotification) {
    guard let aps = pushNotification.payload["aps"] as? NSDictionary else { return }
    
    let banner: Banner
    
    switch aps["alert"] {
    case let dictionary as NSDictionary:
      guard let message = dictionary["title"] as? String else { return }
      banner = Banner(title: message, backgroundColor: .groupTableViewBackground)
      
    case let string as String:
      banner = Banner(title: string, subtitle: nil, backgroundColor: .groupTableViewBackground)
      
    default:
      return
    }
    
    banner.dismissesOnTap = true
    banner.didTapBlock = {
      self.delegate?.pushNotificationPresenterDidTap(presenter: self, notification: pushNotification)
    }
    banner.show(duration: Constants.animationDuration)
  }
}
