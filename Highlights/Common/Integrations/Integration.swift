//
//  Integration.swift
//  Highlights
//
//  Created by ming yeow ng on 1/24/17.
//  Copyright © 2017 Meow. All rights reserved.
//

import Foundation
import UIKit

protocol Integration {
  func setup(application: UIApplication, launchOptions: [NSObject: AnyObject]?, appCoordinator: AppCoordinator)
  func openURL(URL: NSURL, application: UIApplication, sourceApplication: String?, annotation: AnyObject) -> Bool
  func openURL(URL: NSURL, application: UIApplication, options: [String : AnyObject]) -> Bool
}

extension Integration {
  func openURL(URL: NSURL, application: UIApplication, sourceApplication: String?, annotation: AnyObject) -> Bool {
    return false
  }
  
  func openURL(URL: NSURL, application: UIApplication, options: [String : AnyObject]) -> Bool {
    return false
  }
}

