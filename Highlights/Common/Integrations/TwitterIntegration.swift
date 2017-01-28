//
//  TwitterIntegration.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/9/16.
//
//

import Fabric
import TwitterKit
import Crashlytics

final class TwitterIntegration: Integration {
  // MARK: - Dependencies
  
  private let buildConfiguration = container.resolve(BuildConfiguration.self)!
  private let twitter = Twitter.sharedInstance()
  private var appCoordinator: AppCoordinator?
  
  func setup(application: UIApplication, launchOptions: [NSObject: AnyObject]?, appCoordinator: AppCoordinator) {
    self.appCoordinator = appCoordinator
    twitter.start(withConsumerKey: buildConfiguration.twitterConsumerKey, consumerSecret: buildConfiguration.twitterConsumerSecret)
    Fabric.with([Twitter.self, Crashlytics.self])
    self.appCoordinator = appCoordinator
  }

  func openURL(url: NSURL, application: UIApplication, options: [String : AnyObject]) -> Bool {
    return twitter.application(application, open:url as URL, options: options)
  }
}
