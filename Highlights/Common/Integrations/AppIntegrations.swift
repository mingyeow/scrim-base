//  AppIntegrations.swift
//  Spark
//
//  Created by Ming on 8/5/16.
//

import UIKit

final class AppIntegrations {
  private let integrations: [Integration]
  
  init(integrations: [Integration]) {
    self.integrations = integrations
  }
  
  func setup(application: UIApplication, launchOptions: [NSObject: AnyObject]?, appCoordinator: AppCoordinator) {
    for integration in integrations {
      integration.setup(application: application, launchOptions: launchOptions, appCoordinator: appCoordinator)
    }
  }
  
  func openURL(url: NSURL, application: UIApplication, sourceApplication: String?, annotation: AnyObject) -> Bool {
    for integration in integrations {
      if integration.openURL(URL: url, application: application, sourceApplication: sourceApplication, annotation: annotation) {
        return true
      }
    }
    
    return false
  }
  
  func openURL(url: NSURL, application: UIApplication, options: [String : AnyObject]) -> Bool {
    for integration in integrations {
      if integration.openURL(URL: url, application: application, options: options) {
        return true
      }
    }
    
    return false
  }
}
