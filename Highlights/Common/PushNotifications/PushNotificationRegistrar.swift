//
//  PushNotificationRegistrar.swift
//  Highlights
//
//  Created by ming yeow ng on 1/25/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


protocol PushNotificationRegistrarDelegate: class {
  func pushNotificationRegistrarDidRegisterForRemoteNotifications(token: String)
}

final class PushNotificationRegistrar {
  private let application: UIApplication
  private let device: UIDevice
  private weak var delegate: PushNotificationRegistrarDelegate?
  
  init(application: UIApplication, device: UIDevice, delegate: PushNotificationRegistrarDelegate) {
    self.application = application
    self.device = device
    self.delegate = delegate
  }
  
  func register() {
    UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
      
      if granted {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    delegate?.pushNotificationRegistrarDidRegisterForRemoteNotifications(token: deviceTokenString)
  }

  func handleFailedRemoteNotificationRegistration(error: NSError) {
    // TODO: handle error here
  }

  func getCurrentSettings(){
    UNUserNotificationCenter.current().getNotificationSettings() {
      (settings) in
        switch settings.soundSetting{
        case .enabled:
          print ("enabled")
        case .disabled:
          print ("disabled")
        case .notSupported:
          print ("not supported")
        }
    }
  }
}
