//
//  FacebookIntegration.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/7/16.
//
//

import FBSDKCoreKit

final class FacebookIntegration: Integration {
  // MARK: - Dependencies
  
  private let buildConfiguration = container.resolve(BuildConfiguration.self)!
  private let facebook = FBSDKApplicationDelegate.sharedInstance()
  private weak var appCoordinator: AppCoordinator?
  
  func setup(application: UIApplication, launchOptions: [NSObject: AnyObject]?, appCoordinator: AppCoordinator) {
    FBSDKSettings.setAppID(buildConfiguration.facebookAppID)
    
    facebook?.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func openURL(url: NSURL, application: UIApplication, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return (facebook?.application(application, open: url as URL!, sourceApplication: sourceApplication, annotation: annotation))!
  }
}
