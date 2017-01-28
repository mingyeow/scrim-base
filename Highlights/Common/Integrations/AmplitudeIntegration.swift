//
//  AmplitudeIntegration.swift
//  Spark
//
//  Created by Teng Siong Ong on 8/6/16.
//
//

import Amplitude_iOS

final class AmplitudeIntegration: Integration {

  private weak var appCoordinator: AppCoordinator?
  
  func setup(application: UIApplication, launchOptions: [NSObject: AnyObject]?, appCoordinator: AppCoordinator) {
    let buildConfiguration = container.resolve(BuildConfiguration.self)!
    Amplitude.instance().initializeApiKey(buildConfiguration.amplitudeKey)
  }
}
